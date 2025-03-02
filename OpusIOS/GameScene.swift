//
//  GameScene.swift
//  templateSpriteKit
//
//  Created by Ignazio Finizio on 07/04/22.
//

import SpriteKit
import CoreMotion

class GameScene: SKScene {
    let mpcManager = MPCManager.shared
    let motionManager = CMMotionManager()
    var xGyroTotal : Double = 0.0
    var yGyroTotal : Double = 0.0
    var zGyroTotal : Double = 0.0

    let gyroBound : Double = 0.05
    
    private var referenceAttitude : CMAttitude?
    
    var screenSize : CGSize {
        var deviceWidth = view?.window?.windowScene?.screen.bounds.width ?? 0
        var deviceHeight = view?.window?.windowScene?.screen.bounds.height ?? 0
        if (deviceWidth < deviceHeight) { // The orientation is not right
            swap(&deviceWidth, &deviceHeight)
        }
        return CGSize(width: deviceWidth, height: deviceHeight)
    }
    
    override func didMove(to view: SKView) {
        mpcManager.startService()
        
        self.size = screenSize
        
        if motionManager.isGyroAvailable {
            motionManager.gyroUpdateInterval = 0.001
            motionManager.startGyroUpdates(to: OperationQueue.main) { (data, error) in
                guard let rotation = data?.rotationRate else {return}
                if abs(rotation.x) > self.gyroBound { self.xGyroTotal += rotation.x }
                if abs(rotation.y) > self.gyroBound { self.yGyroTotal += rotation.y }
                if abs(rotation.z) > self.gyroBound { self.zGyroTotal += rotation.z }

                //print(self.xGyroTotal, self.yGyroTotal, self.zGyroTotal)
                //let gyroVector = Vector3D(x: self.xGyroTotal, y: self.yGyroTotal, z: self.zGyroTotal)
                //let message = Message(type: .gyroscope, vector : gyroVector)
                //self.mpcManager.send(message: message)
            }
        }
        
        if motionManager.isAccelerometerAvailable {
            motionManager.accelerometerUpdateInterval = 0.001
            motionManager.startAccelerometerUpdates(to: OperationQueue.main) { (data, error) in
                guard let acceleration = data?.acceleration else {return}
                let accVector = Vector3D(x: acceleration.x, y: acceleration.y, z: acceleration.z)
                //print(accVector)
                let message = Message(type: .accelerometer, vector : accVector)
                //self.mpcManager.send(message: message)
            }
            
            
        }
        
        guard motionManager.isDeviceMotionAvailable else {
                    print("Device motion is not available.")
                    return
                }
                
        motionManager.deviceMotionUpdateInterval = 0.1 // Update every 0.1 seconds
        motionManager.startDeviceMotionUpdates(to: .main) {  (motion, error) in
            guard let motion = motion, error == nil else {
                print("Error: \(String(describing: error))")
                return
            }
                        
            print("Roll: \(motion.attitude.roll)")   // Rotation around x-axis (rad)
            print("Pitch: \(motion.attitude.pitch)") // Rotation around y-axis (rad)
            print("Yaw: \(motion.attitude.yaw)")     // Rotation around z-axis (rad)
            
            if let reference = self.referenceAttitude {
                motion.attitude.multiply(byInverseOf: reference)
            }
            else {
                self.referenceAttitude = motion.attitude
                let reference = motion.attitude
                motion.attitude.multiply(byInverseOf: reference)
           }

            //print(self.xGyroTotal, self.yGyroTotal, self.zGyroTotal)
            let attitudeVector = Vector3D(x: motion.attitude.yaw, y: motion.attitude.pitch, z: motion.attitude.roll)
            let message = Message(type: .gyroscope, vector : attitudeVector)
            self.mpcManager.send(message: message)
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let currentAttitude = motionManager.deviceMotion?.attitude {
            referenceAttitude = currentAttitude.copy() as? CMAttitude
            print("Attitude frame reset!")
        }
        self.xGyroTotal = 0
        self.yGyroTotal = 0
        self.zGyroTotal = 0
        let message = Message(type: .calibration, vector: nil, state: true)
        self.mpcManager.send(message: message)
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

