//
//  Room.swift
//  OpusTV
//
//  Created by Simone Boscaglia on 06/03/25.
//
import Foundation
import SpriteKit

/* TEMPLATE
 
     InteractiveSprite(name: "NOMESPRITE", action: {(self) in
         
     })
 
 */

let sala = Stanza(state: .sala,
                  
  sounds : [
    "OrologioTick2"
  ],
  
  interactives: [
    
    InteractiveSprite(name: "salavasopieno", action: {(self) in
        self.playSound(soundName: "AperturaHorror")

        // Le rimozioni vanno fatte nel thread principale
        DispatchQueue.main.async {
            self.removeFromParent()
        }
    }),
    
    InteractiveSprite(name: "salaportacucina", action: {(self) in
        GameScene.shared.selectScene(.cucina)
    }),
    
    InteractiveSprite(name: "salapendolo", action: {(self) in
        print("pendolaccio")
    }),
    
    InteractiveSprite(name: "salaportalibreria", action: {(self) in
        GameScene.shared.selectScene(.libreria)
    }),
    
    
    
])
