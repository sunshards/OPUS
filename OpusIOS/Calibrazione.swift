//
//  Calibrazione.swift
//  OpusIOS
//
//  Created by Andrea Iannaccone on 10/03/25.
//

import SpriteKit

class Calibrazione: SKScene{
    let mpcManager = MPCManager.shared

    var mainScene: SKScene {
        let scene = SKScene(fileNamed: "GameScene")
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
        let ack = childNode(withName: "ack") as! SKSpriteNode
        let touchLocation = touches.first!.location(in: self)
        print("\(ack.contains(touchLocation))")
        if ack.contains(touchLocation) {
            let message = Message(type: .calibration, vector: nil, state: true)
            mpcManager.send(message: message)
            print("fatto")
            scene?.view?.presentScene(mainScene)
        }
    }
}
