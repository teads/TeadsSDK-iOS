//
//  RecommendationsDirectTableViewSample.swift
//  TeadsSwiftUISampleApp
//
//  Copyright © 2026 Teads. All rights reserved.
//

import SwiftUI
import TeadsSDK

struct RecommendationsDirectTableViewSample: View {
    private var config: any TeadsAdPlacementRecommendationsConfig {
        TeadsAdPlacementRecommendationsURLConfig(
            articleUrl: SamplePID.outbrainArticleURL,
            widgetId: SamplePID.recommendationsWidgetId
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

            TeadsRecommendationsView(config: config)
                .listRowInsets(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
        .navigationBarTitleDisplayMode(.inline)
        .teadsBrandNavigationBar()
    }
}

#Preview {
    NavigationStack {
        RecommendationsDirectTableViewSample()
    }
}
