//
//  Titolo.swift
//  OpusTV
//
//  Created by Andrea Iannaccone on 08/03/25.
//

import Foundation
import SpriteKit

/* TEMPLATE
 
 InteractiveSprite(name: "NOMESPRITE", touchAction: {(self) in
 
 })
 
 */

let titolo = Stanza(
    state: .title,
    action: {(self) in
        let playoff = self.node?.childNode(withName:"activeoff") as? SKSpriteNode
        let playon = self.node?.childNode(withName:"activeon") as? SKSpriteNode
        playon?.lightingBitMask = 0
        playoff?.isHidden = true
        playon?.isHidden = true
    },
    
    sounds : [
    ],
    
    interactives: [
        InteractiveSprite(name: "activeoff",
              hoverOnAction: {(self) in
                  if self.isHidden == false {
                      self.room?.childNode(withName:"activeon")?.isHidden = false
                      self.room?.childNode(withName:"activeoff")?.isHidden = true
                  }
              }),
        InteractiveSprite(name: "activeon",
              hoverOffAction: {(self) in
                  if self.isHidden == false {
                      self.room?.childNode(withName:"activeon")?.isHidden = false
                      self.room?.childNode(withName:"activeoff")?.isHidden = true
                  }
              },
              touchAction: {(self) in
                  if self.isHidden == false {
                      sceneManager.switchToMinigame(newState: .intro)
                  }
              }),
    ]
)

