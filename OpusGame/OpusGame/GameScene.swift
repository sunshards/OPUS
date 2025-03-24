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
        sceneManager.mostro.goToNextRoom()

        audio.playMusic("Atmosfera")
//        let audioNode = SKAudioNode(fileNamed: "Atmosfera")
//        audioNode.autoplayLooped = true
//        addChild(audioNode)

        let inventoryNode = SKNode()
        addChild(inventoryNode)
        sceneManager.inventory.assignNode(n: inventoryNode)
        sceneManager.inventory.regenerateNode()

        if (sceneManager.hasShownMenu == false) {
            sceneManager.selectRoom(.title)
            sceneManager.hasShownMenu = true
        } else if sceneManager.hasStartedGame == false {
            sceneManager.selectRoom(.sala)
            sceneManager.hasStartedGame = true
            sceneManager.textManager.displayText("Press the ACT button on your phone to interact.", for: 5)
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
    
    func playSound(soundName : String) {
        var room : SKNode? {
            return self.parent
        }
            room?.run(SKAction.playSoundFileNamed(soundName, waitForCompletion: true))
            //print("playing sound \(soundName)")
        
    }
    
    func killSound(){
        var room : SKNode? {
            return self.parent
        }
        room?.run(SKAction.stop())
    }
    
    override func update(_ currentTime: TimeInterval) {
        sceneManager.light?.smoothUpdate()
        if sceneManager.watchConnected {
            //print(sceneManager.collectedHeartRates)
        } else {
            //print("watch not connected")
        }
    }
}

