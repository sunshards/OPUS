//
//  GameScene.swift
//  templateSpriteKit
//
//  Created by Ignazio Finizio on 07/04/22.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let mpcManager: MPCManager = MPCManager.shared
//    let device : PhoneConnection = PhoneConnection.shared
    var objectSelected : Bool = false
    var lastCursorContacts : Int = 0
    
    var width : CGFloat = 1920
    var height : CGFloat = 1080
        
    var queueSize: Int  = 5
    var updateLightCounter = 0
    var lightPosition = CGPoint.zero
    var lightDisplayPosition = CGPoint.zero
    var xDirection : Int = 1
    var yDirection : Int = 1
    var velocity : Int = 10
    let sensibility : CGFloat = 2000//30
    let smoothness : Double = 0.15
    
    var xGyro : CGFloat = 0.0
    var yGyro : CGFloat = 0.0
    var zGyro : CGFloat = 0.0
    
    var xAcc : CGFloat = 0.0
    var yAcc : CGFloat = 0.0
    var zAcc : CGFloat = 0.0

    
    
    //MARK: - Analyse the cosllision/contact set up.
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
        //device.scene = scene
        mpcManager.delegate = self
        physicsWorld.contactDelegate = self
        
        mpcManager.startService()
        
//        let cursor = childNode(withName: "cursor") as! SKSpriteNode
//        cursor.physicsBody?.usesPreciseCollisionDetection = true
        
//        checkPhysics()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {

    }
    
    func didEnd(_ contact: SKPhysicsContact) {
    }
    
    override func update(_ currentTime: TimeInterval) {
            
        /*let newPoint = CGPoint(x: -zGyro * sensibility,
                              y: xGyro * sensibility) BEFORE ATTITUDE */
        let newPoint = CGPoint(x: -xGyro * sensibility, y: yGyro * sensibility)
        lightDisplayPosition = lerp(p1: lightDisplayPosition, p2: newPoint, t: smoothness)
        let lightNode = childNode(withName: "torch") as! SKLightNode
        let cursor = childNode(withName: "cursor") as! SKSpriteNode
        lightNode.position = lightDisplayPosition
        cursor.position = lightDisplayPosition
        spawnLight()

    }
    
    func spawnLight() {
        let cursor = childNode(withName: "cursor") as! SKSpriteNode
        guard let cursorBody = cursor.physicsBody else { return }
        
        // Tiene un conto del numero di oggetti toccati al momento dal cursore
        // Se il numero cambia, significa che ci sono luci da togliere o da aggiungere
        let currentCursorContacts : Int = cursorBody.allContactedBodies().count
        if currentCursorContacts != lastCursorContacts {
            if currentCursorContacts == 0 {
                // Remove all lights
                for child in scene?.children ?? [] {
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
                        objectLight.zPosition = 0 // relativo al padre
                        objectLight.size = node.size
                        objectLight.setScale(1.5)
                        objectLight.color = .yellow
                        objectLight.alpha = 0.8
                        scene?.addChild(objectLight)
                    }
                }
            }
        }
        lastCursorContacts = currentCursorContacts
        
        
    }
    
    func recalibrate() {
        lightPosition = CGPoint.zero
        let lightNode = childNode(withName: "torch") as! SKLightNode
        let cursor = childNode(withName: "cursor") as! SKSpriteNode
        lightNode.position = CGPoint.zero
        cursor.position = CGPoint.zero
    }
    
}

func lerp(p1 : CGPoint, p2 : CGPoint, t : Double) -> CGPoint {
    let newPoint = CGPoint(x: p1.x + CGFloat(t) * (p2.x - p1.x),  y: p1.y + CGFloat(t) * (p2.y - p1.y))
    return newPoint
}

func distanceBetweenPoints(first : CGPoint, second : CGPoint) -> Double {
    return sqrt( pow(Double(first.x-second.x), 2.0) + pow(Double(first.y-second.y), 2.0) )
}
