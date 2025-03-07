//
//  GameScene.swift
//  templateSpriteKit
//
//  Created by Ignazio Finizio on 07/04/22.
//

import SpriteKit
import SwiftUI

enum MinigameState {
    case hidden
    case cauldron
    case insect
}

enum SceneState {
    case sala
    case cucina
    case libreria
    case laboratorio
    case minigame
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    static let shared = GameScene() //singleton per riferirsi al controller al di fuori
    let mpcManager: MPCManager = MPCManager.shared
//    let device : PhoneConnection = PhoneConnection.shared
    
    var width : CGFloat = 1920
    var height : CGFloat = 1080
    
    var light : Light?
    
    var xGyro : CGFloat = 0.0
    var yGyro : CGFloat = 0.0
    var zGyro : CGFloat = 0.0
//    var xAcc : CGFloat = 0.0
//    var yAcc : CGFloat = 0.0
//    var zAcc : CGFloat = 0.0

    private var sceneState : SceneState = .sala
    private var minigame : MinigameState = .hidden
    var stanze : [SceneState : Stanza] = [.sala: sala,.cucina : cucina,.laboratorio : laboratorio,.libreria: libreria]
    
    // START OF THE GAME
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        let lightNode = childNode(withName: "torch") as! SKLightNode
        let cursor = childNode(withName: "cursor") as! SKSpriteNode
        light = Light(lightNode: lightNode, cursor: cursor, scene: self)
         
        mpcManager.delegate = self
        mpcManager.startService()
        
        let nodoLaboratorio = childNode(withName: "laboratorio")
        laboratorio.assignNode(node: nodoLaboratorio)
        let nodoLibreria = childNode(withName: "libreria")
        libreria.assignNode(node:nodoLibreria)
        let nodoSala = childNode(withName: "sala")
        sala.assignNode(node:nodoSala)
        let nodoCucina = childNode(withName: "cucina")
        cucina.assignNode(node:nodoCucina)
        
        let populator = Populator()

        for (_, stanza) in stanze {
            populator.populate(interactables: stanza.interactives, room: stanza)
            stanza.node?.position = CGPoint.zero
            stanza.hide()
        }
        selectScene(.sala)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {}
    
    func didEnd(_ contact: SKPhysicsContact) {}
    
    
    override func update(_ currentTime: TimeInterval) {
        light?.smoothUpdate()
        
        if !(sceneState == .minigame) {
            //light?.highlightObjects()
        }
    }
    
    func selectScene(_ newScene : SceneState) {
        stanze[sceneState]?.hide()
        stanze[newScene]?.show()
        sceneState = newScene
    }
    
    func phoneTouch() {
        //switchScene()
        guard let contacts = light?.cursor.physicsBody?.allContactedBodies() else {return}
        for sprite in contacts {
            if let interactive = sprite.node as? InteractiveSprite {
                if interactive.parent?.isHidden == false {
                    interactive.run()
                }
            }
        }
    }
    
    func recalibrate() {
        light?.setPosition(to:CGPoint.zero)
    }
    
    func playSound(soundName : String) {
        self.scene?.run(SKAction.playSoundFileNamed(soundName, waitForCompletion: true))
    }
    
}

