//
//  WCDelegate.swift
//  OpusIOS
//
//  Created by Simone Boscaglia on 11/03/25.
//

class WCDelegate : WCManagerDelegate {
    func wcManager(_ manager: WCManager, didReceive message: WatchMessage) {
        print(message.heartRate)
    }
    
}
