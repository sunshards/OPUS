//
//  SceneManager.swift
//  OpusTV
//
//  Created by Simone Boscaglia on 08/03/25.
//

import SpriteKit
import SwiftUI


// TODO:
// L'intero sistema degli interactive sprite e del populator è troppo instabile ed è da eliminare
// Meglio fare la gestione su scene come sul telefono

// Metto qui tutti gli oggetti a cui devono avere accesso altre classi
class SceneManager {
    @ObservedObject var mpcManager: MPCManager = MPCManager.shared

    //MARK: Contenuti scena
    var scene : SKScene?
    var light : Light?
    let inventory = Inventory()
    var populator : Populator? = nil
    var textManager : TextManager = TextManager(textNode: SKLabelNode())

    var heartRate : Double = -1
    

    var winItems : [String] = ["acqua", "veleno", "bocciasangue", "fiore"]
    var addedItems : [String] = []
    
    var sceneState : SceneState = .sala
    var minigameState : MinigameState = .hidden
    
    var mostro : Mostro = Mostro()
    
    var stanze : [SceneState : Stanza] = [.sala: sala,.cucina : cucina,.laboratorio : laboratorio,.libreria: libreria, .title: titolo]
    let sceneNames : [MinigameState : String] = [
        .hidden : "GameScene",
        .labirinto : "Labirinto",
        .pozione : "Pozione",
        .intro: "FirstCutscene",
        .victory : "Vittoria"
     ]
    var savedScenes : [MinigameState : SKScene?] = [
        .hidden : nil,
        .labirinto : nil,
        .pozione : nil
    ]
    
    //MARK: Giroscopio
    var xGyro : CGFloat = 0.0
    var yGyro : CGFloat = 0.0
    var zGyro : CGFloat = 0.0
    
    

    
    
    //MARK: flags
    var hasCollectedBecker = false
    var hasCollectedFlower = false
    var isPopupDisplayed = false
    var hasCollectedKey = false
    var hasShownMenu = false
    var hasStartedGame = false
    var removedAntonio = false
    var hasCollectedWater = false
    var canMovePainting = false
    var hasPaintingMoved = false
    var poisonCollected = false
    var hasOpenedChest = false
    var iphoneConnected = false
    var watchConnected = false
    
    
    init() {
        mpcManager.delegate = self
        mpcManager.startService()
    }
    
    func assignScene(scene : SKScene) {
        self.scene = scene
        let lightNode = scene.childNode(withName: "torch") as? SKLightNode
        let cursor = scene.childNode(withName: "cursor") as? SKSpriteNode
        if let lightNode, let cursor {
            self.light = Light(lightNode: lightNode, cursor: cursor)
        }
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
    
    func switchToMinigame(newState : MinigameState) {
        if minigameState == .hidden { // Se sei nel gioco principale
            depopulate()
        }
//        if self.savedScenes[self.minigameState] == nil {
//            print("saving scene")
//            self.savedScenes[self.minigameState] = self.scene
//        }
        
        self.minigameState = newState

///        faccio prima l'unwrap dal dictionary e poi l'unwrap dell'optional del tipo
//        if let value = savedScenes[self.minigameState], let savedScene = value {
//           print("accessing saved scene")
//            self.scene?.view?.presentScene(savedScene, transition: .crossFade(withDuration: 0.5))
//        } else {
            guard let sceneName = sceneNames[newState] else {print("Could not find new scene name"); return}
            let newScene = SKScene(fileNamed: sceneName)
            newScene!.size = CGSize(width: 1920, height: 1080)
            newScene?.scaleMode = .aspectFit
            self.scene?.view?.presentScene(newScene!, transition: .crossFade(withDuration: 0.5))
//        }
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
    
    func updateTitleIcons() {
        guard minigameState == .hidden else {return}
        
        let iphoneNode =  scene?.childNode(withName: "//IphoneIcon")
        let watchNode =  scene?.childNode(withName: "//WatchIcon")
        let playButton =  scene?.childNode(withName: "//PlayButton")
        let disactivePlay = scene?.childNode(withName: "//disactive")
        let activePlayOff = scene?.childNode(withName: "//activeoff")
        let activePlayOn = scene?.childNode(withName: "//activeon")

        if iphoneConnected == true {
            iphoneNode?.childNode(withName: "on")?.isHidden = false
            iphoneNode?.childNode(withName: "off")?.isHidden = true
        } else {
            iphoneNode?.childNode(withName: "on")?.isHidden = true
            iphoneNode?.childNode(withName: "off")?.isHidden = false
        }
        if watchConnected == true {
            watchNode?.childNode(withName: "on")?.isHidden = false
            watchNode?.childNode(withName: "off")?.isHidden = true
        } else {
            watchNode?.childNode(withName: "on")?.isHidden = true
            watchNode?.childNode(withName: "off")?.isHidden = false
        }
//        if iphoneConnected && watchConnected {
//            disactivePlay?.isHidden = true
//            activePlayOff?.isHidden = false
//        }
//        } else {
//            disactivePlay?.isHidden = false
//            activePlayOff?.isHidden = true
//        }
    }
    
    func addToCauldron(item: String) {
        self.addedItems.append(item)
        if checkVictory() == true {
            endGame()
        }
    }
    
    func checkVictory() -> Bool {
        return  Set(winItems).isSubset(of: addedItems)
    }
    
    func endGame() {
        switchToMinigame(newState: .victory)
    }
    
}

let sceneManager = SceneManager()
