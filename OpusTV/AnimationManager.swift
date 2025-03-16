//
//  AnimationManager.swift
//  OpusTV
//
//  Created by Simone Boscaglia on 16/03/25.
//

import SpriteKit

class AnimationManager {
    static func generateAnimation(atlasName : String, animationName : String, numberOfFrames : Int, timePerFrame : TimeInterval) -> SKAction {
        let atlas : SKTextureAtlas = SKTextureAtlas(named: atlasName)
        var textures : [SKTexture] = []
        for i in 1...numberOfFrames {
            let textureName = animationName + "_\(i)"
            textures.append(atlas.textureNamed(textureName))
        }
        let animation = SKAction.animate(with: textures, timePerFrame: timePerFrame)
        return animation
    }
    
    
}
