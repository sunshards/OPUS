//
//  Interactable.swift
//  OpusIOS
//
//  Created by Simone Boscaglia on 05/03/25.
//

import Foundation
import SpriteKit

class InteractiveSprite: SKSpriteNode, SKPhysicsContactDelegate {
    private var touchAction: ((InteractiveSprite) -> Void)?
    private var hoverOnAction: ((InteractiveSprite) -> Void)?
    private var hoverOffAction: ((InteractiveSprite) -> Void)?
    var hasTouched : Bool = false
    var isActive = false
    var text : String?
    
    var room : SKNode? {
        return self.parent
    }
    static let defaultSpriteNode = SKSpriteNode(color: .clear, size: CGSize(width: 1, height: 1))
    
    // Dato uno sprite a schermo, creane la versione interagibile (devi rimuovere lo sprite sottostante)
    // Se non viene dato uno sprite ne viene assegnato uno blank di default, poi bisogna assegnarlo
    
    // Ogni sprite ha una:
    // - hoverOnAction: quando si passa sopra con la torcia,
    // - hoverOffAction: quando si toglie la torcia,
    // - touchAction: quando si ha la torcia sopra e si preme.
    init(name: String,
         text : String? = nil,
         sprite spriteNode: SKSpriteNode? = nil ,
         hoverOnAction: ((InteractiveSprite) -> Void)? = nil,
         hoverOffAction: ((InteractiveSprite) -> Void)? = nil,
         touchAction: ((InteractiveSprite) -> Void)? = nil,
         active: Bool? = false){
        self.text = text
        // Se lo sprite è assegnato allora viene subito fatta l'assegnazione,
        // altrimenti viene fatto l'init con lo sprite di default
        var sprite = spriteNode
        if sprite == nil {
            sprite = InteractiveSprite.defaultSpriteNode
            super.init(texture:sprite!.texture, color:sprite!.color, size:sprite!.size)
        } else {
            super.init(texture:sprite!.texture, color:sprite!.color, size:sprite!.size)
            assignSprite(sprite: sprite!)
        }
        self.touchAction = touchAction
        self.hoverOnAction = hoverOnAction
        self.hoverOffAction = hoverOffAction
        self.name = name
        self.isActive = active!
    }
    
    // we pass self to the action so that the action can control the sprite's properties
    func hoverOn() {
        if self.isActive {
            self.hoverOnAction?(self)
        }
    }
    func hoverOff() {
        if self.isActive{
            self.hoverOffAction?(self)
        }
    }
    func run() {
        if self.isActive{
            self.touchAction?(self)
            self.hasTouched = true
        }
    }
    
    func playSound(soundName : String) {
        if self.isActive {
            self.parent?.run(SKAction.playSoundFileNamed(soundName, waitForCompletion: true))
        }
    }
    
    func assignSprite(sprite : SKSpriteNode) {
        self.size = sprite.size
        self.lightingBitMask = sprite.lightingBitMask
        self.position = sprite.position
        self.zPosition = sprite.zPosition
        self.physicsBody = sprite.physicsBody?.copy() as? SKPhysicsBody
        self.lightingBitMask = sprite.lightingBitMask
        self.isPaused = false
        // Controlla se la texture è presente negli asset, altrimenti lo sprite è solo un placeholder
        if let name = self.name, let _ = UIImage(named: name) {
            let newTexture = SKTexture(imageNamed: self.name ?? "")
            self.texture = newTexture
            self.color = sprite.color
            self.alpha = 1
        } else { // Lo sprite è un placeholder
            self.color = .clear
            self.alpha = 0
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    
    
}
