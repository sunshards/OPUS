//
//  GameScene.swift
//  OpusTV
//
//  Created by Simone Boscaglia on 13/02/25.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var width : CGFloat = 1920
    var height : CGFloat = 1080

    let lightSensibility : CGFloat = 2000
    
    // START OF THE GAME
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        
        sceneManager.assignScene(scene: scene!)
        sceneManager.textManager = TextManager(textNode: childNode(withName: "Text") as! SKLabelNode)
        sceneManager.textManager.hideText()
        
        sceneManager.light?.setSensibility(sensibility: lightSensibility)
        
        laboratorio.assignNode(node: childNode(withName: "laboratorio"))
        titolo.assignNode(node: childNode(withName: "title"))
        libreria.assignNode(node:childNode(withName: "libreria"))
        sala.assignNode(node:childNode(withName: "sala"))
        cucina.assignNode(node:childNode(withName: "cucina"))
        sceneManager.populate()
        sceneManager.mostro.spawn(position: .zero, room: cucina)

        let inventoryNode = SKNode()
        addChild(inventoryNode)
        sceneManager.inventory.assignNode(n: inventoryNode)
        sceneManager.inventory.regenerateNode()

        if (sceneManager.hasInitializedMainScene == false) {
            sceneManager.selectRoom(.sala)
            sceneManager.switchToMinigame(state: .intro)
            sceneManager.hasInitializedMainScene = true
        } else {
            sceneManager.selectRoom(sceneManager.sceneState)
        }
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        //print("beginContact: ", contact.bodyA.node?.name, contact.bodyB.node?.name)
        if contact.bodyA.node?.name == "cursor" {
            if let interactive = contact.bodyB.node as? InteractiveSprite {
                interactive.hoverOn()
            }
        } else if contact.bodyB.node?.name == "cursor" {
            if let interactive = contact.bodyA.node as? InteractiveSprite {
                interactive.hoverOn()
            }
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        if contact.bodyA.node?.name == "cursor" {
            if let interactive = contact.bodyB.node as? InteractiveSprite {
                interactive.hoverOff()
            }
        } else if contact.bodyB.node?.name == "cursor" {
            if let interactive = contact.bodyA.node as? InteractiveSprite {
                interactive.hoverOff()
            }
        }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        sceneManager.light?.smoothUpdate()
    }
}

