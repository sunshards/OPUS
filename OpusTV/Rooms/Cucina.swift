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
  ],
  
  interactives: [
    
    InteractiveSprite(name: "cucporta", touchAction: {(self) in
        sceneManager.selectRoom(.sala)
    }),
    
])
