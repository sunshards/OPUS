//
//  Utility.swift
//  OpusTV
//
//  Created by Simone Boscaglia on 05/03/25.
//

import SpriteKit

func lerp(p1 : CGPoint, p2 : CGPoint, t : Double) -> CGPoint {
    let newPoint = CGPoint(x: p1.x + CGFloat(t) * (p2.x - p1.x),  y: p1.y + CGFloat(t) * (p2.y - p1.y))
    return newPoint
}

func distanceBetweenPoints(first : CGPoint, second : CGPoint) -> Double {
    return sqrt( pow(Double(first.x-second.x), 2.0) + pow(Double(first.y-second.y), 2.0) )
}

func scaleProportionally(sprite : SKSpriteNode, axis: axis, value : CGFloat) {
    guard let texture = sprite.texture else {print("Failed to scale proportionally sprite \(sprite.name ?? "no name")"); return}
    if axis == .x {
        let percent = value / texture.size().width
        sprite.size = CGSize(width: value, height: texture.size().height * percent)
    } else {
        let percent = value / texture.size().height
        sprite.size = CGSize(width: texture.size().width * percent, height: value)
    }
    
}

extension SKPhysicsBody
{
    override open func copy() -> Any {
        guard let body = super.copy() as? SKPhysicsBody else {fatalError("SKPhysicsBody.copy() failed")}
        body.affectedByGravity = affectedByGravity
        body.allowsRotation = allowsRotation
        body.isDynamic = isDynamic
        body.mass = mass
        body.density = density
        body.friction = friction
        body.restitution = restitution
        body.linearDamping = linearDamping
        body.angularDamping = angularDamping
        return body
    }
}

func normalize(vector : CGPoint) -> CGPoint {
    var newVector : CGPoint = .zero
    let norm = sqrt((vector.x * vector.x) + (vector.y * vector.y))
    newVector.x = vector.x / CGFloat(norm)
    newVector.y = vector.y / CGFloat(norm)
    return newVector
}

func copyInteractivesArray(_ array : [InteractiveSprite]) -> [InteractiveSprite] {
    var newArray : [InteractiveSprite] = []
    for sprite in array {
        newArray.append(sprite.duplicateWithoutSprite())
    }
    return newArray
}
