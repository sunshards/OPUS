//
//  GameScene.swift
//  templateSpriteKit
//
//  Created by Ignazio Finizio on 07/04/22.
//

import SpriteKit

class GameScene: SKScene {
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
        print(screenSize)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let touchLocation = touch!.location(in: self)

        let xPerc = touchLocation.x / screenSize.width * 100
        let yPerc = touchLocation.y / screenSize.height * 100
        print("x: \(Int(xPerc))%, y: \(Int(yPerc))%")
        
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let touch = touches.first
//        let touchLocation = touch!.location(in: self)
//        let node = self.atPoint(touchLocation)
//        if (node.name == "myNode") {
//        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let touch = touches.first
//        let touchLocation = touch!.location(in: self)
//        let node = self.atPoint(touchLocation)
//        if (node.name == "myNode") {
//        }
    }
    
    
}
