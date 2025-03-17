//
//  Message.swift
//  OpusTV
//
//  Created by Simone Boscaglia on 10/02/25.
//

import Foundation

enum MessageType : Codable {
    // per la tv
    case touch
    case heartrate
    case startCalibration
    case endCalibration
    case gyroscope
    case pause
    case yes
    case no
    // per il telefono
    case back
    case confirm
    case vibration
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
