//
//  FeedDirectScrollViewSample.swift
//  TeadsSwiftUISampleApp
//
//  Copyright © 2026 Teads. All rights reserved.
//

import SwiftUI
import TeadsSDK

struct FeedDirectScrollViewSample: View {
    private var config: TeadsAdPlacementFeedConfig {
        TeadsAdPlacementFeedConfig(
            articleUrl: SamplePID.outbrainArticleURL,
            widgetId: SamplePID.feedWidgetId,
            installationKey: SamplePID.outbrainInstallationKey,
            widgetIndex: 0
        )
    }

    var body: some View {
        ScrollView {
            FakeArticle {
                TeadsFeedSwiftUIView(config: config)
                    .frame(maxWidth: .infinity)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .teadsBrandNavigationBar()
    }
}

#Preview {
    NavigationStack {
        FeedDirectScrollViewSample()
    }
}
