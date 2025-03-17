//
//  PhoneManager.swift
//  OpusIOS
//
//  Created by Simone Boscaglia on 16/03/25.
//

import SpriteKit
import CoreMotion
import CoreHaptics

class PhoneManager {
    static let shared: PhoneManager = PhoneManager() //singleton
    let mpcManager = MPCManager.shared
    let wcManager = WCManager.shared
    
    var scene : SKScene? = nil
    var sceneName : String? = nil
    var previousSceneName : String? = nil
    
    let motionManager = CMMotionManager()
    let gyroBound : Double = 0.05
    private var referenceAttitude : CMAttitude?
    var hapticEngine : CHHapticEngine
    
    let hapticDict = [
        CHHapticPattern.Key.pattern: [
            [CHHapticPattern.Key.event: [
                CHHapticPattern.Key.eventType: CHHapticEvent.EventType.hapticTransient,
                CHHapticPattern.Key.time: CHHapticTimeImmediate,
                CHHapticPattern.Key.eventDuration: 1.0]
            ]
        ]
    ]
    var hapticPlayer : CHHapticPatternPlayer?
    var vibrationPattern : CHHapticPattern? = nil

    
    private init() {
        self.hapticEngine = PhoneManager.setupHaptics()
        do {
            self.vibrationPattern = try CHHapticPattern(dictionary: hapticDict)
            self.hapticPlayer = try hapticEngine.makePlayer(with: vibrationPattern!)
        } catch let error {
            fatalError("Failed to create vibration player: \(error)")
        }

        mpcManager.delegate = self
        wcManager.delegate = self
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
                let message = Message(type: .gyroscope, vector : attitudeVector)
                self.mpcManager.send(message: message)
            }
        }
    }
    
    func calibrate() {
        if let currentAttitude = motionManager.deviceMotion?.attitude {
            referenceAttitude = currentAttitude.copy() as? CMAttitude
            //print("Attitude frame reset!")
        }
        
        let message = Message(type: .endCalibration, vector: nil, state: true)
        self.mpcManager.send(message: message)
    }
    
    func changeScreen(name : String) {
        if let oldName = self.sceneName {
            self.previousSceneName = oldName
        }
        self.sceneName = name
        scene?.view?.presentScene(ScreenUtilities.getScreen(name: name))
    }
    
    func previousScreen() {
        if let oldSceneName = self.previousSceneName {
            self.changeScreen(name: oldSceneName)
        } else {
            print("previous screen name could not find previous screen; ")
            return
        }
    }
    
    static func setupHaptics() -> CHHapticEngine {
        // Check if the device supports haptics.
        let hapticCapability = CHHapticEngine.capabilitiesForHardware()
        guard hapticCapability.supportsHaptics == true else {
            fatalError("Could not get haptic capabilities")
        }
        let engine : CHHapticEngine
        do {
            engine = try CHHapticEngine()
        } catch let error {
            fatalError("Engine Creation Error: \(error)")
        }
        // The reset handler provides an opportunity to restart the engine.
        engine.resetHandler = {
            
            print("Reset Handler: Restarting the engine.")
            
            do {
                // Try restarting the engine.
                try engine.start()
                        
                // Register any custom resources you had registered, using registerAudioResource.
                // Recreate all haptic pattern players you had created, using createPlayer.


            } catch {
                fatalError("Failed to restart the engine: \(error)")
            }
            // The stopped handler alerts engine stoppage.
            engine.stoppedHandler = { reason in
                print("Stop Handler: The engine stopped for reason: \(reason.rawValue)")
                switch reason {
                case .audioSessionInterrupt: print("Audio session interrupt")
                case .applicationSuspended: print("Application suspended")
                case .idleTimeout: print("Idle timeout")
                case .systemError: print("System error")
                case .notifyWhenFinished: print("finished")
                case .engineDestroyed: print("destroyed")
                case .gameControllerDisconnect: print("game controller disconnect")
                @unknown default:
                    print("Unknown error")
                }
            }
        }
        return engine
    }
    
    func vibrate() {
        do {
            try hapticEngine.start()
            try hapticPlayer?.start(atTime: 0)
            hapticEngine.stop(completionHandler: nil)
        } catch let error {
            print("Error in vibrate: \(error)")
        }
    }
    
}
