//
//  WCDelegate.swift
//  OpusIOS
//
//  Created by Simone Boscaglia on 11/03/25.
//

extension PhoneManager : WCManagerDelegate {
    func wcManager(_ manager: WCManager, didReceive message: WatchMessage) {
        mpcManager.send(message: Message(type: .heartrate, pauseAction: nil, vector: Vector3D(x: message.heartRate, y: 0, z: 0)))
    }
    
}
