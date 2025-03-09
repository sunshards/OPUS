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
    
    InteractiveSprite(name: "libporta", action: {(self) in
        sceneManager.selectRoom(.sala)
    })
    
])
