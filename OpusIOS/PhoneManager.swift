//
//  PhoneManager.swift
//  OpusIOS
//
//  Created by Simone Boscaglia on 16/03/25.
//

import SpriteKit
import CoreMotion

class PhoneManager {
    static let shared: PhoneManager = PhoneManager() //singleton
    let mpcManager = MPCManager.shared
    let wcManager = WCManager.shared
    
    var currentScene : SKScene? = nil
    let motionManager = CMMotionManager()
    let gyroBound : Double = 0.05
    private var referenceAttitude : CMAttitude?
    
    private init() {
        mpcManager.startService()
        wcManager.delegate = self

        if motionManager.isDeviceMotionAvailable {
            motionManager.deviceMotionUpdateInterval = 0.02
            motionManager.startDeviceMotionUpdates(to: .main) {  (motion, error) in
                guard let motion = motion, error == nil else { print("Error: \(String(describing: error))"); return}
                
                //            print("Roll: \(motion.attitude.roll)")   // Rotation around x-axis (rad)
                //            print("Pitch: \(motion.attitude.pitch)") // Rotation around y-axis (rad)
                //            print("Yaw: \(motion.attitude.yaw)")     // Rotation around z-axis (rad)
                
                if let reference = self.referenceAttitude {
                    motion.attitude.multiply(byInverseOf: reference)
                } else {
                    self.referenceAttitude = motion.attitude
                    let reference = motion.attitude
                    motion.attitude.multiply(byInverseOf: reference)
                }
                
                let attitudeVector = Vector3D(x: motion.attitude.yaw, y: motion.attitude.pitch, z: motion.attitude.roll)
                let message = Message(type: .gyroscope, pauseAction: nil, vector : attitudeVector)
                self.mpcManager.send(message: message)
            }
        }
    }
    
    func calibrate() {
        if let currentAttitude = motionManager.deviceMotion?.attitude {
            referenceAttitude = currentAttitude.copy() as? CMAttitude
            //print("Attitude frame reset!")
        }
        
        let message = Message(type: .calibration, pauseAction: nil, vector: nil, state: true)
        self.mpcManager.send(message: message)
    }
    
}
