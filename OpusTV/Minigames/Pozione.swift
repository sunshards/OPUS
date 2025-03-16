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
    var totalItems : Int = 9
    
    override func didMove(to view: SKView) {
        sceneManager.assignScene(scene: scene!)
        sceneManager.light?.setSensibility(sensibility: lightSensibility)
        
        self.itemPositionsNode = childNode(withName: "ItemPositions")!
        self.cauldronNode = childNode(withName: "calderone") as! SKSpriteNode
        self.cauldronTextures = importAnimationAtlas(atlas: SKTextureAtlas(named: "calderone"), animationName: "calderone", numberOfFrames: 16)
        let cauldronAnimation = SKAction.animate(with: cauldronTextures, timePerFrame: 0.1)
        cauldronNode.run(SKAction.repeatForever(cauldronAnimation))
        placeInventory()
    }
    
    override func update(_ currentTime: TimeInterval) {
        sceneManager.light?.smoothUpdate()
        highlightObjects()

    }
    
    private func importAnimationAtlas(atlas : SKTextureAtlas, animationName : String, numberOfFrames : Int) -> [SKTexture] {
        var animation : [SKTexture] = []
        for i in 1...numberOfFrames {
            let textureName = animationName + "_\(i)"
            animation.append(atlas.textureNamed(textureName))
        }
        return animation
    }
    
    func addToCauldron(item : InteractiveSprite) {
        
    }
    
    private func placeInventory() {
        let inventory = sceneManager.inventory
        print(inventory.items.count)
        for i in 0..<inventory.items.count {
            guard let positionNode = itemPositionsNode.childNode(withName: "\(i)") else { print("Could not find position \(i)"); return }
            guard let populator = sceneManager.populator else { print("Could not find populator"); return}

            let item = inventory.items[i]
            let position = positionNode.position
            let node = inventory.createInventoryNode(itemName: item.name, point: position)
            scaleProportionally(sprite: node, axis: .y, value: positionNode.frame.height)
            node.lightingBitMask = 1
            node.zPosition = positionNode.zPosition + 1
            node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.height)
            node.physicsBody?.affectedByGravity = false
            node.physicsBody?.allowsRotation = false
            node.physicsBody?.categoryBitMask = 2
            node.physicsBody?.collisionBitMask = 0
            node.physicsBody?.fieldBitMask = 0
            node.physicsBody?.contactTestBitMask = 0

            itemPositionsNode.addChild(node)
            let interactive : InteractiveSprite = InteractiveSprite(name: item.name, sprite: node, touchAction: {(self) in
                print("tocco")
                self.color = .black
                self.colorBlendFactor = 1
            }, active : true)
            populator.swap(interactable: interactive, sprite: node)
            positionNode.isHidden = true
        }
        for i in inventory.items.count ..< totalItems {
            guard let positionNode = itemPositionsNode.childNode(withName: "\(i)") else { print("Could not find position \(i)"); return }
            positionNode.isHidden = true
        }
    }
    
    func highlightObjects() {
        guard let scene = self.scene else {print("highlight objects could not find scene"); return}
        guard let light = sceneManager.light else {print("highlight objects could not find light"); return}
        guard let cursorBody = light.cursor.physicsBody else { print("highlight objects could not find cursor body"); return }
        
        // Tiene un conto del numero di oggetti toccati al momento dal cursore
        // Se il numero cambia, significa che ci sono luci da togliere o da aggiungere
        let currentCursorContacts : Int = cursorBody.allContactedBodies().count
        if currentCursorContacts != light.lastCursorContacts {
            if currentCursorContacts == 0 {
                // Remove all lights
                for child in scene.children {
                    if child.name == "objectLight" {
                        child.removeFromParent()
                    }
                }
            }
            else {
                // Spawn lights for object in contact with the cursor
                for body in cursorBody.allContactedBodies() {
                    guard let node = body.node as? SKSpriteNode else { continue }
                    if body.categoryBitMask == 2 { // Categoria degli interagibili
                        let objectLight = SKSpriteNode(imageNamed: "light")
                        objectLight.name = "objectLight"
                        objectLight.position = node.position
                        objectLight.zPosition = -50 // relativo al padre
                        objectLight.size = node.size
                        objectLight.setScale(0.8)
                        objectLight.color = .yellow
                        objectLight.alpha = 0.5
                        scene.addChild(objectLight)
                    }
                }
            }
        }
        light.lastCursorContacts = currentCursorContacts
    }
    
}
