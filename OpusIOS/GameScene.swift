//
//  GameScene.swift
//  templateSpriteKit
//
//  Created by Ignazio Finizio on 07/04/22.
//

import SpriteKit

class GameScene: SKScene {
    let mpcManager = MPCManager.shared

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
        print(screenSize)

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let touchLocation = touch!.location(in: self)

        let xPerc = touchLocation.x / screenSize.width
        let yPerc = touchLocation.y / screenSize.height
        
        let message = Message(xPerc: xPerc, yPerc: yPerc)
        mpcManager.send(message: message)
        
        //print("x: \(Int(xPerc*100))%, y: \(Int(yPerc*100))%")
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let touch = touches.first
//        let touchLocation = touch!.location(in: self)
//        let node = self.atPoint(touchLocation)
//        if (node.name == "myNode") {
//        }
    }
    
    
}
