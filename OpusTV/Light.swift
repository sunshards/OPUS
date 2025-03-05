//
//  Light.swift
//  OpusTV
//
//  Created by Simone Boscaglia on 05/03/25.
//

import SpriteKit

class Light {
    let lightNode : SKLightNode
    let cursor : SKSpriteNode
    var lightPosition = CGPoint.zero
    var lightDisplayPosition = CGPoint.zero
    
    init(lightNode : SKLightNode, cursor : SKSpriteNode) {
        self.lightNode = lightNode
        self.cursor = cursor
    }
    
}
