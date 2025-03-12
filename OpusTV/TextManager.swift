//
//  TextManager.swift
//  OpusTV
//
//  Created by Simone Boscaglia on 12/03/25.
//

import SpriteKit

class TextManager {
    let textNode : SKLabelNode
    
    init(textNode: SKLabelNode) {
        self.textNode = textNode
    }
    
    func changeText(_ newText: String) {
        textNode.text = newText
    }
    
    func showForDuration(_ duration: TimeInterval) {
        let sequence : [SKAction] = [
            SKAction.hide().reversed(),
            SKAction.wait(forDuration: duration),
            SKAction.hide()
        ]
        self.textNode.run(SKAction.sequence(sequence))
    }
    
    
    func hideText() {
        textNode.isHidden = true
    }
    
    func showText() {
        textNode.zPosition = 7
        textNode.isHidden = false
    }
    
    
    
}
