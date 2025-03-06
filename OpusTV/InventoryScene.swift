//
//  InventoryScene.swift
//  OpusTV
//
//  Created by Andrea Iannaccone on 06/03/25.
//

import SpriteKit

class InventoryScene: SKScene {
    
    private var inventory: [InventoryItem] = []
    private let inventoryNode = SKNode()
    
    override func didMove(to view: SKView) {
        addChild(inventoryNode)
        setupInventoryUI()
    }

    func setupInventoryUI() {
        let inventoryBackground = SKSpriteNode(color: .black, size: CGSize(width: 300, height: 100))
        inventoryBackground.position = CGPoint(x: frame.midX, y: frame.maxY - 50)
        inventoryBackground.zPosition = 1
        addChild(inventoryBackground)
        
        // Adding some example items
        addItem(InventoryItem(name: "Health Potion"))
        addItem(InventoryItem(name: "Mana Potion"))
        
        displayInventory()
    }
    
    func addItem(_ item: InventoryItem) {
        inventory.append(item)
    }
    
    func displayInventory() {
        inventoryNode.removeAllChildren() // Clear previous items
        
        let itemSpacing: CGFloat = 50.0
        for (index, item) in inventory.enumerated() {
            let itemNode = SKSpriteNode()
            itemNode.position = CGPoint(x: -CGFloat(inventory.count - 1) * itemSpacing + CGFloat(index) * itemSpacing, y: 0)
            itemNode.zPosition = 2
            inventoryNode.addChild(itemNode)
        }
    }
}
