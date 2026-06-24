//
//  BannerDirectTableViewSample.swift
//  TeadsSwiftUISampleApp
//
//  Copyright © 2026 Teads. All rights reserved.
//

import SwiftUI
import TeadsSDK

struct BannerDirectTableViewSample: View {
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

            FakeArticleLines(lineCount: 6)
                .padding(.vertical, 12)
                .listRowSeparator(.hidden)

            TeadsBannerSwiftUIView(config: config)
                .listRowInsets(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                .listRowSeparator(.hidden)

            FakeArticleLines(lineCount: 6)
                .padding(.vertical, 12)
                .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
        .navigationBarTitleDisplayMode(.inline)
        .teadsBrandNavigationBar()
    }
}

#Preview {
    NavigationStack {
        BannerDirectTableViewSample()
    }
}
