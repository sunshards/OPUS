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
    
    var spawnInfo : [Int : (Stanza, CGPoint, CGSize) ] =
    [
        0 : (laboratorio, CGPoint(x:100, y:-240), CGSize(width: 500, height: 700)),
        1: (cucina, CGPoint(x:100, y:-240), CGSize(width: 500, height: 700)),
        2: (titolo, .zero, .zero) //titolo elimina il mostro
    ]

    init(position : CGPoint? = nil, room: Stanza? = nil) {
        let animation = AnimationManager.generateAnimation(atlasName: "jumpscare", animationName: "m", numberOfFrames: 6, timePerFrame: 0.05)
        let scaleAction = SKAction.scale(by: 3, duration: 0.5)
        let moveAction = SKAction.move(by: CGVector(dx: 0, dy: 500), duration: 0.5)
        let soundAction = SKAction.playSoundFileNamed("MostroVerso2", waitForCompletion: false)
        jumpscareAnimation = SKAction.group([animation, scaleAction, moveAction, soundAction])
        if let position, let room {
            spawn(position: position, room: room)
        }
    }
    
    func startIdleAnimation() {
        guard let sprite = self.sprite else { print("Trying to start animation without a sprite"); return }
        self.sprite?.position = CGPoint(x: 0, y: 0)
        self.sprite?.size = CGSize(width: 1920, height: 1080)
        self.sprite?.texture = SKTexture(imageNamed: "m_1")
        sceneManager.textManager.changeText("Stay calm.")
        sceneManager.scene?.run(SKAction.playSoundFileNamed("BattitoCrescente", waitForCompletion: false))
        sceneManager.scene?.run(SKAction.playSoundFileNamed("HorrorSuspance", waitForCompletion: false))
        sceneManager.textManager.showForDuration(10)
        sceneManager.light?.disableTouch()
        
        sceneManager.scene?.run(SKAction.sequence([
            SKAction.wait(forDuration: 10),
            SKAction.run({sceneManager.light?.enableTouch()}),
            SKAction.run({sceneManager.mostro.jump()}),

        ]))
    }
    
    func jump() {
        sprite?.run(SKAction.sequence([
            jumpscareAnimation,
            SKAction.run({sceneManager.mostro.increasePhase(); sceneManager.mostro.goToNextRoom()})
        ]))

    }
    
    func spawn(position: CGPoint, room: Stanza) {
        sceneManager.mostro.state = .idle
        guard let populator = sceneManager.populator else {print("Trying to spawn monster without populator"); return}
        guard let stanza = room.node else { print("Trying to spawn monster in room without node "); return}
        let monsterNode : SKSpriteNode = SKSpriteNode(imageNamed: "mostro")
        monsterNode.position = position
        monsterNode.zPosition = 5
        monsterNode.lightingBitMask = 2
        room.node?.addChild(monsterNode)
        let interactive = InteractiveSprite(name: "mostro", sprite: monsterNode,
        hoverOnAction: {(self) in
            sceneManager.mostro.flicker()
        })
        populator.swap(interactable: interactive, sprite: monsterNode)
        self.sprite = interactive
    }
    
    func flicker() {
        self.sprite?.isActive = false
        let sequence = SKAction.sequence([
            SKAction.run({sceneManager.light?.flicker()}),
            //SKAction.wait(forDuration: 3),
            //SKAction.run({sceneManager.mostro.goToAnotherRoom()}),
            //SKAction.playSoundFileNamed("sound", waitForCompletion: true)
        ])
        self.sprite?.run(sequence)
        
    }
    
    func increasePhase() {
        sceneManager.monsterPhase += 1
    }
    
    func despawn() {
        self.sprite?.delete()
    }
    
    func jumpscare() {
        if sceneManager.mostro.state == .idle {
            sceneManager.mostro.startIdleAnimation()
            sceneManager.mostro.state = .jumpscare
        }
    }
    
    func goToNextRoom() {
        self.despawn()
        guard let spawnInfo = spawnInfo[sceneManager.monsterPhase] else {print("cant find next room spawn info"); return}
        let newRoom : Stanza = spawnInfo.0
        let newPosition : CGPoint = spawnInfo.1
        let newSize : CGSize = spawnInfo.2
        
        if newRoom.state != .title {
            self.spawn(position: newPosition , room: newRoom)
            self.sprite?.size = newSize
        }

    }
    
    func toggleVisibility() {
        if self.sprite?.isHidden == true {
            self.sprite?.isHidden = false
        } else {
            self.sprite?.isHidden = true
        }
    }

}
