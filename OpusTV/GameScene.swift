//
//  GameScene.swift
//  templateSpriteKit
//
//  Created by Ignazio Finizio on 07/04/22.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let mpcManager: MPCManager = MPCManager.shared
//    let device : PhoneConnection = PhoneConnection.shared
    var objectSelected : Bool = false
    
    
    var width : CGFloat = 1920
    var height : CGFloat = 1080
    
    var light : Light?
    let sensibility : CGFloat = 2000//30
    
    var xGyro : CGFloat = 0.0
    var yGyro : CGFloat = 0.0
    var zGyro : CGFloat = 0.0
    
    var xAcc : CGFloat = 0.0
    var yAcc : CGFloat = 0.0
    var zAcc : CGFloat = 0.0

    var displayedRoom : Int = 0
    
    // START OF THE GAME
    override func didMove(to view: SKView) {
        mpcManager.delegate = self
        physicsWorld.contactDelegate = self
        
        mpcManager.startService()
        
        let lightNode = childNode(withName: "torch") as! SKLightNode
        let cursor = childNode(withName: "cursor") as! SKSpriteNode
        light = Light(lightNode: lightNode, cursor: cursor, scene: self)
        
//        let chest = InteractiveSprite(texture: SKTexture(imageNamed: "paper"), color: .clear, size: CGSize(width: 100, height: 100)) { sprite in
////            sprite.run(SKAction.sequence([
////                SKAction.scale(by: 1.2, duration: 0.2),
////                SKAction.scale(to: 1.0, duration: 0.2)
////            ]))
//            print("Chest opened at position: \(sprite.position)")
//        }
//        chest.position = CGPoint(x: 0, y: 0)
//        addChild(chest)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {}
    
    func didEnd(_ contact: SKPhysicsContact) {}
    
    
    override func update(_ currentTime: TimeInterval) {
        light?.smoothUpdate()
        light?.highlightObjects()

    }
    
    func switchScene() {
        let sala = childNode(withName: "sala")
        let room = childNode(withName: "test")
        
        if displayedRoom == 0 {
            sala?.position = CGPoint(x:0, y:0)
            room?.position = CGPoint(x:3000, y:3000)
        } else if displayedRoom == 1 {
            sala?.position = CGPoint(x:3000, y:3000)
            room?.position = CGPoint(x:0, y:0)
        }
        
    }
    
    func phoneTouch() {
        if displayedRoom == 0 { displayedRoom = 1 } else { displayedRoom = 0 }
        switchScene()
        let cursor = childNode(withName: "cursor") as! SKSpriteNode
        guard let cursorBody = cursor.physicsBody else { return }
        
        let contacts = cursorBody.allContactedBodies()
        for sprite in contacts {
            if let interactive = sprite.node as? InteractiveSprite {
                interactive.action?(interactive)
            }
        }
    }
    
    func recalibrate() {
        light?.setPosition(to:CGPoint.zero)
    }
    
    
}

