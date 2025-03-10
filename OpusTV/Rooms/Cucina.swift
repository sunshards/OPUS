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
    }),
    
    InteractiveSprite(name: "cucmestolopieno",
                      touchAction: {(self) in
                          self.playSound(soundName: "Mestolo2")
                      }),
    
    InteractiveSprite(name: "cucamino",
                      touchAction: {(self) in
                          self.playSound(soundName: "Scream")
                      }),
    
])
