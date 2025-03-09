//
//  SceneManager.swift
//  OpusTV
//
//  Created by Simone Boscaglia on 08/03/25.
//

import SpriteKit

enum MinigameState {
    case hidden
    case cauldron
    case insect
}

enum SceneState {
    case sala
    case cucina
    case libreria
    case laboratorio
    case minigame
    case title
}

// Metto qui tutti gli oggetti a cui devono avere accesso altre classi
class SceneManager {
    var scene : SKScene?
    var light : Light?
    let inventory = Inventory(position: .zero)
    
    var sceneState : SceneState = .sala
    var minigame : MinigameState = .hidden
    var stanze : [SceneState : Stanza] = [.sala: sala,.cucina : cucina,.laboratorio : laboratorio,.libreria: libreria, .title: titolo
    ]
    
    init() {}
    
    func assignScene(scene : SKScene) {
        self.scene = scene
        let lightNode = scene.childNode(withName: "torch") as! SKLightNode
        let cursor = scene.childNode(withName: "cursor") as! SKSpriteNode
        light = Light(lightNode: lightNode, cursor: cursor, scene: scene)
    }
    
    func populate() {
        let populator = Populator()
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
