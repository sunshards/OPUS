//
//  GameScene.swift
//  templateSpriteKit
//
//  Created by Ignazio Finizio on 07/04/22.
//

import SpriteKit

class GameScene: SKScene {
    
    // START OF THE GAME
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "bg")
        background.position = CGPoint(x: 0 , y: 0)
        scene?.addChild(background)
    }
    
    
}
