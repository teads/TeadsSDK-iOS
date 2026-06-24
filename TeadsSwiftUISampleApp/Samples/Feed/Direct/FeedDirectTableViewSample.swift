//
//  FeedDirectTableViewSample.swift
//  TeadsSwiftUISampleApp
//
//  Copyright © 2026 Teads. All rights reserved.
//

import SwiftUI
import TeadsSDK

struct FeedDirectTableViewSample: View {
    private var config: TeadsAdPlacementFeedConfig {
        TeadsAdPlacementFeedConfig(
            articleUrl: SamplePID.outbrainArticleURL,
            widgetId: SamplePID.feedWidgetId,
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

            TeadsFeedSwiftUIView(config: config)
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
        FeedDirectTableViewSample()
    }
}
