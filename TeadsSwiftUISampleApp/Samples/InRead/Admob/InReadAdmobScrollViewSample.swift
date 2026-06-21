//
//  InReadAdmobScrollViewSample.swift
//  TeadsSwiftUISampleApp
//
//  Copyright © 2026 Teads. All rights reserved.
//

import AppTrackingTransparency
import GoogleMobileAds
import SwiftUI
import TeadsAdMobAdapter
import TeadsSDK

struct InReadAdmobScrollViewSample: View {
    let pid: String

    var body: some View {
        ScrollView {
            FakeArticle {
                AdMobBannerHost(adUnitID: pid, format: .fluid)
                    .padding(.horizontal)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .teadsBrandNavigationBar()
        .task { await Self.requestTrackingPermissionIfNeeded() }
    }

    private static func requestTrackingPermissionIfNeeded() async {
        guard ATTrackingManager.trackingAuthorizationStatus == .notDetermined else { return }
        _ = await ATTrackingManager.requestTrackingAuthorization()
    }
}

#Preview {
    NavigationStack {
        InReadAdmobScrollViewSample(pid: SamplePID.admobLandscape)
    }
}
