//
//  HeartLoggerApp.swift
//  HeartLogger Watch App
//
//  Created by Simone Boscaglia on 07/02/25.
//

import SwiftUI
import HealthKit

@main
struct HeartLogger_Watch_App: App {
    @ObservedObject private var monitor = HeartRateMonitor()
    var body: some Scene {
        WindowGroup {
            MainView()
            }
        }
    }
