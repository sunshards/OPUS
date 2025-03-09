//
//  ContentView.swift
//  HeartLogger Watch App
//
//  Created by Simone Boscaglia on 07/02/25.
//

import SwiftUI
import HealthKit
import SpriteKit


struct NotContentView: View{
    @ObservedObject private var monitor = HeartRateMonitor()
    if status != .sharingAuthorized {
        VStack {
            Button(action: {
                monitor.requestAuthorization()
            }) {
                Label {
                    Text("Allow access to heart rate")
                } icon: {
                    Rectangle().cornerRadius(10).frame(width: 20, height: 20)
                }
            }
        }
    }
}

struct ContentView: View {
    
    @ObservedObject private var monitor = HeartRateMonitor()
    @State private var animationAmount = 1.0
    guard let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate) else {
        print("Heart Rate Type is unavailable.")
//            completion(false)
        return
    }
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
#Preview {
    ContentView()
}
