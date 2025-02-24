//
//  GameScene.swift
//  templateSpriteKit
//
//  Created by Ignazio Finizio on 07/04/22.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
   
    var width : CGFloat = 1920
    var height : CGFloat = 1080
    var lightPosition = CGPoint(x: 0, y: 0)
    var xDirection : Int = 1
    var yDirection : Int = 1
    var velocity : Int = 10

    //MARK: - Analyse the collision/contact set up.
    func checkPhysics() {

        // Create an array of all the nodes with physicsBodies
        var physicsNodes = [SKNode]()

        //Get all physics bodies
            enumerateChildNodes(withName: "//.") { node, _ in
            if let _ = node.physicsBody {
                physicsNodes.append(node)
            } else {
                print("\(String(describing: node.name)) does not have a physics body so cannot collide or be involved in contacts.")
            }
        }

        //For each node, check it's category against every other node's collion and contctTest bit mask
        for node in physicsNodes {
            let category = node.physicsBody!.categoryBitMask
            // Identify the node by its category if the name is blank
            let name = node.name != nil ? node.name : "Category \(category)"
            let collisionMask = node.physicsBody!.collisionBitMask
            let contactMask = node.physicsBody!.contactTestBitMask

            // If all bits of the collisonmask set, just say it collides with everything.
            if collisionMask == UInt32.max {
                print("\(String(describing: name)) collides with everything")
            }

            for otherNode in physicsNodes {
                if (node != otherNode) && (node.physicsBody?.isDynamic == true) {
                    let otherCategory = otherNode.physicsBody!.categoryBitMask
                    // Identify the node by its category if the name is blank
                    let otherName = otherNode.name != nil ? otherNode.name : "Category \(otherCategory)"

                    // If the collisonmask and category match, they will collide
                    if ((collisionMask & otherCategory) != 0) && (collisionMask != UInt32.max) {
                        print("\(String(describing: name)) collides with \(String(describing: otherName))")
                    }
                    // If the contactMAsk and category match, they will contact
                    if (contactMask & otherCategory) != 0 {print("\(String(describing: name)) notifies when contacting \(String(describing: otherName))")}
                    }
                }
            }
        }
    
    // START OF THE GAME
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        //checkPhysics()

        width = scene?.frame.width ?? 1920
        height = scene?.frame.height ?? 1080

    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        // NON RIDIMENSIONARE USANDO LA SCALE, MA CAMBIANDO LA SIZE DEGLI SPRITE ALTRIMENTI LA LUCE NON COMPARE
        print("Inizio contatto: ", contact.bodyB.node?.name ?? "no name")
        if let object = contact.bodyB.node as? SKSpriteNode {
            let objectLight = SKSpriteNode(imageNamed: "light")
            objectLight.position = CGPoint(x: 0, y: 0)
            objectLight.zPosition = -1 // relativo al padre
            objectLight.size = object.size
            objectLight.setScale(1.1)
            objectLight.name = "light"
            objectLight.color = .yellow
            objectLight.alpha = 0.5
            object.addChild(objectLight)
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        print("Fine contatto: ", contact.bodyB.node?.name ?? "no name")
        if let object = contact.bodyB.node as? SKSpriteNode {
            if let child = object.childNode(withName: "light") as? SKSpriteNode {
                child.removeFromParent()
            }

        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        var x = lightPosition.x
        var y = lightPosition.y
        if (x > width/2 || x < -width/2) {
            xDirection *= -1
        }
        if (y > height/2 || y < -height/2) {
            yDirection *= -1
        }
        x += CGFloat(velocity * xDirection)
        y += CGFloat(velocity * yDirection)
        lightPosition = CGPoint(x:x, y:y)
        //print(lightPosition)
        let lightNode = childNode(withName: "torch") as! SKLightNode
        let cursor = childNode(withName: "cursor") as! SKSpriteNode
        lightNode.position = lightPosition
        cursor.position = lightPosition
    }
    

    
    
    
}
