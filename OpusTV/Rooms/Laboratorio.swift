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
    
//https://youtu.be/f8mL0_4GeV0?si=czQ1LuuEcC3cZZqO
    
    InteractiveSprite(name: "labmannaia",
                      touchAction: {(self) in
                          self.playSound(soundName: "Metal")
                      }),
    
    InteractiveSprite(name: "labcadavere",
                      touchAction: {(self) in
                          self.playSound(soundName: "EasterEgg")
                      }),
    
])
