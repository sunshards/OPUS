//
//  Utility.swift
//  OpusTV
//
//  Created by Simone Boscaglia on 05/03/25.
//

import SpriteKit

enum axis {
    case x
    case y
}

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
