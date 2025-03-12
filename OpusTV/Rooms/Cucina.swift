//
//  Cucina.swift
//  OpusTV
//
//  Created by Simone Boscaglia on 06/03/25.
//

import Foundation
import SpriteKit

let cucina = Stanza(state: .cucina,
                    
   sounds : [
    "fuoco"
  ],
  
  interactives: [
    
    InteractiveSprite(name: "cucporta", touchAction: {(self) in
        sceneManager.selectRoom(.sala)
    },active: true),
    
    InteractiveSprite(name: "cucmestolopieno",
                      touchAction: {(self) in
                          if sceneManager.hasCollectedWater{
                              self.playSound(soundName: "Mestolo2")
                          }
                      },active: true),
    
    InteractiveSprite(name: "cuccamino",
                      touchAction: {(self) in
                          self.playSound(soundName: "Scream")
                      },active: false),
    
    InteractiveSprite(name: "cucacqua",touchAction: {
        (self) in
        sceneManager.hasCollectedWater = true
        sceneManager.inventory.addItem(InventoryItem(name: "cucacqua"))
        sceneManager.removeAntonio()
        DispatchQueue.main.async {
            self.removeFromParent()
        }
    },active: true),
    
    //MARK: Fiala ancora visbile alla rimozione
    InteractiveSprite(name: "cucfiala",touchAction: {
        (self) in
        if sceneManager.hasCollectedWater{
            sceneManager.inventory.addItem(InventoryItem(name: "cucfiala"))
            DispatchQueue.main.async {
                self.removeFromParent()
            }
        }
    },active: true)
    
])
