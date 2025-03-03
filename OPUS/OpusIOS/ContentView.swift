//
//  ContentView.swift
//  OpusIOS
//
//  Created by Simone Boscaglia on 24/02/25.
//

import SwiftUI
import SpriteKit

struct ContentView: View {

    var scene: SKScene {
        let scene = SKScene(fileNamed: "GameScene")
        scene?.scaleMode = .aspectFill
        return scene!
    }
    
    
    var body: some View {
        SpriteView(scene: scene)
            .edgesIgnoringSafeArea(.all)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
