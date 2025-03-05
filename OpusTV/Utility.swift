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
