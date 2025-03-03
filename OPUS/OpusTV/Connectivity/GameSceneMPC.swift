//
//  GameSceneMPC.swift
//  OpusTV
//
//  Created by Simone Boscaglia on 27/02/25.
//

import MultipeerConnectivity

extension GameScene : MPCManagerDelegate {
    func mpcManager(_ manager: MPCManager, didReceive message: Message, from peer: MCPeerID) {
        if message.type == .gyroscope {
            guard let vector = message.vector else {return}
            self.xGyro = vector.x
            self.yGyro = vector.y
            self.zGyro = vector.z
//            print("x: \(xGyro), y: \(yGyro), z: \(zGyro)")
        } else if message.type == .accelerometer {
            guard let vector = message.vector else {return}
            self.xAcc = vector.x
            self.yAcc = vector.y
            self.zAcc = vector.z
        } else if message.type == .calibration {
            guard let state = message.state else {return}
            if state == true {
                recalibrate()
            }
        }
    }
    
    func mpcManager(_ manager: MPCManager, userIsConnected user: String) {
        
    }
    
    
}
