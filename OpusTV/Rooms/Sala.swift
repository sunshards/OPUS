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
    
    InteractiveSprite(name: "antonio",
                      spawnAction: {(self) in
                          if sceneManager.hasCollectedWater {
                              DispatchQueue.main.async {
                                  self.removeFromParent()
                              }
                          }
                      },
                      hoverOnAction: {(self) in
                          sceneManager.textManager.showDialogue(lines: [
                            "I don't feel well...",
                            "Please, go grab me some water."
                          ], duration: 3)
                      }),
    
    InteractiveSprite(name: "salavasopieno",
      touchAction: {(self) in
          if sceneManager.hasCollectedWater{
              self.playSound(soundName: "Ceramica")
              
              sceneManager.inventory.addItem(InventoryItem(name: "fiore"))
              
              // Le rimozioni vanno fatte nel thread principale
              DispatchQueue.main.async {
                  self.removeFromParent()
              }
          }
      }),
    
    InteractiveSprite(name: "salaportacucina", touchAction: {(self) in
        sceneManager.selectRoom(.cucina)
    }),
    
    InteractiveSprite(name: "salaportalibreria", touchAction: {(self) in
        sceneManager.selectRoom(.libreria)
    }),
    
    InteractiveSprite(name: "salasedia",
                      hoverOnAction: {(self) in
  
                      },
                      touchAction: {(self) in
                          self.playSound(soundName: "SediaAperturaLegno")
                      }),
    
    InteractiveSprite(name: "salatazza",
                      touchAction: {(self) in
                          self.playSound(soundName: "Ceramica")
                      }),
    
    InteractiveSprite(name: "salacassa",
                      touchAction: {(self) in
                          if sceneManager.hasCollectedWater && !sceneManager.poisonCollected{
                              self.playSound(soundName: "BauleApertura")
                              sceneManager.inventory.addItem(InventoryItem(name: "veleno"))
                              sceneManager.poisonCollected = true
                          }
                      })
])
