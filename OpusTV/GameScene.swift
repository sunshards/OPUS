//
//  GameScene.swift
//  templateSpriteKit
//
//  Created by Ignazio Finizio on 07/04/22.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var width : CGFloat = 1920
    var height : CGFloat = 1080
    var xInventoryPadding : CGFloat = 80
    let yInventoryPadding : CGFloat = 80
    let lightSensibility : CGFloat = 2000
    
    // START OF THE GAME
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        
        sceneManager.assignScene(scene: scene!)
        sceneManager.textManager.hideText()
        sceneManager.light?.setSensibility(sensibility: lightSensibility)
        laboratorio.assignNode(node: childNode(withName: "laboratorio"))
        titolo.assignNode(node: childNode(withName: "title"))
        libreria.assignNode(node:childNode(withName: "libreria"))
        sala.assignNode(node:childNode(withName: "sala"))
        cucina.assignNode(node:childNode(withName: "cucina"))
        sceneManager.populate()
        recursivePrintInteractives(node: scene!)

        if (sceneManager.hasInitializedMainScene == false) {

            sceneManager.inventory.setPosition(point: CGPoint(x: -width/2+xInventoryPadding, y: -height/2+yInventoryPadding))
            addChild(sceneManager.inventory.node)
            sceneManager.selectRoom(.title)
            sceneManager.hasInitializedMainScene = true
        } else {
            sceneManager.selectRoom(.sala)

        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
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
        let conn = childNode(withName: "title")?.childNode(withName: "connection") as? SKSpriteNode
        if (sceneManager.mpcManager.iPhoneConnected){
            conn?.color = .green
        }else {
            conn?.color = .red
        }
    }
}

