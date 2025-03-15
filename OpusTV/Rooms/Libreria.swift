//
//  Biblioteca.swift
//  OpusTV
//
//  Created by Simone Boscaglia on 06/03/25.
//

import Foundation
import SpriteKit

let libreria = Stanza(state: .libreria,
                    
                    
   sounds : [
  ],
  
  interactives: [
    
    InteractiveSprite(name: "libporta", touchAction: {(self) in
        sceneManager.selectRoom(.sala)
    }),
    
    InteractiveSprite(name: "libsedia",
                      touchAction: {(self) in
                          self.playSound(soundName: "Sedia2")
                      }),
    InteractiveSprite(name: "libquadro",
                      touchAction: {(self) in
                          if   !sceneManager.hasMoved && sceneManager.hasCollectedWater {
                              self.run(SKAction.move(to: CGPoint(x: 220, y: 115), duration: 5))
                              self.playSound(soundName: "PassaggioSegreto")
                              sceneManager.hasMoved = true
                          }

                      }),
    InteractiveSprite(name: "libscale",
                      touchAction: {(self) in
                          sceneManager.selectRoom(.laboratorio)
                      }),
    
    InteractiveSprite(name: "libteca",
                      touchAction: {(self) in
                          sceneManager.switchToMinigame(state: .labirinto)
                      }),
    
    
])
