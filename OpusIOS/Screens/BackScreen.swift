//
//  BackScreen.swift
//  OpusIOS
//
//  Created by Simone Boscaglia on 16/03/2025.
//

import SpriteKit
import CoreMotion

class BackScreen: SKScene {
    
    let phoneManager = PhoneManager.shared
    let mpcManager = MPCManager.shared
        
    override func didMove(to view: SKView) {
        phoneManager.currentScene = self
        ScreenUtilities.setBodiesTransparency(scene: scene!)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchLocation = touches.first!.location(in: self)
        let node = self.atPoint(touchLocation)
        if (node.name == "body") {
            ScreenUtilities.activateButton(body: node)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let body = ScreenUtilities.anchoredBody {
            body.position = touches.first!.location(in: self)
        }
    }
    
    // Le attività dei bottoni vanno effettutate quando viene rilasciato il tocco
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchLocation = touches.first!.location(in: self)
        let node = self.atPoint(touchLocation)
        
        if (node.name == "body") {
            guard let buttonName = ScreenUtilities.anchoredBody?.parent?.name else { return }
            
            if buttonName == "BackButton" {
                
                // CODE GOES HERE
                
                scene?.view?.presentScene(ScreenUtilities.getScreen(name: "MainScreen"))
            }
            
            ScreenUtilities.deactivateButton(body: node)
        }
    }
    
}

