//
//  Mostro.swift
//  OpusTV
//
//  Created by Simone Boscaglia on 09/03/25.
//

enum MonsterState {
    case idle
    case heartrate
    case jumpscare
}

import SpriteKit

class Mostro {
    var sprite : InteractiveSprite?
    var light : SKLightNode? = nil
    let jumpscareAnimation : SKAction
    var state : MonsterState = .idle

    init(position : CGPoint? = nil, room: Stanza? = nil) {
        let animation = AnimationManager.generateAnimation(atlasName: "jumpscare", animationName: "m", numberOfFrames: 6, timePerFrame: 0.05)
        let scaleAction = SKAction.scale(by: 3, duration: 0.3)
        jumpscareAnimation = SKAction.group([animation, scaleAction])
        if let position, let room {
            spawn(position: position, room: room)
        }
    }
    
    func startIdleAnimation() {
        guard let sprite = self.sprite else { print("Trying to start animation without a sprite"); return }
        sprite.run(jumpscareAnimation)
        sceneManager.textManager.changeText("Stay calm.")
        sceneManager.textManager.showForDuration(5)
    }
    
    func spawn(position: CGPoint, room: Stanza) {
        guard let populator = sceneManager.populator else {print("Trying to spawn monster without populator"); return}
        guard let stanza = room.node else { print("Trying to spawn monster in room without node "); return}
        let monsterNode : SKSpriteNode = SKSpriteNode(imageNamed: "mostro")
        monsterNode.position = position
        monsterNode.zPosition = 5
        monsterNode.lightingBitMask = 2
        room.node?.addChild(monsterNode)
        let interactive = InteractiveSprite(name: "mostro", sprite: monsterNode,
        
        hoverOnAction: {(self) in
            if sceneManager.monsterMet == false {
                let sequence = SKAction.sequence([
                    SKAction.run({sceneManager.light?.flicker()}),
                    SKAction.wait(forDuration: 3),
                    SKAction.run({sceneManager.mostro.despawn()}),
                    //SKAction.playSoundFileNamed(<#T##soundFile: String##String#>, waitForCompletion: true)
                ])
            } else {
                if sceneManager.mostro.state == .idle {
                    sceneManager.mostro.jumpscare()
                }
            }
        })
        populator.swap(interactable: interactive, sprite: monsterNode)
        let lightNode = SKLightNode()
        lightNode.falloff = 5
        lightNode.position = CGPoint(x: 0, y: interactive.frame.maxY * 0.8)
        interactive.addChild(lightNode)
        self.light = lightNode
        self.sprite = interactive
    }
    
    func despawn() {
        self.sprite?.delete()
    }
    
    func jumpscare() {
        sceneManager.mostro.startIdleAnimation()
        sceneManager.mostro.state = .jumpscare
    }

}
