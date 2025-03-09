//
//  Room.swift
//  OpusTV
//
//  Created by Simone Boscaglia on 06/03/25.
//
import Foundation
import SpriteKit

/* TEMPLATE
 
     InteractiveSprite(name: "NOMESPRITE", touchAction: {(self) in
         
     })
 
 */

let sala = Stanza(state: .sala,
                  
  sounds : [
    "OrologioTick2"
  ],
  
  interactives: [
    
    InteractiveSprite(name: "salavasopieno", touchAction: {(self) in
        self.playSound(soundName: "AperturaHorror")
        
        sceneManager.inventory.addItem(InventoryItem(name: "fiore"))

        // Le rimozioni vanno fatte nel thread principale
        DispatchQueue.main.async {
            self.removeFromParent()
        }
    }),
    
    InteractiveSprite(name: "salaportacucina", touchAction: {(self) in
        sceneManager.selectRoom(.cucina)
    }),
    
    InteractiveSprite(name: "salaportalibreria", touchAction: {(self) in
        sceneManager.selectRoom(.libreria)
    })
    
    
    
])
