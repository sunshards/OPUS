//
//  Message.swift
//  PartyEat_iOS
//
//  Created by Simone Boscaglia on 10/02/25.
//

import Foundation

enum MessageType : Codable {
    case touch
    case heartrate
    case calibration
    case gyroscope
    case accelerometer
}

struct Vector3D : Codable {
    let x : CGFloat
    let y : CGFloat
    let z : CGFloat
}

struct Message : Codable {
    let type : MessageType
    let vector : Vector3D?
    var state : Bool?
    
    

    func toData() -> Data? {
        var data : Data? = nil
        
        do {
            data = try JSONEncoder().encode(self)
        } catch {
            print("An error occured")
        }
        
        return data
    }
    
    static func toMessage(from data: Data) -> Message? {
        try? JSONDecoder().decode(Message.self, from: data)
    }
}

