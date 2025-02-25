//
//  UserConnection.swift
//  PartyEat_tvOS
//
//  Created by Andrea Iannaccone on 24/02/25.
//

import Foundation
import MultipeerConnectivity

class PhoneConnection : MPCManagerDelegate {
    static let shared: PhoneConnection = PhoneConnection()
    // crea singleton threadsafe: ogni volta che istanzi se esiste già viene presa la copia esistente.
    
    var xPerc : CGFloat = 0.0
    var yPerc : CGFloat = 0.0
    let mpcManager = MPCManager.shared
    
    init () {
        mpcManager.delegate = self
    }
    
    
    // HANDLING DEL MESSAGGIO
    func mpcManager(_ manager: MPCManager, didReceive message: Message, from peer: MCPeerID) {
        self.xPerc = message.xPerc
        self.yPerc = message.yPerc
    }
    
    // AZIONE DI QUANDO SI CONNETTE UN DEVICE
    func mpcManager(_ manager: MPCManager, userIsConnected user: String) {
        
    }
    
    
}
