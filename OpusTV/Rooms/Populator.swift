//
//  RoomGenerator.swift
//  OpusTV
//
//  Created by Simone Boscaglia on 06/03/25.
//

import SpriteKit


// Populates the room with Interactable Sprites
class Populator {
    
    let scene : SKScene
    
    init(scene: SKScene) {
        self.scene = scene
    }
    
    // Rimuove gli sprite normali e li sostituisce con quelli con cui si può interagire
    func populate(room: Stanza) {
        let interactables : [InteractiveSprite] = room.interactives
        for interactable in interactables {
            if interactable.isAssigned == true {
                print("Trying to populate interactable \(interactable) that is already assigned.")
                return
            }
            guard let name = interactable.name else {print("Interactable in room \(room.state) has no name"); return}
            guard let node = room.node else {print("Room \(room.state) has no node"); return}
            let child = node.childNode(withName: name)
            if let child = child as? SKSpriteNode {
                interactable.assignSprite(sprite: child)
                child.removeFromParent()
                node.addChild(interactable)
            }
        }
    }
    
    func depopulate(room: Stanza) {
        for interactive in room.interactives {
            interactive.removeAllActions()
            interactive.removeFromParent()
        }
        room.interactives.removeAll(keepingCapacity: true)
        room.interactives = copyInteractivesArray(room.defaultInteractives)
    }
    
    // swap di uno sprite normale con uno interattivo
    func swap(interactable : InteractiveSprite, sprite : SKSpriteNode) {
        var parent = sprite.parent
        if parent == nil { parent = scene }
        interactable.assignSprite(sprite: sprite)
        parent!.addChild(interactable)
        sprite.removeFromParent()
    }
    
    // swap di uno sprite interattivo sapendo la stanza in cui si trova quello normale ed il suo nome
    func swap(interactable : InteractiveSprite, parent parentNode : SKNode? = nil) {
        guard let name = interactable.name else {print("Interactable not swapped succesfully"); return}
        var parent : SKNode
        if let parentNode {parent = parentNode} else {parent = scene }
        let child = parent.childNode(withName: name)
        if let child = child as? SKSpriteNode {
            interactable.assignSprite(sprite: child)
            child.removeFromParent()
            parent.addChild(interactable)
        }
    }
}
