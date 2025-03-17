//
//  Sala.swift
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

let sala : Stanza = Stanza(state: .sala,
                  
  sounds : [
    "OrologioTick2"
  ],
                           
   interactives: [
    InteractiveSprite(name: "antonio",
                      spawnAction: {(self) in
                          if sceneManager.hasCollectedWater {
                              self.delete()
                          }
                      },
                      hoverOnAction: {(self) in
                          sceneManager.textManager.showDialogue(lines: [
                            "Oh hey there!",
                            "Thanks for coming so fast!",
                            "I'm not feeling well...",
                            "Could you grab me some water, please?"
                          ], duration: 0.5)
                      }),
    
    InteractiveSprite(name: "salavasopieno",
      touchAction: {(self) in
          if sceneManager.hasCollectedWater{
              self.playSound(soundName: "Ceramica")
              sceneManager.inventory.addItem(InventoryItem(name: "fiore"))
              self.delete()
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
                      spawnAction: {(self) in
                          if sceneManager.hasOpenedChest {self.delete()}
                      },
                      touchAction: {(self) in
                          if sceneManager.inventory.hasItem("chiave") {
                              self.playSound(soundName: "BauleApertura")
                              let s1 = self.room?.childNode(withName: "salacassaaperta") as? InteractiveSprite
                              let s2 = self.room?.childNode(withName: "salaveleno") as? InteractiveSprite
                              s1?.show()
                              s2?.show()
                              sceneManager.hasOpenedChest = true
                              self.delete()
                          }
                      }),
    InteractiveSprite(name: "salacassaaperta",
                      spawnAction: {(self) in
                          if sceneManager.hasOpenedChest == true {self.show()} else {self.hide()}
                      }),
    InteractiveSprite(name: "salaveleno",
                      spawnAction: {(self) in
                          if sceneManager.hasOpenedChest && !sceneManager.poisonCollected {self.show()} else {self.hide()}
                      },
                      touchAction: {(self) in
                          sceneManager.inventory.addItem(InventoryItem(name: "veleno"))
                          sceneManager.poisonCollected = true
                          self.delete()
                      }),
 ]
)
