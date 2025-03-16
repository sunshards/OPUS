//
//  GameScene.swift
//  opusTV
//
//  Created by Andrea Iannaccone on 03/02/25.
//

import SpriteKit
import CoreMotion
import _SpriteKit_SwiftUI

class ConfirmScreen: SKScene {
    let mpcManager = MPCManager.shared
    let wcManager = WCManager.shared
    let wcDelegate = WCDelegate()
    let motionManager = CMMotionManager()
    
    var hasCalibrated : Bool = false

    let gyroBound : Double = 0.05
    
    private var referenceAttitude : CMAttitude?
    
    var pauseScreen: SKScene {
        let scene = SKScene(fileNamed: "pauseScreen")
        print("\(String(describing: scene?.sceneDidLoad()))")
        scene?.scaleMode = .aspectFill
        return scene!
    }
    
    override func didMove(to view: SKView) {
        mpcManager.startService()
        
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let button = childNode(withName: "button") as! SKSpriteNode
        let touchLocation = touches.first!.location(in: self)
        if (!hasCalibrated) {
            if let currentAttitude = motionManager.deviceMotion?.attitude {
                referenceAttitude = currentAttitude.copy() as? CMAttitude
                print("Attitude frame reset!")
            }
            
            let message = Message(type: .calibration, pauseAction: nil, vector: nil, state: true)
            self.mpcManager.send(message: message)
            hasCalibrated = true
        } else {
            let message = Message(type: .touch, pauseAction: nil, vector: nil, state: nil)
            self.mpcManager.send(message: message)

        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {}
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {}
    
    
}

