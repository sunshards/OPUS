//
//  GameScene.swift
//  templateSpriteKit
//
//  Created by Ignazio Finizio on 07/04/22.
//

import SpriteKit

class Labirinto: SKScene, SKPhysicsContactDelegate {
    var muro = SKSpriteNode()
    var insetto = SKSpriteNode()
    let velocity : CGFloat = 2
    let lightSensibility : CGFloat = 500
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self

        insetto = childNode(withName: "insetto") as! SKSpriteNode
        insetto.physicsBody?.usesPreciseCollisionDetection = true
        let insettoSprite = insetto.childNode(withName: "sprite") as! SKSpriteNode
        let changeVolumeAction = SKAction.changeVolume(to: 0.3, duration: 0.3)
        let insettoAnimation = AnimationManager.generateAnimation(atlasName: "insetto", animationName: "insetto", numberOfFrames: 4, timePerFrame: 0.05)
        let group = SKAction.group([changeVolumeAction, SKAction.playSoundFileNamed("InsettoCamminata3", waitForCompletion: true)])
        insettoSprite.run(SKAction.repeatForever(insettoAnimation))
        insettoSprite.run(SKAction.repeatForever(group))
        camera = childNode(withName:"camera") as? SKCameraNode
        sceneManager.assignScene(scene: scene!)
        sceneManager.light?.setSensibility(sensibility: lightSensibility)
    }
    
    override func update(_ currentTime: TimeInterval) {
        guard let light = sceneManager.light else {print("update could not find light"); return}
        sceneManager.light?.smoothUpdate(transpose: insetto.position)
        
        // alla posizione della luce viene aggiunta la posizione dell'insetto e poi tolta per fare il delta
        // quindi alla fine la direzione è semplicemente la posizione della luce
        let direction = normalize(vector: light.position)//vector: CGPoint(x: dxx, y: dy))
        if module(light.position) > 0.1 {
            insetto.position.x += direction.x * (velocity)
            insetto.position.y += direction.y * (velocity)
        }
        camera?.position = insetto.position
        let rotation = atan2(direction.y, direction.x)
        insetto.zRotation = rotation
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.node?.name == "detector" || contact.bodyB.node?.name == "detector" {
            endGame()
        }
    }
    
    private func endGame() {
        sceneManager.inventory.addItem(InventoryItem(name: "chiave"))
        sceneManager.switchToMinigame(state: .hidden)
    }
}
