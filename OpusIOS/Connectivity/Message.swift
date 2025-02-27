//
//  Message.swift
//  PartyEat_iOS
//
//  Created by Simone Boscaglia on 10/02/25.
//

import Foundation

struct Message : Codable {
    let xGyro : CGFloat
    let yGyro : CGFloat
    let zGyro : CGFloat
    
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
