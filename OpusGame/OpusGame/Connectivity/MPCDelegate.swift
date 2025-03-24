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
            self.watchConnected = true
            self.heartRate = Double(message.vector?.x ?? -1)
            sceneManager.collectHeartRate(rate: heartRate)
            self.updateTitleIcons()
        }
        
        else if message.type == .startCalibration {
            sceneManager.light?.disable()
        }
        
        else if message.type == .endCalibration {
            guard let state = message.state else {print("end calibration with no state"); return}
            if state == true {
                sceneManager.light?.enable()
                recalibrate()
                sceneManager.unpause()
            }
        }
        
        else if message.type == .touch {
            phoneTouch()
        }
        
        else if message.type == .back {
            switchToMinigame(newState: .hidden)
        }
        
        else if message.type == .yes {
            switchToMinigame(newState: .labirinto)
            sceneManager.unpause()
        }
        
        else if message.type == .no {
            let message = Message(type: .no, vector: nil, state: nil)
            sceneManager.mpcManager.send(message: message)
            sceneManager.unpause()
        }
        
        else if message.type == .pause {
            sceneManager.pause()
        }
        
        else if message.type == .resume {
            sceneManager.unpause()
        }
        
    }
    
    func mpcManager(_ manager: MPCManager, userIsConnected user: String) {
        print(user)
    }
    
    func mpcManager(_ manager: MPCManager, device: deviceType, active : Bool) {
        print(device, active)
        if device == .iphone {
            iphoneConnected = active
        } else {
            watchConnected = active
        }
        sceneManager.updateTitleIcons()
    }

}
