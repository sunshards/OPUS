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
        "It was a dark night",
        "You are coming back home from a walk",
        "You hear a voice coming from the main door",
        ]
        let duration : Int = 2
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
