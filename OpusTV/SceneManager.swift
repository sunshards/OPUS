//
//  SceneManager.swift
//  OpusTV
//
//  Created by Simone Boscaglia on 08/03/25.
//

import SpriteKit

// Metto qui tutti gli oggetti a cui devono avere accesso altre classi
class SceneManager {
    var scene : SKScene?
    var light : Light?
    let inventory = Inventory(position: .zero)
    var populator : Populator? = nil
    
    var sceneState : SceneState = .sala
    var minigame : MinigameState = .hidden
    var stanze : [SceneState : Stanza] = [.sala: sala,.cucina : cucina,.laboratorio : laboratorio,.libreria: libreria, .title: titolo]
    
    
    func assignScene(scene : SKScene) {
        self.scene = scene
        let lightNode = scene.childNode(withName: "torch") as! SKLightNode
        let cursor = scene.childNode(withName: "cursor") as! SKSpriteNode
        light = Light(lightNode: lightNode, cursor: cursor, scene: scene)
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
}

let sceneManager = SceneManager()
