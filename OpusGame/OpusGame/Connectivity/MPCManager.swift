//
//  MPCManager.swift
//  OpusTV
//
//  Created by Simone Boscaglia on 10/02/25.
//

import Foundation
import MultipeerConnectivity
import SwiftUI

protocol MPCManagerDelegate : AnyObject  { // per compatibilità con NSObject
    func mpcManager(_ manager: MPCManager, didReceive message: Message, from peer: MCPeerID)
    func mpcManager(_ manager: MPCManager, userIsConnected user: String)
    func mpcManager(_ manager: MPCManager, device: deviceType, active : Bool)
}

class MPCManager : NSObject,ObservableObject {
    
    static let shared: MPCManager = MPCManager() // crea singleton threadsafe: ogni volta che istanzi se esiste già viene presa la copia esistente.
    
    private var peerID = MCPeerID(displayName: UIDevice.current.name) // può essere quello che si vuole, per semplicità mettiamo il nome del telefono
    private lazy var session : MCSession =
    MCSession(peer: peerID,
              securityIdentity: nil, //accettiamo tutti gli ingressi
              encryptionPreference: .none) //no crittografia, usa UDP in automatico
    
    private lazy var advertiser : MCNearbyServiceAdvertiser = MCNearbyServiceAdvertiser(peer:peerID, discoveryInfo: nil, serviceType: "opus") // serviceType deve essere unico, se è condiviso da qualcun altro si connetterà insieme
    
    weak var delegate : MPCManagerDelegate?
    // weak: evitare processi zombie nell'iphone. una volta settata una classe come delegato quella rimane in memoria. Weak infatti evita che il contatore degli utilizzi della classe salga di 1, quindi non vale come reference per mantenere una classe in memoria.
    
    private override init() {
        super.init()
        session.delegate = self
        advertiser.delegate = self
    } // inizializzatore non deve essere accessibile dall'esterno
    
    func startService() {
        advertiser.startAdvertisingPeer()
    }
    
    func stopService() {
        advertiser.stopAdvertisingPeer()
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
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        var connection : Bool = false
        switch state {
            case .connected: connection = true
            case .connecting: connection = false
            case .notConnected: connection = false
            @unknown default: fatalError("State not recognized: \(state)")
        }
        delegate?.mpcManager(self, device: .iphone, active: connection)
    }
    
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

extension MPCManager : MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        invitationHandler(true, self.session)
        delegate?.mpcManager(self, userIsConnected: peerID.displayName)
        // MARK: - Cambiare qui se non si vogliono accettare tutte le connessioni
    }
}

