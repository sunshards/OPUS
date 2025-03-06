//
//  Room.swift
//  OpusTV
//
//  Created by Simone Boscaglia on 06/03/25.
//
import Foundation

/* TEMPLATE
 
     InteractiveSprite(name: "NOMESPRITE", action: {(self) in
         
     })
 
 */

let sala = Stanza(state: .sala, interactives: [
    
    InteractiveSprite(name: "salavasopieno", action: {(self) in
            
        print("hi")
        // Le rimozioni vanno fatte nel thread principale
        DispatchQueue.main.async {
            self.removeFromParent()
        }
    }),
    
    InteractiveSprite(name: "salapendolo", action: {(self) in
        print("pendolooo")
    })
    
])
