//
//  InReadAppLovinScrollViewSample.swift
//  TeadsSwiftUISampleApp
//
//  Copyright © 2026 Teads. All rights reserved.
//

import SwiftUI

/// InRead • AppLovin • ScrollView.
///
/// Loads an AppLovin `MAAdView` (banner or MREC) and routes the creative through the Teads adapter.
/// Matches the UIKit `InReadAppLovinScrollViewController`, including the simulator-warning alert.
struct InReadAppLovinScrollViewSample: View {
    let adUnitId: String
    let isMREC: Bool

    @State private var showSimulatorWarning = false

    var body: some View {
        ScrollView {
            FakeArticle {
                AppLovinBannerHost(adUnitID: adUnitId, isMREC: isMREC)
                    .padding(.horizontal)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .teadsBrandNavigationBar()
        .onAppear {
            #if targetEnvironment(simulator)
            showSimulatorWarning = true
            #endif
        }
        .alert("Warning", isPresented: $showSimulatorWarning) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Teads AppLovin adapter does not work on simulator.")
        }
    }
}

#Preview {
    NavigationStack {
        InReadAppLovinScrollViewSample(adUnitId: SamplePID.appLovinLandscape, isMREC: false)
    }
}
