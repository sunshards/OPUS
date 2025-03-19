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
                           
       action: {(self) in},
                  
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
                      touchAction: {(self) in
                          if !sceneManager.hasCollectedWater{
                              sceneManager.textManager.showDialogue(lines: [
                                "Oh! Hey there...",
                                "Thanks for coming so fast.",
                                "I'm not feeling well...",
                                "Could you grab me some water, please?"
                              ], duration: 0.5)
                          }}),
    
    InteractiveSprite(name: "salavasopieno",
                      spawnAction: {(self) in
                          if sceneManager.hasCollectedFlower{
                              self.delete()
                          }
                      },
                      touchAction: {(self) in
                          if sceneManager.hasCollectedWater{
                              audio.playSoundEffect(named: "Ceramica")
                              sceneManager.inventory.addItem(InventoryItem(name: "fiore"))
                              sceneManager.textManager.displayText("You collected a moon flower.", for: 4)

                              sceneManager.hasCollectedFlower = true
                              self.delete()
                          }
                      }),
    
    InteractiveSprite(name: "salaportacucina",
      touchAction: {(self) in
          audio.playSoundEffect(named: "ChiaveApertura")
          sceneManager.selectRoom(.cucina)
    }),
    
    InteractiveSprite(name: "salaportalibreria", touchAction: {(self) in
        audio.playSoundEffect(named: "ChiaveApertura")
        sceneManager.selectRoom(.libreria)
    }),
    
    InteractiveSprite(name: "salasedia",
                      touchAction: {(self) in
                          audio.playSoundEffect(named: "SediaAperturaLegno")
                      }),
    
    InteractiveSprite(name: "salatazza",
                      touchAction: {(self) in
                          audio.playSoundEffect(named: "Ceramica")
                      }),
    InteractiveSprite(name: "salacassa",
                      spawnAction: {(self) in
                          if sceneManager.hasOpenedChest {self.delete()}
                      },
                      touchAction: {(self) in
                          if sceneManager.inventory.hasItem("chiave") {
                              audio.playSoundEffect(named: "AperturaHorror")
                              let s1 = self.room?.childNode(withName: "salacassaaperta") as? InteractiveSprite
                              let s2 = self.room?.childNode(withName: "salaveleno") as? InteractiveSprite
                              s1?.show()
                              s2?.show()
                              sceneManager.hasOpenedChest = true
                              sceneManager.inventory.removeItem(name: "chiave")
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
                          sceneManager.textManager.displayText("You collected poison.", for: 4)
                          sceneManager.poisonCollected = true
                          self.delete()
                      }),
 ]
)
