//
//  SceneManager.swift
//  OpusTV
//
//  Created by Simone Boscaglia on 08/03/25.
//

import SpriteKit
import SwiftUI

// Metto qui tutti gli oggetti a cui devono avere accesso altre classi
class SceneManager {
    @ObservedObject var mpcManager: MPCManager = MPCManager.shared

    var scene : SKScene?
    var light : Light?
    let inventory = Inventory(position: .zero)
    var populator : Populator? = nil
    
    var sceneState : SceneState = .sala
    var minigame : MinigameState = .hidden
    var stanze : [SceneState : Stanza] = [.sala: sala,.cucina : cucina,.laboratorio : laboratorio,.libreria: libreria, .title: titolo]
    
    var xGyro : CGFloat = 0.0
    var yGyro : CGFloat = 0.0
    var zGyro : CGFloat = 0.0
    
    init() {
        mpcManager.delegate = self
        mpcManager.startService()
    }
    
    func assignScene(scene : SKScene) {
        self.scene = scene
        let lightNode = scene.childNode(withName: "torch") as! SKLightNode
        let cursor = scene.childNode(withName: "cursor") as! SKSpriteNode
        light = Light(lightNode: lightNode, cursor: cursor)
    }
    
    func initializePopulator() {
        guard self.scene != nil else {print("Trying to initialize populator but scene not assigned"); return}
        self.populator = Populator(scene: self.scene!)
    }
    
    func populate() {
        guard let populator = self.populator else {print("Trying to populate but populator not assigned"); return}
        for (_, stanza) in stanze {
            populator.populate(interactables: stanza.interactives, room: stanza)
            stanza.node?.position = CGPoint.zero
            stanza.hide()
        }
    }
    
    func selectRoom(_ newScene : SceneState) {
        stanze[sceneState]?.hide()
        stanze[newScene]?.setup()
        stanze[newScene]?.show()
        sceneState = newScene
    }
    
    func phoneTouch() {
        light?.touch()
        
    }
    
    func recalibrate() {
        light?.move(to:CGPoint.zero)
    }
    
}

let sceneManager = SceneManager()
