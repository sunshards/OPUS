//
//  ContentView.swift
//  OpusIOS
//
//  Created by Simone Boscaglia on 24/02/25.
//

import SwiftUI
import SpriteKit
import HealthKit

struct ContentView: View {
//    @ObservedObject private var monitor = HeartRateReader()
//    let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate)

    var scene: SKScene {
        let scene = SKScene(fileNamed: "GameScene")
        scene?.scaleMode = .aspectFill
        return scene!
    }
    
    var body: some View {
//        Text("\(monitor.heartRate ?? 0.0)")
        SpriteView(scene: scene)
            .edgesIgnoringSafeArea(.all)
            .onAppear(){
//                monitor.requestAuthorization()
//                monitor.startHeartRateQuery(heartRateType: heartRateType!)
            }
        }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
