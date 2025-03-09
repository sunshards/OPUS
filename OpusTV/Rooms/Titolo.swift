//
//  title.swift
//  OpusTV
//
//  Created by Andrea Iannaccone on 08/03/25.
//

import Foundation
import SpriteKit

/* TEMPLATE
 
     InteractiveSprite(name: "NOMESPRITE", action: {(self) in
         
     })
 
 */

let titolo = Stanza(state: .title,
                  
  sounds : [
  ],
  
  interactives: [
    InteractiveSprite(name: "play", action: {(self) in
        sceneManager.selectRoom(.sala)
    })
]
)
