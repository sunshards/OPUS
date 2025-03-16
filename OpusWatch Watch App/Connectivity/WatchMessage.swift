//
//  WatchMessage.swift
//  OpusWatch Watch App
//
//  Created by Simone Boscaglia on 11/03/25.
//

import Foundation

struct WatchMessage : Codable {
    let heartRate : Double

    func toData() -> Data? {
        var data : Data? = nil
        
        do {
            data = try JSONEncoder().encode(self)
        } catch {
            print("An error occured")
        }
        
        return data
    }
    
    static func toMessage(from data: Data) -> WatchMessage? {
        try? JSONDecoder().decode(WatchMessage.self, from: data)
    }
}
