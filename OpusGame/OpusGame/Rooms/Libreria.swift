//
//  Libreria.swift
//  OpusTV
//
//  Created by Simone Boscaglia on 06/03/25.
//

import Foundation
import SpriteKit

let libreria = Stanza(state: .libreria,
    action: {(self) in},                    
                    
   sounds : [
  ],
  
  interactives: [
    
    InteractiveSprite(name: "libporta", touchAction: {(self) in
        audio.playSoundEffect(named: "ChiaveApertura")
        sceneManager.selectRoom(.sala)
    }),
    
    InteractiveSprite(name: "libsedia",
                      touchAction: {(self) in
                          audio.playSoundEffect(named: "Sedia2")
                      }),
    InteractiveSprite(name: "libquadro",
                      spawnAction: {(self) in
                          if sceneManager.hasPaintingMoved {
                              self.position = CGPoint(x: 220, y: 115)
                          }
                      },
                      touchAction: {(self) in
                          if   !sceneManager.hasPaintingMoved && sceneManager.canMovePainting && sceneManager.hasCollectedWater{
                              self.run(SKAction.move(to: CGPoint(x: 220, y: 115), duration: 5))
                              self.playSound(soundName: "PassaggioSegreto")
                              sceneManager.hasPaintingMoved = true
                          }
                      }),
    InteractiveSprite(name: "libscale",
                      touchAction: {(self) in
                          sceneManager.selectRoom(.laboratorio)
                      }),
    
    InteractiveSprite(name: "libteca",
                      touchAction: {(self) in
                          if !sceneManager.hasCollectedKey && sceneManager.monsterPhase > 0 {
                              let message = Message(type: .confirm, vector: nil, state: nil)
                              sceneManager.mpcManager.send(message: message)
                              sceneManager.pause()
                          } else {
                              self.playSound(soundName: "")
                          }
                      }),
    
    InteractiveSprite(name: "liblibro1", touchAction: {(self) in
        sceneManager.popupImage(imageName: "libro1")
    }),
    InteractiveSprite(name: "liblibro2", touchAction: {(self) in
        sceneManager.popupImage(imageName: "libro2")
    }),
    InteractiveSprite(name: "liblibro3", touchAction: {(self) in
        sceneManager.popupImage(imageName: "libro3")
        sceneManager.canMovePainting = true
    }),
    
])
