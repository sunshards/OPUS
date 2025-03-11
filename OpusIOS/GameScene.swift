//
//  GameScene.swift
//  templateSpriteKit
//
//  Created by Ignazio Finizio on 07/04/22.
//

import SpriteKit
import CoreMotion
import _SpriteKit_SwiftUI

class GameScene: SKScene {
    let mpcManager = MPCManager.shared
    let motionManager = CMMotionManager()
    var xGyroTotal : Double = 0.0
    var yGyroTotal : Double = 0.0
    var zGyroTotal : Double = 0.0
    
    var hasCalibrated : Bool = false

    let gyroBound : Double = 0.05
    
    private var referenceAttitude : CMAttitude?
    
    var pauseScreen: SKScene {
        let scene = SKScene(fileNamed: "pauseScreen")
        print("\(scene?.sceneDidLoad())")
        scene?.scaleMode = .aspectFill
        return scene!
    }
    
    var screenSize : CGSize {
        var deviceWidth = view?.window?.windowScene?.screen.bounds.width ?? 0
        var deviceHeight = view?.window?.windowScene?.screen.bounds.height ?? 0
        if (deviceWidth < deviceHeight) { // The orientation is not right
            swap(&deviceWidth, &deviceHeight)
        }
        return CGSize(width: deviceWidth, height: deviceHeight)
    }
    
    override func didMove(to view: SKView) {
        _ = childNode(withName: "button") as! SKSpriteNode
        //self.size = screenSize
        mpcManager.startService()
        
        if motionManager.isDeviceMotionAvailable {
            
            motionManager.deviceMotionUpdateInterval = 0.02 // Update every 0.1 seconds
            motionManager.startDeviceMotionUpdates(to: .main) {  (motion, error) in
                guard let motion = motion, error == nil else {
                    print("Error: \(String(describing: error))")
                    return
                }
                //            print("Roll: \(motion.attitude.roll)")   // Rotation around x-axis (rad)
                //            print("Pitch: \(motion.attitude.pitch)") // Rotation around y-axis (rad)
                //            print("Yaw: \(motion.attitude.yaw)")     // Rotation around z-axis (rad)
                
                if let reference = self.referenceAttitude {
                    motion.attitude.multiply(byInverseOf: reference)
                }
                else {
                    self.referenceAttitude = motion.attitude
                    let reference = motion.attitude
                    motion.attitude.multiply(byInverseOf: reference)
                }
                let attitudeVector = Vector3D(x: motion.attitude.yaw, y: motion.attitude.pitch, z: motion.attitude.roll)
                let message = Message(type: .gyroscope, vector : attitudeVector)
                self.mpcManager.send(message: message)
            }
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let button = childNode(withName: "button") as! SKSpriteNode
        let touchLocation = touches.first!.location(in: self)
        print("Touch: (\(touchLocation))")
        if (!hasCalibrated) {
            if let currentAttitude = motionManager.deviceMotion?.attitude {
                referenceAttitude = currentAttitude.copy() as? CMAttitude
                print("Attitude frame reset!")
            }
            self.xGyroTotal = 0
            self.yGyroTotal = 0
            self.zGyroTotal = 0
            let message = Message(type: .calibration, vector: nil, state: true)
            self.mpcManager.send(message: message)
            hasCalibrated = true
        } else {
            if(button.contains(touchLocation)){
                print("toccato")
                scene?.view?.presentScene(pauseScreen)
            }
            let message = Message(type: .touch, vector: nil, state: nil)
            self.mpcManager.send(message: message)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        /*let touch = touches.first
         let touchLocation = touch!.location(in: self)
         
         let xPerc = touchLocation.x / screenSize.width
         let yPerc = touchLocation.y / screenSize.height
         
         let message = Message(xPerc: xPerc, yPerc: yPerc)
         mpcManager.send(message: message)*/
        
        //print("x: \(Int(xPerc*100))%, y: \(Int(yPerc*100))%")
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    
}

