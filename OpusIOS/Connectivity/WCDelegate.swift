//
//  WCDelegate.swift
//  OpusIOS
//
//  Created by Simone Boscaglia on 11/03/25.
//

class WCDelegate : WCManagerDelegate {
    let wcManager = WCManager.shared
    init() {
        wcManager.delegate = self
    }
    
    func wcManager(_ manager: WCManager, didReceive message: WatchMessage) {
        print(message.heartRate)
    }
    
}
