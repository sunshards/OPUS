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
    var cursorAlpha : CGFloat = 0.2
    let lightFlickers = 8

    var position = CGPoint.zero
    var displayPosition = CGPoint.zero
    var sensibility : CGFloat?
    var smoothness : Double = 0.15
    var lastCursorContacts : Int = 0
    
    var isEnabled : Bool = true
    var lightVisible : Bool = true
    var cursorVisible : Bool = true
    var hasInitialized : Bool = false
    
    var flickerAnimation : SKAction {
        var actions : [SKAction] = []
        actions.append(SKAction.run {sceneManager.lightFlickeringStarted()})

        for i in 1...lightFlickers {
            actions.append(SKAction.run {self.disable()})
            actions.append(SKAction.wait(forDuration: 0.25/Double(i)))
            actions.append(SKAction.run {self.enable()})
            actions.append(SKAction.wait(forDuration: 0.25/Double(i)))
            actions.append(SKAction.run {sceneManager.lightFlickering(flickerNumber: i)})
        }
        actions.append(SKAction.run {self.enable()})
        actions.append(SKAction.run {sceneManager.lightFlickeringOver()})

        
        return SKAction.sequence(actions)
    }
    
    var constantFlickerAnimation : [SKAction] {
        return [
            SKAction.run {self.disable()},
            SKAction.wait(forDuration: 0.12),
            SKAction.run {self.disable()},
            SKAction.wait(forDuration: 0.12)
        ]
    }
    
    init() {}
    
    init(lightNode : SKLightNode, cursor : SKSpriteNode) {
        setup(lightNode: lightNode, cursor: cursor)
    }
    
    func flicker() {
        self.lightNode.run(flickerAnimation)
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
        cursor.alpha = cursorAlpha
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
    
    func disableTouch() {
        self.isEnabled = false
    }
    
    func enableTouch() {
        self.isEnabled = true
    }

    
    func setSensibility(sensibility : CGFloat) {
        self.sensibility = sensibility
    }
    
    /// fa partire l'azione del primo sprite interattivo non nascosto che trova
    /// se la luce non è abilitata invece il tocco viene gestito in modo diverso dallo sceneManager
    func touch() {
        if self.isEnabled == false {
            print("light not enabled")
            sceneManager.handleDisabledTouch()
            return
        }
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
            //print("run")
        }
    }
}
