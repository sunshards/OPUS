//
//  Light.swift
//  OpusTV
//
//  Created by Simone Boscaglia on 05/03/25.
//

import SpriteKit

class Light {
    var lightNode : SKLightNode = SKLightNode()
    var cursor : SKSpriteNode = SKSpriteNode()

    var position = CGPoint.zero
    var displayPosition = CGPoint.zero
    var sensibility : CGFloat = 2000
    var smoothness : Double = 0.15
    var lastCursorContacts : Int = 0
    
    var lightVisible : Bool = true
    var cursorVisible : Bool = false
    var hasInitialized : Bool = false
    
    init() {}
    
    init(lightNode : SKLightNode, cursor : SKSpriteNode) {
        setup(lightNode: lightNode, cursor: cursor)
    }
    
    func setup(lightNode : SKLightNode, cursor : SKSpriteNode) {
        self.lightNode = lightNode
        self.cursor = cursor
        hasInitialized = true
    }
    
    // Questa è la posizione che viene impostata ma la luce non viene mossa.
    // La luce viene mostrata nella posizione displayPosition che viene modificata nello smoothUpdate
    func move(to point : CGPoint) {
        position = point
    }
    
    // Muove la luce direttamente
    func setPosition(to point : CGPoint) {
        position = point
        displayPosition = point
        lightNode.position = displayPosition
        cursor.position = displayPosition
    }
    
    func smoothUpdate(transpose: CGPoint = .zero) {
        displayPosition = lerp(p1: displayPosition, p2: position, t: smoothness)
        lightNode.position = CGPoint(x: displayPosition.x + transpose.x, y: displayPosition.y + transpose.y)
        cursor.position = CGPoint(x: displayPosition.x + transpose.x, y: displayPosition.y + transpose.y)
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
    
    // fa partire l'azione del primo sprite interattivo non nascosto che trova
    func touch() {
        //var alreadyInteracted : [InteractiveSprite] = []
        guard let contacts = cursor.physicsBody?.allContactedBodies() else {return}
        for sprite in contacts {
            if let interactive = sprite.node as? InteractiveSprite {
                if interactive.room?.isHidden == false {//&& !alreadyInteracted.contains(interactive){
                    interactive.run()
                    return
                    //alreadyInteracted.append(interactive)
                }
            }
        }
    }
}
