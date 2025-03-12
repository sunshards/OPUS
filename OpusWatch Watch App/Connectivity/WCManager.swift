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

    private override init() {
        self.session = WCSession.default
        super.init()
        session.delegate = self
        startService()
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: (any Error)?) {
        if let error {
            print("session activation failed with error: \(error.localizedDescription)")
        } else {
            print("activation did complete : \(activationState)")
        }
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        if let messageData = message["data"] {
            if let delegate {
                delegate.wcManager(self, didReceive: WatchMessage.toMessage(from: messageData as! Data)!)
            }
        }
    }
    
    func startService() {
        session.activate()
    }
    
    func send(message : WatchMessage) {
        if session.isReachable {
            if let data = message.toData() {
                session.sendMessage(["data" : data], replyHandler: nil)
            }
        } else {
            print("Session is not reachable")
        }
    }

}
protocol WCManagerDelegate : AnyObject  { // per compatibilità con NSObject
    func wcManager(_ manager: WCManager, didReceive message: WatchMessage)
}
