//
//  FirstCutscene.swift
//  OpusTV
//
//  Created by Andrea Iannaccone on 17/03/25.
//

import SpriteKit

class FirstCutscene: SKScene {
    let textManager = TextManager(textNode: SKLabelNode())
    
    override func didMove(to view: SKView) {
        sceneManager.assignScene(scene: scene!)
        let textLabel = childNode(withName: "Text") as! SKLabelNode
        let text = TextManager(textNode: textLabel)
        let lines: [ String ] = [
        "It was a dark night.",
        "As you approach your old friend's door,",
        "a shiver runs down your spine.",
        "Did he really drink it?",
        "Did he really make the Opus Magna, the potion of immortality?"
        ]
        let duration : Int = 1
        let totalDuration = lines.count * (duration+2) // 2 is the fade animation
        text.showDialogue(lines: lines, duration: TimeInterval(duration))
        let actions : [SKAction] =
            [
                SKAction.wait(forDuration: TimeInterval(totalDuration)),
                SKAction.run({sceneManager.switchToMinigame(newState: .hidden)})
            ]
        self.run(SKAction.sequence(actions))
    }
}
