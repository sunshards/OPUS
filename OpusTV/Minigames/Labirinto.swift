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
        camera = childNode(withName:"camera") as? SKCameraNode
        sceneManager.assignScene(scene: scene!)
        sceneManager.light?.setSensibility(sensibility: lightSensibility)
    }
    
    override func update(_ currentTime: TimeInterval) {
        guard let light = sceneManager.light else {print("update could not find light"); return}
        sceneManager.light?.smoothUpdate(transpose: insetto.position)
        // alla posizionle della luce viene aggiunta la posizione dell'insetto e poi tolta per fare il delta
        // quindi alla fine la direzione è semplicemente la posizione della luce
        let direction = normalize(vector: light.position)//vector: CGPoint(x: dxx, y: dy))
        insetto.position.x += direction.x * (velocity)
        insetto.position.y += direction.y * (velocity)
        camera!.position = insetto.position
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
    
    private func distance(p1: CGPoint, p2: CGPoint) -> CGFloat {
        let dx = p2.x - p1.x
        let dy = p2.y - p1.y
        return sqrt(dx*dx + dy*dy)
    }
    
    private func angle(p1: CGPoint, p2: CGPoint) -> CGFloat {
        let dx = p2.x - p1.x
        let dy = p2.y - p1.y
        let direction = normalize(vector: CGPoint(x: dx, y: dy))//vector: CGPoint(x: dx, y: dy))
        let tetha = atan2(direction.y, direction.x)
        return tetha
    }
}
