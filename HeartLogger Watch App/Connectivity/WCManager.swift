//
//  WCManager.swift
//  OpusIOS
//
//  Created by Simone Boscaglia on 11/03/25.
//

import WatchConnectivity

class WCManager: NSObject, WCSessionDelegate {
    public static let shared = WCManager()
    weak var delegate : WCManagerDelegate?
    private var session: WCSession = WCSession.default

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: (any Error)?) {
        print("activation did complete")
    }

    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        if let messageData = message["data"] as? WatchMessage {
            if let delegate {
                delegate.wcManager(self, didReceive: messageData)
            }
        }
    }
    
    private override init() {
        super.init()
        session.delegate = self
        startService()
    }
    
    func startService() {
        session.activate()
    }
    
    func send(message : WatchMessage) {
        if let data = message.toData() {
            session.sendMessage(["data" : data], replyHandler: nil)
        }
    }

}
protocol WCManagerDelegate : AnyObject  { // per compatibilità con NSObject
    func wcManager(_ manager: WCManager, didReceive message: WatchMessage)
}
