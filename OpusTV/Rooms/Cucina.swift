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
    
    InteractiveSprite(name: "cucporta", touchAction: {(self) in
        sceneManager.selectRoom(.sala)
    }),
    
    InteractiveSprite(name: "cucmestolopieno",
      touchAction: {(self) in
          if sceneManager.hasCollectedWater{
              self.playSound(soundName: "Mestolo2")
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
        self.delete()
    }),
    
    //MARK: Fiala ancora visbile alla rimozione
    InteractiveSprite(name: "cucfiala",touchAction: {
        (self) in
        if sceneManager.hasCollectedWater{
            sceneManager.inventory.addItem(InventoryItem(name: "boccia"))
            self.delete()
        }
    })
    
])
