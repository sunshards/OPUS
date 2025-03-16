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
    var sensibility : CGFloat?
    var smoothness : Double = 0.15
    var lastCursorContacts : Int = 0
    
    var isEnabled : Bool = true
    var lightVisible : Bool = true
    var cursorVisible : Bool = true
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
    
    /// Questa è la posizione che viene impostata ma la luce non viene mossa.
    /// La luce viene mostrata nella posizione displayPosition che viene modificata nello smoothUpdate
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
    
    func hideCursor() {
        cursor.alpha = 0
        cursorVisible = false
    }
    
    func showCursor() {
        cursor.alpha = 1
        cursorVisible = true
    }
    
    func hideLight() {
        lightNode.isEnabled = false
        lightVisible = false
    }
    
    func showLight() {
        lightNode.isEnabled = true
        lightVisible = true

    }
    
    func enable() {
        showLight()
        showCursor()
        self.isEnabled = true
    }
    
    func disable() {
        hideLight()
        hideCursor()
        self.isEnabled = false
    }

    
    func setSensibility(sensibility : CGFloat) {
        self.sensibility = sensibility
    }
    
    /// fa partire l'azione del primo sprite interattivo non nascosto che trova
    /// se la luce non è abilitata invece il tocco viene gestito in modo diverso dallo sceneManager
    func touch() {
        guard isEnabled == true else {sceneManager.handleDisabledTouch(); return}
        var displayed : [InteractiveSprite] = []
        guard let contacts = cursor.physicsBody?.allContactedBodies() else {return}
        for sprite in contacts {
            if let interactive = sprite.node as? InteractiveSprite {
                if interactive.room?.isHidden == false && interactive.isActive {
                    displayed.append(interactive)
                }
            }
        }
        if let highestTouched = displayed.max(by: {$0.zPosition < $1.zPosition}) {
            highestTouched.run()
            print("run")
        }
    }
}
