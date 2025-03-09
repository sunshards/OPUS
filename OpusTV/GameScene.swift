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
        
        let nodoLaboratorio = childNode(withName: "laboratorio")
        laboratorio.assignNode(node: nodoLaboratorio)
        titolo.assignNode(node: childNode(withName: "title"))
        let nodoLibreria = childNode(withName: "libreria")
        libreria.assignNode(node:nodoLibreria)
        let nodoSala = childNode(withName: "sala")
        sala.assignNode(node:nodoSala)
        let nodoCucina = childNode(withName: "cucina")
        cucina.assignNode(node:nodoCucina)
        sceneManager.populate()
        
        sceneManager.selectRoom(.title)
        
        sceneManager.inventory.setPosition(point: CGPoint(x: -width/2+xInventoryPadding, y: -height/2+yInventoryPadding))
        addChild(sceneManager.inventory.node)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {}
    
    func didEnd(_ contact: SKPhysicsContact) {}
    
    
    override func update(_ currentTime: TimeInterval) {
        sceneManager.light?.smoothUpdate()
        
        if !(sceneManager.sceneState == .minigame) {
            //light?.highlightObjects()
        }
    }
    
    func phoneTouch() {
        //switchScene()
        sceneManager.light?.touch()
        
    }
    
    func recalibrate() {
        sceneManager.light?.setPosition(to:CGPoint.zero)
    }
    
    func playSound(soundName : String) {
        self.scene?.run(SKAction.playSoundFileNamed(soundName, waitForCompletion: true))
    }
    
}

