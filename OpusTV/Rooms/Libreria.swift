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
                          self.run(SKAction.move(to: CGPoint(x: 0, y: 0), duration: 1))
                      }),
    InteractiveSprite(name: "libscale",
                      touchAction: {(self) in
                          sceneManager.selectRoom(.laboratorio)
                      }),
])
