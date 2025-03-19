//
//  GameSceneMPC.swift
//  OpusTV
//
//  Created by Simone Boscaglia on 27/02/25.
//

import MultipeerConnectivity

extension PhoneManager : MPCManagerDelegate {
    func mpcManager(_ manager: MPCManager, didReceive message: Message, from peer: MCPeerID) {
        
        if message.type == .back {
            self.vibrate()
            self.changeScreen(name: "BackScreen")
        }
        
        else if message.type == .confirm {
            self.vibrate()
            self.changeScreen(name: "ConfirmScreen")
        }
        
        else if message.type == .no {
            self.changeScreen(name: "MainScreen")
        }
        
        else if message.type == .vibration {}
    }
    
    func mpcManager(_ manager: MPCManager, userIsConnected user: String) {}
}
