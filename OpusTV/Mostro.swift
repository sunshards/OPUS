//
//  Mostro.swift
//  OpusTV
//
//  Created by Simone Boscaglia on 09/03/25.
//

import SpriteKit

class Mostro {
    var sprite : InteractiveSprite
    
    private var jumpscare: [SKTexture] = []

    init(sprite: InteractiveSprite) {
        self.sprite = sprite
        self.jumpscare = importAnimationAtlas(atlas: SKTextureAtlas(named: "jumpscare"), animationName: "m", numberOfFrames: 6)
        let jumpscareAnimation = SKAction.animate(with: jumpscare, timePerFrame: 0.3)
        self.sprite.run(SKAction.repeatForever(jumpscareAnimation), withKey: "jumpscare")

    }
    
    func startIdleAnimation() {
        let jumpscareAnimation = SKAction.animate(with: jumpscare, timePerFrame: 0.3)
        self.sprite.run(SKAction.repeatForever(jumpscareAnimation), withKey: "jumpscare")
    }
    
    private func importAnimationAtlas(atlas : SKTextureAtlas, animationName : String, numberOfFrames : Int) -> [SKTexture] {
        var animation : [SKTexture] = []
        for i in 1...numberOfFrames {
            let textureName = animationName + "_\(i)"
            animation.append(atlas.textureNamed(textureName))
        }
        return animation
            
    }

}
