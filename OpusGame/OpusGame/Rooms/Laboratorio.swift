//
//  Laboratorio.swift
//  OpusTV
//
//  Created by Simone Boscaglia on 06/03/25.
//

import Foundation
import SpriteKit

let laboratorio = Stanza(state: .laboratorio,
                         
                         action: {(self) in
    audio.stopMusic()
    audio.playMusic("Atmosfera2")
},
                
   sounds : [
  ],
  
  interactives: [
    
    InteractiveSprite(name: "libporta",
                      touchAction: {(self) in
        sceneManager.selectRoom(.sala)
    }),
    
    InteractiveSprite(name: "labarile",
                      touchAction: {(self) in
                          audio.playSoundEffect(named: "Legno")
                      }),
    
    InteractiveSprite(name: "labscale",
                      touchAction: {(self) in
                          sceneManager.selectRoom(.libreria)
                      }),
        
    InteractiveSprite(name: "labmannaia",
                      touchAction: {(self) in
                          audio.playSoundEffect(named: "Metal")
                      }),
    
    InteractiveSprite(name: "labscale", touchAction: {(self) in
        audio.stopMusic()
        audio.playMusic("Atmosfera")
        sceneManager.selectRoom(.libreria)
    }),
    
    InteractiveSprite(name: "labcadavere",
                      touchAction: {(self) in
                          print("boccia")
                          if sceneManager.inventory.hasItem("boccia"){
                              audio.playSoundEffect(named: "Sangue")
                              sceneManager.inventory.removeItem(name: "boccia")
                              sceneManager.inventory.addItem(InventoryItem(name: "bocciasangue"))
                              sceneManager.textManager.displayText("You collected blood.", for: 4)

                          }
                      }),
    
    InteractiveSprite(name: "labcalderone",
                      touchAction: {(self) in
                          sceneManager.switchToMinigame(newState: .pozione)
                          let message = Message(type: .back, vector: nil, state: nil)
                          sceneManager.mpcManager.send(message: message)
                      }),
])
