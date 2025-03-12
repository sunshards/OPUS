//
//  GameSceneMPC.swift
//  OpusTV
//
//  Created by Simone Boscaglia on 27/02/25.
//

import MultipeerConnectivity

extension SceneManager : MPCManagerDelegate {
    func mpcManager(_ manager: MPCManager, didReceive message: Message, from peer: MCPeerID) {
        
        if message.type == .gyroscope {
            guard let vector = message.vector else {return}
            self.xGyro = vector.x
            self.yGyro = vector.y
            self.zGyro = vector.z
            if let light = sceneManager.light {
                guard let sensibility = light.sensibility else {print("light has no sensibility"); return}
                light.move(to: CGPoint(x: -xGyro * sensibility, y: yGyro * sensibility))
            }
        }
        
        else if message.type == .heartrate {
            self.heartRate = Double(message.vector?.x ?? -1)
        }
        
        else if message.type == .calibration {
            guard let state = message.state else {return}
            if state == true {
                recalibrate()
            }
        }
        
        else if message.type == .touch {
            phoneTouch()
        }
    }
    
    func mpcManager(_ manager: MPCManager, userIsConnected user: String) {
        mpcManager.iPhoneConnected = true
    }
    
    
}
