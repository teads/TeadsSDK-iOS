//
//  TeadsSwiftUISampleAppApp.swift
//  TeadsSwiftUISampleApp
//
//  Copyright © 2026 Teads. All rights reserved.
//

import SwiftUI
import TeadsSDK

@main
struct TeadsSwiftUISampleAppApp: App {
    init() {
        Teads.configure()
        Teads.testMode = true
    }

    var body: some Scene {
        WindowGroup {
            RootCatalogView()
        }
    }
}
