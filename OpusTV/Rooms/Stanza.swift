//
//  Stanza.swift
//  OpusTV
//
//  Created by Simone Boscaglia on 06/03/25.
//
import SpriteKit

class Stanza {
    let state : sceneState
    let interactives : [InteractiveSprite]
    var node : SKNode? = nil
    
    init(state: sceneState, interactives: [InteractiveSprite]) {
        self.state = state
        self.interactives = interactives
    }
    
    func assignNode(node : SKNode?) {
        self.node = node
    }
    
}
