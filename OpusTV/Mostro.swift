//
//  Mostro.swift
//  OpusTV
//
//  Created by Simone Boscaglia on 09/03/25.
//

import SpriteKit

class Mostro {
    var sprite : InteractiveSprite?
    let jumpscareAnimation : SKAction

    init(position : CGPoint?, room: Stanza?) {
        jumpscareAnimation = AnimationManager.generateAnimation(atlasName: "jumpscare", animationName: "m", numberOfFrames: 6, timePerFrame: 0.5)
        if let position, let room {
            spawn(position: position, room: room)
        }
    }
    
    func startIdleAnimation() {
        guard let sprite = self.sprite else { print("Trying to start animation without a sprite"); return }
        sprite.run(jumpscareAnimation)
    }
    
    func spawn(position: CGPoint, room: Stanza) {
        guard let stanza = room.node else { print("Trying to spawn monster in room without node "); return}
        let monsterNode : SKSpriteNode = SKSpriteNode(imageNamed: "mostro")
        monsterNode.position = position
        monsterNode.zPosition = 5
        monsterNode.lightingBitMask = 2
        let interactive = InteractiveSprite(name: "mostro", sprite: monsterNode, hoverOnAction: {(self) in
            print("ciao")
        })
        self.sprite = interactive
        stanza.addChild(interactive)
    }
    
    func despawn() {
        self.sprite?.delete()
    }

}
