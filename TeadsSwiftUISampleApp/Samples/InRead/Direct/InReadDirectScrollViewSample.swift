//
//  InReadDirectScrollViewSample.swift
//  TeadsSwiftUISampleApp
//
//  Copyright © 2026 Teads. All rights reserved.
//

import SwiftUI
import TeadsSDK

/// InRead • Direct • ScrollView.
///
/// Drops the official `TeadsMediaSwiftUIView` (alias for
/// `TeadsAdPlacementSwiftUIView<TeadsAdPlacementMedia>`) straight into the article flow.
struct InReadDirectScrollViewSample: View {
    private let config = TeadsAdPlacementMediaConfig(
        pid: SamplePID.inReadDirectLandscape,
        articleUrl: SamplePID.articleURL
    )

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                ArticleHeader()

                ArticleParagraph(text: ArticleContent.paragraphs[0])

                TeadsMediaSwiftUIView(config: config)

                ForEach(ArticleContent.paragraphs.indices.dropFirst(), id: \.self) { index in
                    ArticleParagraph(text: ArticleContent.paragraphs[index])
                }
            }
            .padding()
        }
        .navigationTitle("Direct • ScrollView")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack { InReadDirectScrollViewSample() }
}
