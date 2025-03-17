//
//  Laboratorio.swift
//  OpusTV
//
//  Created by Simone Boscaglia on 06/03/25.
//

import Foundation
import SpriteKit

let laboratorio = Stanza(state: .laboratorio,
                    
                    
   sounds : [
  ],
  
  interactives: [
    
    InteractiveSprite(name: "libporta", touchAction: {(self) in
        sceneManager.selectRoom(.sala)
    }),
    
    InteractiveSprite(name: "labarile",
                      touchAction: {(self) in
                          self.playSound(soundName: "Legno")
                      }),
    
    InteractiveSprite(name: "labscale",
                      touchAction: {(self) in
                          sceneManager.selectRoom(.libreria)
                      }),
        
    InteractiveSprite(name: "labmannaia",
                      touchAction: {(self) in
                          self.playSound(soundName: "Metal")
                      }),
    
    InteractiveSprite(name: "labcadavere",
                      touchAction: {(self) in
                          self.playSound(soundName: "EasterEgg")
                      }),
    
    InteractiveSprite(name: "labscale", touchAction: {(self) in
        sceneManager.selectRoom(.libreria)
    }),
    
    InteractiveSprite(name: "labcadavere",
                      touchAction: {(self) in
                          if sceneManager.inventory.hasItem("boccia"){
                              sceneManager.inventory.removeItem(InventoryItem(name: "boccia"))
                              sceneManager.inventory.addItem(InventoryItem(name: "bocciasangue"))
                          }
                      }),
    
    InteractiveSprite(name: "labcalderone",
                      touchAction: {(self) in
                          sceneManager.switchToMinigame(state: .pozione)
                          let message = Message(type: .back, vector: nil, state: nil)
                          sceneManager.mpcManager.send(message: message)
                          print("sending")
                      }),
])
