//
//  InReadDirectPagedTabViewSample.swift
//  TeadsSwiftUISampleApp
//
//  Copyright © 2026 Teads. All rights reserved.
//

import SwiftUI
import TeadsSDK

/// InRead • Direct • Paged TabView (the SwiftUI idiom for a PageViewController).
///
/// Each page is its own article; the middle page hosts the InRead ad.
struct InReadDirectPagedTabViewSample: View {
    private let config = TeadsAdPlacementMediaConfig(
        pid: SamplePID.inReadDirectLandscape,
        articleUrl: SamplePID.articleURL
    )

    var body: some View {
        TabView {
            page(text: ArticleContent.paragraphs[0], includesAd: false)
            page(text: ArticleContent.paragraphs[1], includesAd: true)
            page(text: ArticleContent.paragraphs[2], includesAd: false)
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
        .indexViewStyle(.page(backgroundDisplayMode: .always))
        .navigationTitle("Direct • PageView")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func page(text: String, includesAd: Bool) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                ArticleHeader()
                ArticleParagraph(text: text)

                if includesAd {
                    TeadsMediaSwiftUIView(config: config)
                }
            }
            .padding()
        }
    }
}

#Preview {
    NavigationStack { InReadDirectPagedTabViewSample() }
}
