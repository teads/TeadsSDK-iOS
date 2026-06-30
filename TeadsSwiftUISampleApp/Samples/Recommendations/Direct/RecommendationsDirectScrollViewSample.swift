//
//  RecommendationsDirectScrollViewSample.swift
//  TeadsSwiftUISampleApp
//
//  Copyright © 2026 Teads. All rights reserved.
//

import SwiftUI
import TeadsSDK

struct RecommendationsDirectScrollViewSample: View {
    private var config: any TeadsAdPlacementRecommendationsConfig {
        TeadsAdPlacementRecommendationsURLConfig(
            articleUrl: SamplePID.outbrainArticleURL,
            widgetId: SamplePID.recommendationsWidgetId
        )
    }

    var body: some View {
        ScrollView {
            FakeArticle {
                TeadsRecommendationsView(config: config)
                    .padding(.horizontal)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .teadsBrandNavigationBar()
    }
}

#Preview {
    NavigationStack {
        RecommendationsDirectScrollViewSample()
    }
}
