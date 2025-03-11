//
//  pauseScreen.swift
//  OpusIOS
//
//  Created by Andrea Iannaccone on 11/03/25.
//

import SpriteKit

class pauseScreen: SKScene {
    
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
            
        }
        if(calibrate.contains(touchLocation)){
            scene?.view?.presentScene(sceneCalibrate)
        }
        if(resume.contains(touchLocation)){
            
        }
        
    }
}
