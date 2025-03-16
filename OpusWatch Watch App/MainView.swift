//
//  MainView.swift
//  OpusWatch Watch App
//
//  Created by Simone Boscaglia on 09/03/25.
//

import SwiftUI

struct MainView: View {
    @ObservedObject private var monitor = HeartRateMonitor()

    var body: some View {
        if monitor.hasAuthorization == true {
            ContentView(monitor: monitor)
        } else {
            AuthorizationView(monitor: monitor)
        }
    }
}
