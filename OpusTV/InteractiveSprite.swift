//
//  Interactable.swift
//  OpusIOS
//
//  Created by Simone Boscaglia on 05/03/25.
//

import Foundation
import SpriteKit


class InteractiveSprite: SKSpriteNode, SKPhysicsContactDelegate {
    var action: ((InteractiveSprite) -> Void)?
    static let defaultSpriteNode = SKSpriteNode(color: .clear, size: CGSize(width: 1, height: 1))

    
    // Dato uno sprite a schermo, creane la versione interagibile (devi rimuovere lo sprite sottostante)
    // Se non viene dato uno sprite ne viene assegnato uno blank di default, poi bisogna assegnarlo
    init(name: String, sprite : SKSpriteNode = defaultSpriteNode , action: ((InteractiveSprite) -> Void)? = nil) {

        super.init(texture:sprite.texture, color:sprite.color, size:sprite.size)
        self.action = action
        self.name = name
        assignSprite(sprite: sprite)
        
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        initializeBody()
        self.lightingBitMask = 1
    }
    
    func initializeBody() {
        self.physicsBody?.categoryBitMask = 2
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.pinned = false
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.mass = 1
        self.physicsBody?.collisionBitMask = 0
        self.physicsBody?.contactTestBitMask = 1
        self.physicsBody?.isDynamic = true
        self.physicsBody?.fieldBitMask = 0

    }
    
    func assignSprite(sprite : SKSpriteNode) {
        let newTexture = SKTexture(imageNamed: self.name ?? "")
        self.texture = newTexture
        self.physicsBody = SKPhysicsBody(texture: newTexture, alphaThreshold: 0.1, size: newTexture.size())
        initializeBody()
        self.color = sprite.color
        self.size = sprite.size
        self.alpha = 1
        self.lightingBitMask = sprite.lightingBitMask
        self.position = sprite.position
        self.zPosition = sprite.zPosition
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    


}
