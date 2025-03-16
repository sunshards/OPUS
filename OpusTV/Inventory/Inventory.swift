//
//  InventoryScene.swift
//  OpusTV
//
//  Created by Simone Boscaglia on 06/03/25.
//

import SpriteKit

class Inventory {
    
    private var position : CGPoint = .zero
    private var itemNodes : [SKSpriteNode] = []

    var items: [InventoryItem] = []
    var node : SKNode?
    var background : SKSpriteNode = SKSpriteNode()
    let itemHeight : CGFloat = 80
    let itemOffset : CGFloat = 30
    let padding : CGFloat = 50
    let zPosition : CGFloat = 20
    
    var scene : SKScene? {
        return self.node?.scene
    }
    
    let xInventoryPadding : CGFloat = 80
    let yInventoryPadding : CGFloat = 80
        
    func setPosition(point : CGPoint) {
        position = point
        node?.position = point
        background.position = point
    }
    
    func positionOnScreen() {
        // positions the inventory on the top left
        guard let width = scene?.frame.width else { print("couldnt find width in inventory placement"); return }
        guard let height = scene?.frame.height else { print("couldnt find height in inventory placement"); return  }
        self.setPosition(point: CGPoint(x: -width/2+self.xInventoryPadding, y: height/2-2*self.yInventoryPadding))
    }
    
    func addItem(_ item: InventoryItem) {
        items.append(item)
        regenerateNode()
    }
    
    func removeItem(_ item: InventoryItem) {
        items.removeAll{ $0.name == item.name }
        regenerateNode()
    }
    
    func hasItem(_ itemName: String) -> Bool {
        return items.contains { $0.name == itemName }
    }
    
    func assignNode(n : SKNode) {
        self.node?.removeAllActions()
        self.node?.removeFromParent()
        self.node = n
        node?.zPosition = self.zPosition
        background = SKSpriteNode(color: .black, size: .zero)
        background.alpha = 0.2
        background.zPosition = 15
        node?.addChild(background)
        positionOnScreen()
    }
    
    func regenerateNode() {
        // The node is placed such that the inventory position is in the bottom left of the background
        DispatchQueue.main.async {
            self.node?.removeAllChildren()
        }

        var xOffset : CGFloat = 0
        for item in items {
            let itemNode = SKSpriteNode(imageNamed: item.name)
            scaleProportionally(sprite: itemNode, axis: .y, value: itemHeight)
            xOffset += itemNode.size.width + itemOffset
            itemNode.position.x = xOffset
            itemNode.position.y = itemHeight/2+padding/2
            itemNode.zPosition = 1
            self.node?.addChild(itemNode)
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
