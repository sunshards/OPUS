//
//  Stanza.swift
//  OpusTV
//
//  Created by Simone Boscaglia on 06/03/25.
//
import SpriteKit

class Stanza {
    let state : SceneState
    let defaultInteractives : [InteractiveSprite]
    var interactives : [InteractiveSprite]
    var sounds : [String]?
    var node : SKNode? = nil
    private var audioNodes : [SKAudioNode] = []
    private var action: ((Stanza) -> Void)?

    init(state: SceneState, action: ((Stanza) -> Void)? = nil, sounds: [String]? = nil, interactives: [InteractiveSprite], node: SKNode? = nil) {
        self.state = state
        self.defaultInteractives = interactives
        self.interactives = copyInteractivesArray(defaultInteractives)
        self.action = action
        self.sounds = sounds
        self.node = node
    }
    
    func assignNode(node : SKNode?) {
        self.node = node
    }
    
    func setup() {
        self.action?(self)
    }
    
    func playSounds() {
        guard let node = self.node else {print("\(self.state) could not play sounds because it has no node."); return}
        guard let sounds = self.sounds else {return}
        for sound in sounds {
            let audioNode = SKAudioNode(fileNamed: sound)
            audioNode.autoplayLooped = true
            node.addChild(audioNode)
            audioNodes.append(audioNode)
        }
    }
    
    func stopSounds() {
        for audio in audioNodes {
            audio.run(SKAction.stop())
        }
        DispatchQueue.main.async {
            self.node?.removeChildren(in: self.audioNodes)
        }
        audioNodes.removeAll()
    }
    
    
    func hide() {
        self.node?.isHidden = true
        self.stopSounds()
    }
    
    func show() {
        self.node?.isHidden = false
        self.playSounds()
    }
}
