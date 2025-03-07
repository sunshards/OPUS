//
//  Light.swift
//  OpusTV
//
//  Created by Simone Boscaglia on 05/03/25.
//

import SpriteKit

class Light {
    let lightNode : SKLightNode
    let cursor : SKSpriteNode
    var scene : SKScene

    var position = CGPoint.zero
    var displayPosition = CGPoint.zero
    let sensibility : CGFloat = 2000
    let smoothness : Double = 0.15
    var lastCursorContacts : Int = 0
    
    var lightVisible : Bool = true
    var cursorVisible : Bool = false

    init(lightNode : SKLightNode, cursor : SKSpriteNode, scene: SKScene) {
        self.lightNode = lightNode
        self.cursor = cursor
        self.scene = scene
    }
    
    // Questa è la posizione che viene impostata ma la luce non viene mossa.
    // La luce viene mostrata nella posizione displayPosition che viene modificata
    // nello smoothUpdate
    func setPosition(to point : CGPoint) {
        position = point
    }
    
    // Muove la luce direttamente
    func move(to point : CGPoint) {
        position = point
        displayPosition = point
        lightNode.position = displayPosition
        cursor.position = displayPosition
    }
    
    func smoothUpdate() {
        displayPosition = lerp(p1: displayPosition, p2: position, t: smoothness)
        lightNode.position = displayPosition
        cursor.position = displayPosition
    }
    
    func hideLight() {
        lightNode.isEnabled = false
        lightVisible = false
    }
    
    func showLight() {
        lightNode.isEnabled = true
        lightVisible = true
    }
    
    func hideCursor() {
        cursor.alpha = 0
        cursorVisible = false
    }
    
    func showCursor() {
        cursor.alpha = 1
        cursorVisible = true
    }
    
    func highlightObjects() {
        guard let cursorBody = cursor.physicsBody else { return }
        
        // Tiene un conto del numero di oggetti toccati al momento dal cursore
        // Se il numero cambia, significa che ci sono luci da togliere o da aggiungere
        let currentCursorContacts : Int = cursorBody.allContactedBodies().count
        if currentCursorContacts != lastCursorContacts {
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
        lastCursorContacts = currentCursorContacts
        
        
    }
    
}
