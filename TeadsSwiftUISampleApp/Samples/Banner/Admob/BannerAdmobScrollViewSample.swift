//
//  BannerAdmobScrollViewSample.swift
//  TeadsSwiftUISampleApp
//
//  Copyright © 2026 Teads. All rights reserved.
//

import SwiftUI

struct BannerAdmobScrollViewSample: View {
    let adUnitID: String

    var body: some View {
        ScrollView {
            FakeArticle {
                AdMobBannerHost(adUnitID: adUnitID, format: .banner)
                    .padding(.horizontal)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .teadsBrandNavigationBar()
    }
}

#Preview {
    NavigationStack {
        BannerAdmobScrollViewSample(adUnitID: SamplePID.admobBanner)
    }
}
