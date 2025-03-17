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
        let textLabel = childNode(withName: "Text") as! SKLabelNode
        let text = TextManager(textNode: textLabel)
        text.showDialogue(lines: [
            "It was a dark night",
            "You are coming back home from a walk",
            "You hear a voice coming from the main door",
        ], duration: 4)
//        sceneManager.switchToMinigame(state: .hidden)
//        sceneManager.selectRoom(.sala)
    }
}
