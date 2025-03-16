//
//  AuthorizationView.swift
//  OpusWatch Watch App
//
//  Created by Andrea Iannaccone on 10/03/25.
//
import SwiftUI

struct AuthorizationView: View {
    @ObservedObject var monitor : HeartRateMonitor
    var body: some View{
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
