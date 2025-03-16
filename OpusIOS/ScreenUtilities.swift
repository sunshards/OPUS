//
//  ScreenUtilities.swift
//  OpusIOS
//
//  Created by Simone Boscaglia on 16/03/25.
//

import SpriteKit

// classe statica di metodi che vengono utilizzati da tutti gli screen
class ScreenUtilities {
    // il body viene trascinato quando viene tenuto premuto, in modo che la touches ended
    // venga sempre chiamata anche quando il dito lascerebbe tenendo premuto lo sprite del body
    static var anchoredBody : SKNode? = nil
    static var anchoredBodyPosition : CGPoint? = nil
    static var isBodyAnchored : Bool = false
    
    // the class should not be initialized
    private init() {}
    
    static func setBodiesTransparency(scene: SKScene) {
        scene.enumerateChildNodes(withName: "//body", using: {node, pointer in
            guard let sprite = node as? SKSpriteNode else { return }
            // deve avere alpha 1 altrimenti spritekit non legge il tocco del body
            sprite.alpha = 1
            sprite.color = .clear
        })
    }
    
    static func anchorBody(body : SKNode) {
        ScreenUtilities.anchoredBody = body
        ScreenUtilities.anchoredBodyPosition = body.position
        isBodyAnchored = true
    }
    
    static func deanchorBody() {
        ScreenUtilities.anchoredBody = nil
        ScreenUtilities.anchoredBodyPosition = nil
        isBodyAnchored = false
    }
    
    static func activateButton(body : SKNode) {
        guard let button = body.parent else {print("no button"); return}
        guard let onSprite = button.childNode(withName: "on") else {print("no on sprite"); return}
        guard let offSprite = button.childNode(withName: "off") else {print("no off sprite"); return}
        offSprite.isHidden = true
        onSprite.isHidden = false
        ScreenUtilities.anchorBody(body: body)
    }
    
    static func deactivateButton(body: SKNode) {
        guard let button = body.parent else {print("no button"); return}
        guard let onSprite = button.childNode(withName: "on") else {print("no on sprite"); return}
        guard let offSprite = button.childNode(withName: "off") else {print("no off sprite"); return}
        if let anchoredBody, let anchoredBodyPosition {
            anchoredBody.position = anchoredBodyPosition
        }
        offSprite.isHidden = false
        onSprite.isHidden = true
        ScreenUtilities.deanchorBody()
    }
    
    static func getScreen(name: String) -> SKScene {
        let scene = SKScene(fileNamed: name)
        scene?.scaleMode = .aspectFill
        return scene!
    }
    
}
