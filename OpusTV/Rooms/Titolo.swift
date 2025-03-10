//
//  title.swift
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
        let playoff = self.node?.childNode(withName:"playoff") as? SKSpriteNode
        let playon = self.node?.childNode(withName:"playon") as? SKSpriteNode
        let creditsoff = self.node?.childNode(withName:"creditsoff") as? SKSpriteNode
        let creditson = self.node?.childNode(withName:"creditson") as? SKSpriteNode
        playon?.lightingBitMask = 0
        creditson?.lightingBitMask = 0
        playoff?.isHidden = false
        playon?.isHidden = true
        creditsoff?.isHidden = false
        creditson?.isHidden = true
    },
    
    sounds : [
    ],
    
    interactives: [
        InteractiveSprite(name: "playoff",
              hoverOnAction: {(self) in
//                  let labirinto = SKScene(fileNamed: "Labirinto")
//                  labirinto!.size = CGSize(width: 1920, height: 1080)
//                  labirinto?.scaleMode = .aspectFit
//                  self.scene?.view?.presentScene(labirinto!,
//                                                 transition: .crossFade(withDuration: 0.5))
//                  return;
                  self.room?.childNode(withName:"playon")?.isHidden = false
                  self.room?.childNode(withName:"playoff")?.isHidden = true
              }),
        InteractiveSprite(name: "playon",
              hoverOffAction: {(self) in
                  self.room?.childNode(withName:"playoff")?.isHidden = false
                  self.room?.childNode(withName:"playon")?.isHidden = true
              },
              touchAction: {(self) in
                  sceneManager.selectRoom(.sala)
          }),
        InteractiveSprite(name: "creditsoff",
              hoverOnAction: {(self) in
                  self.room?.childNode(withName:"creditson")?.isHidden = false
                  self.room?.childNode(withName:"creditsoff")?.isHidden = true
              }),
        InteractiveSprite(name: "creditson",
              hoverOffAction: {(self) in
                  self.room?.childNode(withName:"creditsoff")?.isHidden = false
                  self.room?.childNode(withName:"creditson")?.isHidden = true
              },
              touchAction: {(self) in
                  //sceneManager.selectRoom(.sala)
          }),
    ]
)

