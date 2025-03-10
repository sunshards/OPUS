//
//  MainView.swift
//  HeartLogger
//
//  Created by Andrea Iannaccone on 09/03/25.
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
