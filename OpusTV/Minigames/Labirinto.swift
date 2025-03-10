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
    let velocity : CGFloat = 1.5
    let lightSensibility : CGFloat = 500
    
    override func didMove(to view: SKView) {
        let labirinto = childNode(withName: "labirinto")
        insetto = labirinto!.childNode(withName: "insetto") as! SKSpriteNode
        insetto.physicsBody?.usesPreciseCollisionDetection = true
        scene?.camera = childNode(withName:"camera") as? SKCameraNode
        sceneManager.assignScene(scene: scene!)
        sceneManager.light?.sensibility = lightSensibility

    }
    
    override func update(_ currentTime: TimeInterval) {
        guard let light = sceneManager.light else {print("update could not find light"); return}
        sceneManager.light?.smoothUpdate(transpose: insetto.position)
        //let dx = light.position.x - insetto.position.x
        //let dy = light.position.y - insetto.position.y
        // alla posizione della luce viene aggiunta la posizione dell'insetto e poi tolta per fare il delta
        // quindi alla fine la direzione è semplicemente la posizione della luce
        let direction = normalize(vector: light.position)//vector: CGPoint(x: dx, y: dy))
        insetto.position.x += direction.x * (velocity)
        insetto.position.y += direction.y * (velocity)
        let camera = childNode(withName:"camera")! as SKNode
        camera.position = insetto.position
        let rotation = atan2(direction.y, direction.x)
        //let rotation = angle(p1: insetto.position, p2: light.position)
        insetto.zRotation = rotation
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: self)
        
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
