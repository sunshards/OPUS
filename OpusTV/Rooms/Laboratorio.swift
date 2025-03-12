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
    },active: true),
    
    InteractiveSprite(name: "labarile",
                      touchAction: {(self) in
                          self.playSound(soundName: "Legno")
                      },active: true),
    
    InteractiveSprite(name: "labscale",
                      touchAction: {(self) in
                          sceneManager.selectRoom(.libreria)
                      },active: true),
    
//https://youtu.be/f8mL0_4GeV0?si=czQ1LuuEcC3cZZqO
    
    InteractiveSprite(name: "labmannaia",
                      touchAction: {(self) in
                          self.playSound(soundName: "Metal")
                      },active: true),
    
    InteractiveSprite(name: "labcadavere",
                      touchAction: {(self) in
                          self.playSound(soundName: "EasterEgg")
                      },active: false),
    
    InteractiveSprite(name: "labscale", touchAction: {(self) in
        sceneManager.selectRoom(.libreria)
    },active: true),
    
    InteractiveSprite(name: "labcadavere",
                      touchAction: {(self) in
                          if sceneManager.inventory.checkItemExists("cucfiala"){
                              sceneManager.inventory.removeItem(InventoryItem(name: "cucfiala"))
                              sceneManager.inventory.addItem(InventoryItem(name: "boccia"))
                          }
                      } ,active: true)
])
