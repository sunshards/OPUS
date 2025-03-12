//
//  Mostro.swift
//  OpusTV
//
//  Created by Simone Boscaglia on 09/03/25.
//

import SpriteKit

class Mostro {
    var sprite : InteractiveSprite?
    
    private var jumpscare: [SKTexture] = []

    init(position : CGPoint?, room: Stanza?) {
        if let position, let room {
            spawn(position: position, room: room)
        }
        self.jumpscare = importAnimationAtlas(atlas: SKTextureAtlas(named: "jumpscare"), animationName: "m", numberOfFrames: 6)
    }
    
    func startIdleAnimation() {
        guard let sprite = self.sprite else { print("Trying to start animation without a sprite"); return }
        let jumpscareAnimation = SKAction.animate(with: jumpscare, timePerFrame: 0.3)
        sprite.run(jumpscareAnimation)
    }
    
    private func importAnimationAtlas(atlas : SKTextureAtlas, animationName : String, numberOfFrames : Int) -> [SKTexture] {
        var animation : [SKTexture] = []
        for i in 1...numberOfFrames {
            let textureName = animationName + "_\(i)"
            animation.append(atlas.textureNamed(textureName))
        }
        return animation
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
        DispatchQueue.main.async {
            self.sprite?.removeFromParent()
        }
    }

}
