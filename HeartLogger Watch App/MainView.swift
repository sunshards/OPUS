//
//  MainView.swift
//  HeartLogger
//
//  Created by Andrea Iannaccone on 09/03/25.
//

import SwiftUI

struct MainView: View {
    @StateObject private var monitor = HeartRateMonitor()

    var body: some View {
        if monitor.checkAuthorizationStatus() == .sharingAuthorized {
            ContentView(monitor: monitor)
        } else {
            NotContentView(monitor: monitor)
        }
    }
}
