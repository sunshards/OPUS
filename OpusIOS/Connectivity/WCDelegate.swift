//
//  WCDelegate.swift
//  OpusIOS
//
//  Created by Simone Boscaglia on 11/03/25.
//

class WCDelegate : WCManagerDelegate {
    let wcManager = WCManager.shared
    let mpcManager = MPCManager.shared
    
    init() {
        wcManager.delegate = self
    }
    
    func wcManager(_ manager: WCManager, didReceive message: WatchMessage) {
        mpcManager.send(message: Message(type: .heartrate, vector: Vector3D(x: message.heartRate, y: 0, z: 0)))
    }
    
}
