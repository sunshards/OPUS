//
//  GameScene.swift
//  templateSpriteKit
//
//  Created by Ignazio Finizio on 07/04/22.
//

import SpriteKit

class Labirinto: SKScene {
    var muro = SKSpriteNode()
    var insetto = SKSpriteNode()
    let velocity : CGFloat = 0.02
    
    override func didMove(to view: SKView) {
        insetto = childNode(withName: "insetto") as! SKSpriteNode
        insetto.physicsBody?.usesPreciseCollisionDetection = true
        insetto.physicsBody?.allowsRotation = true
        scene?.camera = childNode(withName:"camera") as? SKCameraNode
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: self)
        let dx = location.x - insetto.position.x
        let dy = location.y - insetto.position.y
        insetto.position.x += dx * (velocity)
        insetto.position.y += dy * (velocity)
        let camera = childNode(withName:"camera")! as SKNode
        camera.position = insetto.position

        let rotation = angle(p1: insetto.position, p2: location)
        print(rotation)
        insetto.zRotation = rotation
    }
    
    private func distance(p1: CGPoint, p2: CGPoint) -> CGFloat {
        let dx = p2.x - p1.x
        let dy = p2.y - p1.y
        return sqrt(dx*dx + dy*dy)
    }
    
    private func angle(p1: CGPoint, p2: CGPoint) -> CGFloat {
        let dx = p2.x - p1.x
        let dy = p2.y - p1.y
        let tetha = atan2(dy, dx)
        return tetha
    }
}
