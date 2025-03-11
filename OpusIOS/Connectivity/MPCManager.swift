//
//  MPCManager.swift
//  PartyEat_iOS
//
//  Created by Simone Boscaglia on 10/02/25.
//

import Foundation
import MultipeerConnectivity

class MPCManager : NSObject {
    static let shared: MPCManager = MPCManager() // crea singleton threadsafe: ogni volta che istanzi se esiste già viene presa la copia esistente.
    
    private var peerID = MCPeerID(displayName: UIDevice.current.name) // può essere quello che si vuole, per semplicità mettiamo il nome del telefono
    private lazy var session : MCSession = // Lazy perché dipende da peerID che viene altrimenti verrebbe istanziato insieme a questa variabile
    MCSession(peer: peerID,
              securityIdentity: nil, //accettiamo tutti gli ingressi
              encryptionPreference: .none) //no crittografia, usa UDP in automatico
    
    private lazy var browser : MCNearbyServiceBrowser = MCNearbyServiceBrowser(peer:peerID, serviceType: "opus") // serviceType deve essere unico, se è condiviso da qualcun altro si connetterà insieme
    
    weak var delegate : MPCManagerDelegate?
    // weak: evitare processi zombie nell'iphone. una volta settata una classe come delegato quella rimane in memoria. Weak infatti evita che il contatore degli utilizzi della classe salga di 1, quindi non vale come reference per mantenere una classe in memoria.
    
    private override init() {
        super.init()
        session.delegate = self
        browser.delegate = self
    }
    
    func startService() {
        browser.startBrowsingForPeers()
    }
    
    func stopService() {
        browser.stopBrowsingForPeers()
    }
    func send(message : Message) {
        if let data = message.toData() {
            try? session.send(data, toPeers: session.connectedPeers, with: .unreliable)
        }
    }
}

// Swift usa delegation pattern: funzioni che vengono chiamate in occasioni di interrupt con info che servono per gestirle.

// Nelle extension non si possono dichairare nuove proprietà: va tutto nella classe base, solo computer properties

extension MPCManager : MCSessionDelegate {
    // DIDCHANGE: peer cambia stato ovvero si sta connettendo o disconnettendo
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        var stringState = " "
        
        switch state {
        case .connected: stringState = "Connected"
        case .connecting: stringState = "Connecting"
        case .notConnected: stringState = "Not Connected"
        @unknown default: fatalError("State not recognized: \(state)") // siccome questa enum potrebbe cambiare in futuro
            // e ci sarebbe un errore se c'è un caso non gestito, allora @unknown gestisce tutti i casi che potrebbero
            // essere implementati in futuro in swift
        }
        
        print("\(peerID.displayName): \(stringState)")
    }
    
    // DID RECEIVE:
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        if let message = Message.toMessage(from: data) {
            if let delegate = delegate {
                delegate.mpcManager(self, didReceive: message, from: peerID)
            }
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: (any Error)?) {
    }
    
    
}

extension MPCManager : MCNearbyServiceBrowserDelegate {
    
    // Trovato nuovo peer
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        print("A Peer is found \(peerID.displayName)")
        browser.invitePeer(peerID, to: session, withContext: nil, timeout: 10)
    }
    
    // Un peer se n'è andato
    // MARK: - IMPORTANTE perchè ogni tanto si disconnette a caso, per il debug
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {}
    

}

protocol MPCManagerDelegate : AnyObject  { // per compatibilità con NSObject
    func mpcManager(_ manager: MPCManager, didReceive message: Message, from peer: MCPeerID)
    func mpcManager(_ manager: MPCManager, userIsConnected user: String)
}
