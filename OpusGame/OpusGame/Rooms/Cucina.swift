//
//  Cucina.swift
//  OpusTV
//
//  Created by Simone Boscaglia on 06/03/25.
//

import Foundation
import SpriteKit

let cucina = Stanza(state: .cucina,
    action: {(self) in
        sceneManager.removedAntonio = true
    },
   sounds : [
    "fuoco"
  ],
  
  interactives: [
    
    InteractiveSprite(name: "cucporta",
        touchAction: {(self) in
        audio.playSoundEffect(named: "ChiaveApertura")
        sceneManager.selectRoom(.sala)
    }),
    
    InteractiveSprite(name: "cucmestolopieno",
      touchAction: {(self) in
          if sceneManager.hasCollectedWater{
              audio.playSoundEffect(named: "Mestolo2")
          }
      }),
    
    InteractiveSprite(name: "cucacqua",
          spawnAction: {(self) in
              if sceneManager.hasCollectedWater {
                  self.delete()
              }
          },
                      
          touchAction: {
        (self) in
        sceneManager.hasCollectedWater = true
        sceneManager.inventory.addItem(InventoryItem(name: "acqua"))
        sceneManager.textManager.displayText("You collected water.", for: 4)

        self.delete()
    }),
    
    InteractiveSprite(name: "cucfiala",
                      spawnAction: {(self) in
                          if sceneManager.hasCollectedBecker {
                              self.delete()
                          }
                      },
        touchAction: {(self) in
        if sceneManager.hasCollectedWater{
            sceneManager.inventory.addItem(InventoryItem(name: "boccia"))
            sceneManager.textManager.displayText("You collected a glass.", for: 4)
            sceneManager.hasCollectedBecker = true
            self.delete()
        }
    })
    
])
