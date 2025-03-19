//
//  TextManager.swift
//  OpusTV
//
//  Created by Simone Boscaglia on 12/03/25.
//

import SpriteKit

class TextManager {
    let textNode : SKLabelNode
    var isDisplaying : Bool = false
    static let textAnimationKey = "textAnimation"
    let fontSize : CGFloat = 50
    
    init(textNode: SKLabelNode) {
        self.textNode = textNode as SKLabelNode
        textNode.fontSize = fontSize
    }
    
    private func changeText(_ newText: String) {
        textNode.text = newText
    }
    
    func showForDuration(_ duration: TimeInterval) {
        self.isDisplaying = true
        let newSequence : [SKAction] = [
            SKAction.hide().reversed(),
            SKAction.wait(forDuration: duration),
            SKAction.run({sceneManager.textManager.isDisplaying = false}),
            SKAction.hide()
        ]
        self.textNode.run(SKAction.sequence(newSequence), withKey: TextManager.textAnimationKey)
    }
    
    func displayText(_ text: String, for duration: TimeInterval) {
        changeText(text)
        showForDuration(duration)
    }
    
    func showDialogue(lines : [String], duration: TimeInterval) {
        guard isDisplaying == false else { print("Trying to show dialogue when one is already displayed;"); return }
        isDisplaying = true
        var sequence : [SKAction] = []
        self.changeText(lines[0])
        
        sequence.append(SKAction.hide().reversed())
        for line in lines {
            sequence.append(SKAction.run({self.changeText(line)}))
            sequence.append(SKAction.fadeIn(withDuration: 1))
            sequence.append(SKAction.wait(forDuration: duration))
            sequence.append(SKAction.fadeOut(withDuration: 1))
        }
        sequence.append(SKAction.hide())
        sequence.append(SKAction.run({self.isDisplaying = false }))
        self.textNode.run(SKAction.sequence(sequence), withKey: TextManager.textAnimationKey)

    }
    
    func hideText() {
        textNode.isHidden = true
    }
    
    func showText() {
        textNode.zPosition = 7
        textNode.isHidden = false
    }

    
    
}
