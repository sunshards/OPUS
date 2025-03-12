//
//  InventoryScene.swift
//  OpusTV
//
//  Created by Andrea Iannaccone on 06/03/25.
//

import SpriteKit

class Inventory {
    
    private var position : CGPoint = .zero
    private var itemNodes : [SKSpriteNode] = []

    var items: [InventoryItem] = []
    let node : SKNode = SKNode()
    let background : SKSpriteNode
    let itemHeight : CGFloat = 100
    let itemOffset : CGFloat = 40
    let padding : CGFloat = 50
    let zPosition : CGFloat = 5
    
    init(position: CGPoint) {
        background = SKSpriteNode(color: .black, size: .zero)
        setPosition(point: position)
        background.alpha = 0.2
        node.zPosition = self.zPosition
        node.addChild(background)
        background.zPosition = 1
        regenerateNode()
    }
    
    func setPosition(point : CGPoint) {
        position = point
        node.position = point
        background.position = point
        regenerateNode()
    }
    
    func addItem(_ item: InventoryItem) {
        items.append(item)
        regenerateNode()
    }
    
    
    func removeItem(_ item: InventoryItem) {
        items.removeAll { $0.name == item.name }
        regenerateNode()
    }
    
    func regenerateNode() {
        // The node is placed such that the inventory position is in the bottom left of the background
        DispatchQueue.main.async {
            self.node.removeChildren(in: self.itemNodes) // Clear previous items
        }

        var xOffset : CGFloat = 0
        for item in items {
            let itemNode = SKSpriteNode(imageNamed: item.name)
            scaleProportionally(sprite: itemNode, axis: .y, value: itemHeight)
            xOffset += itemNode.size.width + itemOffset
            itemNode.position.x = xOffset
            itemNode.position.y = itemHeight/2+padding/2
            itemNode.zPosition = 1
            node.addChild(itemNode)
            itemNodes.append(itemNode)
        }
        background.size = CGSize(width: xOffset+padding, height: itemHeight+padding)
        background.position = CGPoint(x: background.size.width/2+padding/2, y: itemHeight/2+padding/2)

    }
    
    func createInventoryNode (itemName : String, point: CGPoint) -> SKSpriteNode {
        let itemNode = SKSpriteNode(imageNamed: itemName)
        itemNode.position = point
        itemNode.zPosition = 1
        return itemNode
    }
}
