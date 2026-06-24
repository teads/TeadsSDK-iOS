//
//  BannerDirectScrollViewSample.swift
//  TeadsSwiftUISampleApp
//
//  Copyright © 2026 Teads. All rights reserved.
//

import SwiftUI
import TeadsSDK

struct BannerDirectScrollViewSample: View {
    private var config: TeadsAdPlacementBannerConfig {
        TeadsAdPlacementBannerConfig(
            articleUrl: SamplePID.outbrainArticleURL,
            widgetId: SamplePID.bannerWidgetId,
            installationKey: SamplePID.outbrainInstallationKey,
            widgetIndex: 0
        )
    }

    var body: some View {
        ScrollView {
            FakeArticle {
                TeadsBannerSwiftUIView(config: config)
                    .padding(.horizontal)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .teadsBrandNavigationBar()
    }
}

#Preview {
    NavigationStack {
        BannerDirectScrollViewSample()
    }
}
