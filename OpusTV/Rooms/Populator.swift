//
//  RoomGenerator.swift
//  OpusTV
//
//  Created by Simone Boscaglia on 06/03/25.
//

import SpriteKit


// Populates the room with Interactable Sprites
class Populator {
    
    func populate(interactables: [InteractiveSprite], room: SKNode) {
        for interactable in interactables {
            let child = room.childNode(withName: interactable.name ?? "")
            if let child = child as? SKSpriteNode {
                interactable.assignSprite(sprite: child)
                child.removeFromParent()
                room.addChild(interactable)
            }
        }
        
    }
}
