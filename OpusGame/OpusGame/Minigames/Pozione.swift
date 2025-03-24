//
//  Labirinto.swift
//  OpusTV
//
//   Created by Simone Boscaglia on 28/02/25
//

import SpriteKit

class Pozione: SKScene {
    let velocity : CGFloat = 1.5
    let lightSensibility : CGFloat = 2000
    var cauldronNode : SKSpriteNode = SKSpriteNode()
    var itemPositionsNode : SKNode = SKNode()
    var totalItems : Int = 9
    
    override func didMove(to view: SKView) {
        sceneManager.assignScene(scene: scene!)
        sceneManager.light?.setSensibility(sensibility: lightSensibility)
        
        self.itemPositionsNode = childNode(withName: "ItemPositions")!
        self.cauldronNode = childNode(withName: "calderone") as! SKSpriteNode
        let cauldronAnimation = AnimationManager.generateAnimation(atlasName: "calderone", animationName: "calderone", numberOfFrames: 16, timePerFrame: 0.1)
        cauldronNode.run(SKAction.repeatForever(cauldronAnimation))
        placeInventory()
    }
    
    override func update(_ currentTime: TimeInterval) {
        sceneManager.light?.smoothUpdate()
        highlightObjects()

    }
    
    
    private func placeInventory() {
        DispatchQueue.main.async {
            
            let inventory = sceneManager.inventory
            print(inventory.items.count)
            for i in 0..<inventory.items.count {
                guard let positionNode = self.itemPositionsNode.childNode(withName: "\(i)") else { print("Could not find position \(i)"); return }
                guard let populator = sceneManager.populator else { print("Could not find populator"); return}
                
                let item = inventory.items[i]
                let position = positionNode.position
                let node = inventory.createInventoryNode(itemName: item.name, point: position)
                scaleProportionally(sprite: node, axis: .y, value: positionNode.frame.height)
                node.lightingBitMask = 1
                self.itemPositionsNode.addChild(node)
                let interactive : InteractiveSprite = InteractiveSprite(name: item.name, sprite: node, touchAction: {(self) in
                    print("tocco")
                    self.color = .black
                    self.colorBlendFactor = 1
                    if isAddable[item.name] ?? false {
                        sceneManager.addToCauldron(item: item.name)
                    }
                }, active : true)
                populator.swap(interactable: interactive, sprite: node)
                positionNode.isHidden = true
            }
            for i in inventory.items.count ..< self.totalItems {
                guard let positionNode = self.itemPositionsNode.childNode(withName: "\(i)") else { print("Could not find position \(i)"); return }
                positionNode.isHidden = true
            }
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
