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

    init(texture: SKTexture?, color: UIColor, size: CGSize, action: ((InteractiveSprite) -> Void)? = nil) {
        self.action = action
        super.init(texture: texture, color: color, size: size)
        isUserInteractionEnabled = true
        self.lightingBitMask = 1
        self.zPosition = 1
        
        self.physicsBody = SKPhysicsBody(rectangleOf: size)
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

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    


}
