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
    let inventory = Inventory()
    var populator : Populator? = nil
    var textManager : TextManager = TextManager(textNode: SKLabelNode())
    
    var sceneState : SceneState = .sala
    var minigameState : MinigameState = .hidden
    
    var stanze : [SceneState : Stanza] = [.sala: sala,.cucina : cucina,.laboratorio : laboratorio,.libreria: libreria, .title: titolo]
    let sceneNames : [MinigameState : String] = [
        .hidden : "GameScene",
        .labirinto : "Labirinto",
        .pozione : "Pozione"
    ]
    var savedScenes : [MinigameState : SKScene?] = [
        .hidden : nil,
        .labirinto : nil,
        .pozione : nil
    ]
    
    var xGyro : CGFloat = 0.0
    var yGyro : CGFloat = 0.0
    var zGyro : CGFloat = 0.0
    
    var heartRate : Double = -1
    
    var isPopupDisplayed : Bool = false
    
    var hasInitializedMainScene : Bool = false
    var removedAntonio : Bool = false
    var hasCollectedWater : Bool = false
    var canMovePainting : Bool = false
    var hasPaintingMoved : Bool = false
    var poisonCollected = false
    var hasOpenedChest = false
    
    
    init() {
        mpcManager.delegate = self
        mpcManager.startService()
    }
    
    func assignScene(scene : SKScene) {
        self.scene = scene
        let lightNode = scene.childNode(withName: "torch") as! SKLightNode
        let cursor = scene.childNode(withName: "cursor") as! SKSpriteNode
        self.light = Light(lightNode: lightNode, cursor: cursor)
        self.populator = Populator(scene: self.scene!)
    }
    
    func initializePopulator() {
        guard self.scene != nil else {print("Trying to initialize populator but scene not assigned"); return}
        self.populator = Populator(scene: self.scene!)
    }
    
    func populate() {
        guard let populator = self.populator else {print("Trying to populate but populator not assigned"); return}
        for (_, stanza) in stanze {
            populator.populate(room: stanza)
            stanza.hide()
        }
    }
    
    func depopulate() {
        guard let populator = self.populator else {print("Trying to depopulate but populator not assigned"); return}
        for (_, stanza) in stanze {
            populator.depopulate(room: stanza)
        }
    }
    
    func getCurrentScene() -> SceneState{
        return sceneState
    }
    
    func selectRoom(_ newScene : SceneState) {
        guard (minigameState == .hidden) else { print("Trying to select room in minigame"); return }
        stanze[sceneState]?.hide()
        stanze[newScene]?.setup()
        stanze[newScene]?.show()
        sceneState = newScene
        
    }
    
    func phoneTouch() {
        self.light?.touch()
    }
    
    func recalibrate() {
        self.light?.move(to:CGPoint.zero)
    }
    
    func switchToMinigame(state : MinigameState) {
        if state == .hidden { // Se sei nel gioco principale
            depopulate()
        }
        if self.savedScenes[self.minigameState] == nil {
            print("saving scene")
            self.savedScenes[self.minigameState] = self.scene
        }
        
        self.minigameState = state

        // faccio prima l'unwrap dal dictionary e poi l'unwrap dell'optional del tipo
        if let value = savedScenes[self.minigameState], let savedScene = value {
            print("accessing saved scene")
            self.scene?.view?.presentScene(savedScene, transition: .crossFade(withDuration: 0.5))
        } else {
            guard let sceneName = sceneNames[state] else {print("Could not find new scene name"); return}
            let newScene = SKScene(fileNamed: sceneName)
            newScene!.size = CGSize(width: 1920, height: 1080)
            newScene?.scaleMode = .aspectFit
            self.scene?.view?.presentScene(newScene!, transition: .crossFade(withDuration: 0.5))
        }

        return;
    }
    
    func handleDisabledTouch() {
        if isPopupDisplayed {
            disablePopup()
        }
    }
    
    func popupImage(imageName: String) {
        guard let scene = self.scene else {print("popupimage could not find scene"); return}
        guard let _ = UIImage(named: imageName) else {print("popupImage could not find imageName: \(imageName)"); return}
        let darkNode = SKSpriteNode(color:.black, size: scene.size)
        darkNode.name = "SceneManager_DarkBackdrop"
        darkNode.alpha = 0.5
        darkNode.zPosition = 100
        let imageNode = SKSpriteNode(imageNamed: imageName)
        imageNode.name = "SceneManager_Popup"
        imageNode.position = CGPoint(x: 0, y: 0)
        imageNode.zPosition = darkNode.zPosition+1
        scaleProportionally(sprite: imageNode, axis: .x, value: scene.frame.width/2)
        scene.addChild(darkNode)
        scene.addChild(imageNode)
        self.light?.disable()
        isPopupDisplayed = true
    }
    
    func disablePopup() {
        guard let scene = self.scene else {print("disablepopup could not find scene"); return}
        DispatchQueue.main.async {
            scene.childNode(withName: "SceneManager_Popup")?.removeAllActions()
            scene.childNode(withName: "SceneManager_Popup")?.removeFromParent()
            scene.childNode(withName: "SceneManager_DarkBackdrop")?.removeAllActions()
            scene.childNode(withName: "SceneManager_DarkBackdrop")?.removeFromParent()
        }
        self.light?.enable()
        isPopupDisplayed = false
    }
}

let sceneManager = SceneManager()
