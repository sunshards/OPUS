//
//  Labirinto.swift
//  OpusTV
//
//  Created by Simone Boscaglia on 28/02/25.
//

import SpriteKit

class Vittoria: SKScene {
    let textManager = TextManager(textNode: SKLabelNode())
    
    override func didMove(to view: SKView) {
        sceneManager.assignScene(scene: scene!)
        let textLabel = childNode(withName: "Text") as! SKLabelNode
        let text = TextManager(textNode: textLabel)
        let lines: [ String ] = [
        "As you gave the potion to the monster,",
        "You see the face of your old friend come back.",
        "He smiles."
        ]
        let antonioNode = childNode(withName: "antoniowin")
        
        let duration : Int = 1
        let totalDuration = lines.count * (duration+2) // 2 is the fade animation
        text.showDialogue(lines: lines, duration: TimeInterval(duration))
        let actions : [SKAction] =
            [
                SKAction.wait(forDuration: TimeInterval(totalDuration)),
                SKAction.run({antonioNode?.run(SKAction.fadeAlpha(to: 1, duration: 3) ) } )
            ]
        self.run(SKAction.sequence(actions))
    }
}

