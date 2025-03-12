//
//  GameScene.swift
//  templateSpriteKit
//
//  Created by Ignazio Finizio on 07/04/22.
//

import SpriteKit

class Pozione: SKScene {
    let velocity : CGFloat = 1.5
    let lightSensibility : CGFloat = 2000
    var cauldronTextures : [SKTexture] = []
    var cauldronNode : SKSpriteNode = SKSpriteNode()
    var itemPositionsNode : SKNode = SKNode()
    
    override func didMove(to view: SKView) {
        sceneManager.assignScene(scene: scene!)
        sceneManager.light?.setSensibility(sensibility: lightSensibility)
        
        self.itemPositionsNode = childNode(withName: "itemPositions")!
        self.cauldronNode = childNode(withName: "calderone") as! SKSpriteNode
        self.cauldronTextures = importAnimationAtlas(atlas: SKTextureAtlas(named: "calderone"), animationName: "calderone", numberOfFrames: 16)
        let cauldronAnimation = SKAction.animate(with: cauldronTextures, timePerFrame: 0.1)
        cauldronNode.run(SKAction.repeatForever(cauldronAnimation))
        placeInventory()
    }
    
    override func update(_ currentTime: TimeInterval) {
        guard let light = sceneManager.light else {print("update could not find light"); return}
    }
    
    private func importAnimationAtlas(atlas : SKTextureAtlas, animationName : String, numberOfFrames : Int) -> [SKTexture] {
        var animation : [SKTexture] = []
        for i in 1...numberOfFrames {
            let textureName = animationName + "_\(i)"
            animation.append(atlas.textureNamed(textureName))
        }
        return animation
    }
    
    private func placeInventory() {
        let inventory = sceneManager.inventory
        for i in 0...inventory.items.count {
            guard let positionNode = childNode(withName: "\(i)") else { print("Could not find position \(i)"); return }
            let position = positionNode.position
            let node = inventory.createInventoryNode(itemName: inventory.items[i].name, point: position)
            addChild(node)
            positionNode.removeFromParent()
            
        }
    }
    
    
}
