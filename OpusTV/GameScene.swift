//
//  GameScene.swift
//  templateSpriteKit
//
//  Created by Ignazio Finizio on 07/04/22.
//

import SpriteKit
import SwiftUI


class GameScene: SKScene, SKPhysicsContactDelegate {
    let mpcManager: MPCManager = MPCManager.shared
    
    var width : CGFloat = 1920
    var height : CGFloat = 1080
    var xInventoryPadding : CGFloat = 80
    let yInventoryPadding : CGFloat = 80
        
    var xGyro : CGFloat = 0.0
    var yGyro : CGFloat = 0.0
    var zGyro : CGFloat = 0.0
        
    // START OF THE GAME
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self

        mpcManager.delegate = self
        mpcManager.startService()
        
        sceneManager.assignScene(scene: scene!)
        laboratorio.assignNode(node: childNode(withName: "laboratorio"))
        titolo.assignNode(node: childNode(withName: "title"))
        libreria.assignNode(node:childNode(withName: "libreria"))
        sala.assignNode(node:childNode(withName: "sala"))
        cucina.assignNode(node:childNode(withName: "cucina"))
        sceneManager.populate()
        
        sceneManager.inventory.setPosition(point: CGPoint(x: -width/2+xInventoryPadding, y: -height/2+yInventoryPadding))
        addChild(sceneManager.inventory.node)
        
        sceneManager.selectRoom(.title)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.node?.name == "cursor" {
            if let interactive = contact.bodyB.node as? InteractiveSprite {
                interactive.hoverOn()
            }
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        if contact.bodyA.node?.name == "cursor" {
            if let interactive = contact.bodyB.node as? InteractiveSprite {
                interactive.hoverOff()
            }
        }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        sceneManager.light?.smoothUpdate()
        
//        if !(sceneManager.sceneState == .minigame) {
//            light?.highlightObjects()
//        }
    }
    
    func phoneTouch() {
        sceneManager.light?.touch()
        
    }
    
    func recalibrate() {
        sceneManager.light?.setPosition(to:CGPoint.zero)
    }
    
    func playSound(soundName : String) {
        self.scene?.run(SKAction.playSoundFileNamed(soundName, waitForCompletion: true))
    }
    
}

