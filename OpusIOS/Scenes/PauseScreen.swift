//
//  pauseScreen.swift
//  OpusIOS
//
//  Created by Andrea Iannaccone on 11/03/25.
//

import SpriteKit

class pauseScreen: SKScene {
    
    let mpcManager = MPCManager.shared
    
    var sceneCalibrate: SKScene {
        let scene = SKScene(fileNamed: "Calibrazione")
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
        self.size = screenSize
            
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let title = childNode(withName: "backtotitle") as! SKSpriteNode
        let resume = childNode(withName: "resume") as! SKSpriteNode
        let calibrate = childNode(withName: "calibrate") as! SKSpriteNode
        let touchLocation = touches.first?.location(in: self) ?? CGPoint.zero
        if (title.contains(touchLocation)){
            let titleScreen = Message(type: nil, pauseAction: .backtotitle, vector: nil, state: nil)
            mpcManager.send(message: titleScreen)
            scene?.view?.presentScene((childNode(withName: "GameScene") as! SKScene))
        }
        if(calibrate.contains(touchLocation)){
            let calibrateScreen = Message(type: nil, pauseAction: .calibration, vector: nil, state: nil)
            mpcManager.send(message: calibrateScreen)
            scene?.view?.presentScene(sceneCalibrate)
        }
        if(resume.contains(touchLocation)){
            let resume = Message(type: nil, pauseAction: .resume, vector: nil, state: nil)
            mpcManager.send(message: resume)
            scene?.view?.presentScene((childNode(withName: "GameScene") as! SKScene))
        }
        
    }
}
