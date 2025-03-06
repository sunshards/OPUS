//
//  Room.swift
//  OpusTV
//
//  Created by Simone Boscaglia on 06/03/25.
//
import Foundation

let sala = Stanza(state: .sala, interactives: [
    
    InteractiveSprite(name: "salavasopieno", action: {(self) in
            
        print("hi")
        // Le rimozioni vanno fatte nel thread principale
        DispatchQueue.main.async {
            self.removeFromParent()
        }
    })
    
])
