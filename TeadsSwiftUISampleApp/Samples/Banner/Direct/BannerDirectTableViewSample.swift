//
//  BannerDirectTableViewSample.swift
//  TeadsSwiftUISampleApp
//
//  Copyright © 2026 Teads. All rights reserved.
//

import SwiftUI
import TeadsSDK

struct BannerDirectTableViewSample: View {
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
        List {
            ArticleHeaderImage()
                .listRowInsets(EdgeInsets())
                .listRowSeparator(.hidden)

            ForEach(0 ..< 5, id: \.self) { _ in
                FakeArticleLines(lineCount: 6)
                    .padding(.vertical, 12)
                    .listRowSeparator(.hidden)
            }

            // Keeps the last content above the anchored banner.
            Color.clear
                .frame(height: bannerDelegate.height + 16)
                .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
        .anchoredBanner {
            TeadsBannerSwiftUIView(config: config, delegate: bannerDelegate)
        }
        .navigationBarTitleDisplayMode(.inline)
        .teadsBrandNavigationBar()
    }
}

#Preview {
    NavigationStack {
        BannerDirectTableViewSample()
    }
}
