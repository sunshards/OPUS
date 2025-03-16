//
//  GameScene.swift
//  opusTV
//
//  Created by Simone Boscaglia on 16/03/2025.
//

import SpriteKit
import CoreMotion

class MainScreen: SKScene {
    
    let phoneManager = PhoneManager.shared
    let mpcManager = MPCManager.shared
    
    var hasCalibrated = false
    
    var pauseScreen: SKScene {
        let scene = SKScene(fileNamed: "pauseScreen")
        print("\(String(describing: scene?.sceneDidLoad()))")
        scene?.scaleMode = .aspectFill
        return scene!
    }
    
    override func didMove(to view: SKView) {
        ScreenUtilities.setBodiesTransparency(scene: scene!)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchLocation = touches.first!.location(in: self)
        let node = self.atPoint(touchLocation)
        if (node.name == "PauseButton") {
            scene?.view?.presentScene(ScreenUtilities.getScreen(name: "PauseScreen"))
        }
        else if (node.name == "body") {
            guard let buttonName = node.parent?.name else { return }
            ScreenUtilities.activateButton(body: node)
            
            if buttonName == "ActButton" {
                let message = Message(type: .touch, pauseAction: nil, vector: nil, state: nil)
                mpcManager.send(message: message)
            }
        }
        if (!hasCalibrated) {
            phoneManager.calibrate()
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let body = ScreenUtilities.anchoredBody {
            body.position = touches.first!.location(in: self)
        }
        
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchLocation = touches.first!.location(in: self)
        let node = self.atPoint(touchLocation)
        if (node.name == "body") {
            ScreenUtilities.deactivateButton(body: node)
        }
    }
    
}

