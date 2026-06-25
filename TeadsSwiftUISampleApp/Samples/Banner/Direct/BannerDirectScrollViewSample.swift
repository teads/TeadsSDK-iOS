//
//  BannerDirectScrollViewSample.swift
//  TeadsSwiftUISampleApp
//
//  Copyright © 2026 Teads. All rights reserved.
//

import SwiftUI
import TeadsSDK

struct BannerDirectScrollViewSample: View {
    @StateObject private var bannerDelegate = BannerHeightDelegate()

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
            VStack(spacing: 20) {
                ArticleHeaderImage()
                FakeArticleLines(lineCount: 10).padding(.horizontal)
                FakeArticleLines(lineCount: 10).padding(.horizontal)
                FakeArticleLines(lineCount: 10).padding(.horizontal)
                FakeArticleLines(lineCount: 10).padding(.horizontal)
                // Keeps the last content above the anchored banner.
                Color.clear.frame(height: bannerDelegate.height + 16)
            }
            .padding(.bottom)
        }
        .anchoredBanner {
            TeadsBannerSwiftUIView(config: config, delegate: bannerDelegate)
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
