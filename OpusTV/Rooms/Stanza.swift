//
//  Stanza.swift
//  OpusTV
//
//  Created by Simone Boscaglia on 06/03/25.
//
import SpriteKit

class Stanza {
    let state : SceneState
    let interactives : [InteractiveSprite]
    var node : SKNode? = nil
    var sounds : [String]?

    init(state: SceneState, sounds: [String]?, interactives: [InteractiveSprite], node: SKNode? = nil) {
        self.state = state
        self.interactives = interactives
        self.sounds = sounds
        self.node = node
    }
    
    func assignNode(node : SKNode?) {
        self.node = node
    }
    
    func playSounds() {
        if let sounds {
            for sound in sounds {
                self.node?.run(SKAction.playSoundFileNamed(sound, waitForCompletion: true))
            }
        }
    }
    
    func stopStounds() {
        self.node?.run(SKAction.stop())
    }
    
}
