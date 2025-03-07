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

    var sceneState : SceneState = .sala
    var minigame : MinigameState = .hidden
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

        for (state, stanza) in stanze {
            populator.populate(interactables: stanza.interactives, room: stanza.node!)
            stanza.node?.position = CGPoint.zero
            stanza.node?.isHidden = true
        }
        selectScene(.sala)
        
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
        
        if !(sceneState == .minigame) {
            //light?.highlightObjects()
        }
    }
    
    func selectScene(_ newScene : SceneState) {
        stanze[sceneState]?.node?.isHidden = true
        stanze[sceneState]?.stopStounds()
        stanze[newScene]?.node?.isHidden = false
        stanze[newScene]?.playSounds()
        sceneState = newScene
    }
    
    func phoneTouch() {
        //switchScene()
        if let contacts = light?.cursor.physicsBody?.allContactedBodies() {
            for sprite in contacts {
                if let interactive = sprite.node as? InteractiveSprite {
                    interactive.run()
                }
            }
        }
    }
    
    func recalibrate() {
        light?.setPosition(to:CGPoint.zero)
    }
    
    
}

