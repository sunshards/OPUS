//
//  ContentView.swift
//  OpusWatch Watch App
//
//  Created by Simone Boscaglia on 07/02/25.
//

import SwiftUI
import HealthKit
import SpriteKit

struct ContentView: View {
    var store = HKHealthStore()
    @ObservedObject var monitor : HeartRateMonitor = HeartRateMonitor()
    @State private var animationAmount = 1.0
    let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate)!
    let wcManager = WCManager.shared
    
    var body: some View {
            VStack {
                Image(systemName: "heart.fill")
                    .font(.system(size: 25))
                    .foregroundStyle(.tint)
                    .scaleEffect(animationAmount)
                    .animation(
                        .easeInOut(duration: 1.5)
                        .repeatForever(autoreverses: true),
                        value: animationAmount
                    )
                Text("Your heart rate:")
                    .padding()
                    .fontWeight(.bold)
                Button("text") {
                    print("sending")
                    self.wcManager.send(message: WatchMessage(heartRate: 75.0))
                }
                if monitor.heartRate != nil {
                    Text("\(monitor.heartRate ?? -1) BPM")
                        .font(.system(size: animationAmount*10))
                        .animation(.default)
                } else {
                    Text("Not detected.")
                        .font(.system(size: animationAmount*10))
                }
            }
            .padding()
            .onAppear() {           
                animationAmount = 1.5
                monitor.startWorkout()
            }
        }
        
    }
