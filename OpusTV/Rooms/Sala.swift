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
    
    InteractiveSprite(name: "salavasopieno",
      touchAction: {(self) in
          if sceneManager.hasCollectedWater{
        self.playSound(soundName: "Ceramica")
        
        sceneManager.inventory.addItem(InventoryItem(name: "fiore"))

        // Le rimozioni vanno fatte nel thread principale
        DispatchQueue.main.async {
            self.removeFromParent()
        }}
      },active: true),
    
    InteractiveSprite(name: "salaportacucina", touchAction: {(self) in
        sceneManager.selectRoom(.cucina)
    },active: true),
    
    InteractiveSprite(name: "salaportalibreria", touchAction: {(self) in
        sceneManager.selectRoom(.libreria)
    },active: true),
    
    InteractiveSprite(name: "salasedia",
                      hoverOnAction: {(self) in
                          sceneManager.textManager.showForDuration(5)
                      },
                      touchAction: {(self) in
                          self.playSound(soundName: "SediaAperturaLegno")
                      },active: true),
    
    InteractiveSprite(name: "salatazza",
                      touchAction: {(self) in
                          self.playSound(soundName: "Ceramica")
                      },active: true),
    
    InteractiveSprite(name: "salacassa",
                      touchAction: {(self) in
                          if sceneManager.hasCollectedWater && !sceneManager.poisonCollected{
                              self.playSound(soundName: "BauleApertura")
                              sceneManager.inventory.addItem(InventoryItem(name: "veleno"))
                              sceneManager.poisonCollected = true
                          }
                      },active: true)
])
