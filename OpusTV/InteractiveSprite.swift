//
//  Interactable.swift
//  OpusIOS
//
//  Created by Simone Boscaglia on 05/03/25.
//

import Foundation
import SpriteKit


class InteractiveSprite: SKSpriteNode, SKPhysicsContactDelegate {
    private var touchAction: ((InteractiveSprite) -> Void)?
    private var hoverOnAction: ((InteractiveSprite) -> Void)?
    private var hoverOffAction: ((InteractiveSprite) -> Void)?


    static let defaultSpriteNode = SKSpriteNode(color: .clear, size: CGSize(width: 1, height: 1))
    
    // Dato uno sprite a schermo, creane la versione interagibile (devi rimuovere lo sprite sottostante)
    // Se non viene dato uno sprite ne viene assegnato uno blank di default, poi bisogna assegnarlo
    init(name: String,
         sprite : SKSpriteNode = defaultSpriteNode ,
         hoverOnAction: ((InteractiveSprite) -> Void)? = nil,
         hoverOffAction: ((InteractiveSprite) -> Void)? = nil,
         touchAction: ((InteractiveSprite) -> Void)? = nil) {
        super.init(texture:sprite.texture, color:sprite.color, size:sprite.size)
        self.touchAction = touchAction
        self.hoverOnAction = hoverOnAction
        self.hoverOffAction = hoverOffAction
        self.name = name
        assignSprite(sprite: sprite)
    }
    
    func initializeBody() {
        self.physicsBody?.categoryBitMask = 2
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.mass = 1
        self.physicsBody?.collisionBitMask = 0
        self.physicsBody?.contactTestBitMask = 1
        self.physicsBody?.fieldBitMask = 0
    }
    
    // we pass self to the action so that the action can control the sprite's properties
    func hoverOn() {
        self.hoverOnAction?(self)
    }
    func hoverOff() {
        self.hoverOffAction?(self)
    }
    func run() {
        self.touchAction?(self)
    }
     
    func playSound(soundName : String) {
        self.parent?.run(SKAction.playSoundFileNamed(soundName, waitForCompletion: false))
    }
    
    func assignSprite(sprite : SKSpriteNode) {
        self.size = sprite.size
        self.lightingBitMask = sprite.lightingBitMask
        self.position = sprite.position
        self.zPosition = sprite.zPosition

        // Controlla se la texture è presente negli asset, altrimenti lo sprite è solo un placeholder
        if let _ = UIImage(named: self.name!) {
            let newTexture = SKTexture(imageNamed: self.name ?? "")
            self.texture = newTexture
            self.physicsBody = SKPhysicsBody(texture: newTexture, alphaThreshold: 0.1, size: newTexture.size())
            self.lightingBitMask = 1
            self.color = sprite.color
            self.alpha = 1
        } else { // Lo sprite è un placeholder
            self.color = .clear
            self.alpha = 0
            self.lightingBitMask = 0
            self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        }
        initializeBody()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    


}
