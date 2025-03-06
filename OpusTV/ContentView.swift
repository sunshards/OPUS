//
//  ContentView.swift
//  OpusTV
//
//  Created by Simone Boscaglia on 24/02/25.
//

import SwiftUI
import SpriteKit

struct ContentView: View {
    var scene: SKScene {
        let scene = SKScene(fileNamed: "GameScene")
        scene!.size = CGSize(width: 1920, height: 1080)
        scene?.scaleMode = .aspectFit
        return scene!
    }
    
    var body: some View {
        ZStack(alignment: .bottomLeading) { // Align to the bottom leading corner
            SpriteView(scene: scene)
                .edgesIgnoringSafeArea(.all)
                .onAppear {
                    UIApplication.shared.isIdleTimerDisabled = true
                }
            
            // Inventory View at the bottom left
            InventoryView()
                .padding() // Add some padding to the inventory view
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
