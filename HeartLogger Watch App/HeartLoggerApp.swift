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
    var body: some Scene {
        var store = HKHealthStore()
        WindowGroup {
            if store.authorizationStatus(for: store) != .sharingAuthorized {
                NotContentView()
            }
            else{
                ContentView()
            }
        }
    }
}
