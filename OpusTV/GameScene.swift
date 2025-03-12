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
    
    // START OF THE GAME
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        
        sceneManager.assignScene(scene: scene!)
        sceneManager.initializePopulator()
        /*sceneManager.textManager = TextManager(textNode: childNode(withName: "Text") as! SKLabelNode)*/
        sceneManager.textManager.hideText()

        laboratorio.assignNode(node: childNode(withName: "laboratorio"))
        titolo.assignNode(node: childNode(withName: "title"))
        libreria.assignNode(node:childNode(withName: "libreria"))
        sala.assignNode(node:childNode(withName: "sala"))
        cucina.assignNode(node:childNode(withName: "cucina"))
        sceneManager.populate()
        
        sceneManager.inventory.setPosition(point: CGPoint(x: -width/2+xInventoryPadding, y: -height/2+yInventoryPadding))
        addChild(sceneManager.inventory.node)
        
        let mostro = Mostro(sprite: InteractiveSprite(name: "mostro", hoverOnAction: {(self) in
            print("ciao")
        }))
        sceneManager.populator!.swap(interactable: mostro.sprite)
        let sp = mostro.sprite as SKSpriteNode
        mostro.startIdleAnimation()
        
        sceneManager.selectRoom(.title)
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
    
    func highlightObjects() {
        guard let scene = self.scene else {print("highlight objects could not find scene"); return}
        guard let light = sceneManager.light else {print("highlight objects could not find light"); return}
        guard let cursorBody = light.cursor.physicsBody else { print("highlight objects could not find cursor body"); return }
        
        // Tiene un conto del numero di oggetti toccati al momento dal cursore
        // Se il numero cambia, significa che ci sono luci da togliere o da aggiungere
        let currentCursorContacts : Int = cursorBody.allContactedBodies().count
        if currentCursorContacts != light.lastCursorContacts {
            if currentCursorContacts == 0 {
                // Remove all lights
                for child in scene.children {
                    if child.name == "objectLight" {
                        child.removeFromParent()
                    }
                }
            }
            else {
                // Spawn lights for object in contact with the cursor
                for body in cursorBody.allContactedBodies() {
                    guard let node = body.node as? SKSpriteNode else { continue }
                    if body.categoryBitMask == 2 { // Categoria degli interagibili
                        let objectLight = SKSpriteNode(imageNamed: "light")
                        objectLight.name = "objectLight"
                        objectLight.position = node.position
                        objectLight.zPosition = -50 // relativo al padre
                        objectLight.size = node.size
                        objectLight.setScale(0.8)
                        objectLight.color = .yellow
                        objectLight.alpha = 0.5
                        scene.addChild(objectLight)
                    }
                }
            }
        }
        light.lastCursorContacts = currentCursorContacts
    }
}

