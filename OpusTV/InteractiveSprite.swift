//
//  Interactable.swift
//  OpusTV
//
//  Created by Simone Boscaglia on 05/03/25.
//

import Foundation
import SpriteKit

class InteractiveSprite: SKSpriteNode, SKPhysicsContactDelegate {
    private var spawnAction : ((InteractiveSprite) -> Void)?
    private var touchAction: ((InteractiveSprite) -> Void)?
    private var hoverOnAction: ((InteractiveSprite) -> Void)?
    private var hoverOffAction: ((InteractiveSprite) -> Void)?
    var hasTouched : Bool = false
    var isActive = true
    var isAssigned : Bool = false
    var text : String?
    
    var room : SKNode? {
        return self.parent
    }
    static let defaultSpriteNode = SKSpriteNode(color: .clear, size: CGSize(width: 1, height: 1))
    
    /// Dato uno sprite a schermo, creane la versione interagibile (devi rimuovere lo sprite sottostante)
    /// Se non viene dato uno sprite ne viene assegnato uno blank di default, poi bisogna assegnarlo
    
    /// Ogni sprite ha una:
    /// - hoverOnAction: quando si passa sopra con la torcia,
    /// - hoverOffAction: quando si toglie la torcia,
    /// - touchAction: quando si ha la torcia sopra e si preme.
    
    /// SE AGGIORNI INIT RICORDATI DI AGGIORNARE DUPLICATE CHE VIENE CHIAMATA QUANDO VIENE INIZIALIZZATA LA SCENA
    init(name: String,
         text : String? = nil,
         sprite spriteNode: SKSpriteNode? = nil ,
         spawnAction : ((InteractiveSprite) -> Void)? = nil,
         hoverOnAction: ((InteractiveSprite) -> Void)? = nil,
         hoverOffAction: ((InteractiveSprite) -> Void)? = nil,
         touchAction: ((InteractiveSprite) -> Void)? = nil,
         active: Bool? = true) {
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
        self.spawnAction = spawnAction
        self.touchAction = touchAction
        self.hoverOnAction = hoverOnAction
        self.hoverOffAction = hoverOffAction
        self.name = name
        self.isActive = active!
    }
    
    func duplicateWithoutSprite() -> InteractiveSprite {
        let duplicate = InteractiveSprite(name: self.name!,
                                          text: self.text,
                                          sprite: nil,
                                          spawnAction: self.spawnAction,
                                          hoverOnAction: self.hoverOnAction,
                                          hoverOffAction: self.hoverOffAction,
                                          touchAction: self.touchAction,
                                          active: self.isActive)
        return duplicate
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
        self.touchAction?(self)
        self.hasTouched = true
    }
    func spawn() {
        self.spawnAction?(self)
    }
    func despawn() {
        self.removeAllActions()
    }
    
    func hide() {
        self.isActive = false
        self.isHidden = true
    }
    func show() {
        self.isActive = true
        self.isHidden = false
    }
    
    func playSound(soundName : String) {
        if self.isActive {
            self.room?.run(SKAction.playSoundFileNamed(soundName, waitForCompletion: true))
            print("playing sound \(soundName)")
        }
    }
    
    func generatePhysicsBody(size: CGSize) -> SKPhysicsBody {
        let physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody.affectedByGravity = false
        physicsBody.allowsRotation = false
        physicsBody.categoryBitMask = 2
        physicsBody.collisionBitMask = 0
        physicsBody.contactTestBitMask = 0
        physicsBody.fieldBitMask = 0
        physicsBody.mass = 1
        return physicsBody
    }
    
    func delete() {
        DispatchQueue.main.async {
            self.removeAllActions()
            self.removeFromParent()
        }
    }
    
    func assignSprite(sprite : SKSpriteNode) {
        self.size = sprite.size
        self.lightingBitMask = sprite.lightingBitMask
        self.position = sprite.position
        self.zPosition = sprite.zPosition
        
        if let body = sprite.physicsBody {self.physicsBody = body.copy() as? SKPhysicsBody}
        else {self.physicsBody = generatePhysicsBody(size: self.size)}
        
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
        self.isAssigned = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
