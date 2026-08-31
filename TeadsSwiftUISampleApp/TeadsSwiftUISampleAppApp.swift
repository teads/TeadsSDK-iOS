//
//  TeadsSwiftUISampleAppApp.swift
//  TeadsSwiftUISampleApp
//
//  Copyright © 2026 Teads. All rights reserved.
//

import SwiftUI
import TeadsSDK
import TeadsAdMobAdapter

@main
struct TeadsSwiftUISampleAppApp: App {
    init() {
        // Partner key is required for Feed and Recommendations placements.
        TeadsAdMobMediation.register()
        Teads.configure(with: "iOSSampleApp2014")
        Teads.testMode = true
    }

    var body: some Scene {
        WindowGroup {
            RootCatalogView()
        }
    }
}
