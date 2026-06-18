//
//  InReadDirectListSample.swift
//  TeadsSwiftUISampleApp
//
//  Copyright © 2026 Teads. All rights reserved.
//

import SwiftUI
import TeadsSDK

/// InRead • Direct • List.
///
/// Inserts the ad as its own `List` row. The SDK resizes the view as the ad ratio updates, so the
/// row height follows automatically.
struct InReadDirectListSample: View {
    private let config = TeadsAdPlacementMediaConfig(
        pid: SamplePID.inReadDirectLandscape,
        articleUrl: SamplePID.articleURL
    )

    var body: some View {
        List {
            ArticleHeader()
                .listRowSeparator(.hidden)

            ArticleParagraph(text: ArticleContent.paragraphs[0])

            TeadsMediaSwiftUIView(config: config)
                .listRowInsets(EdgeInsets())
                .listRowSeparator(.hidden)

            ForEach(ArticleContent.paragraphs.indices.dropFirst(), id: \.self) { index in
                ArticleParagraph(text: ArticleContent.paragraphs[index])
            }
        }
        .listStyle(.plain)
        .navigationTitle("Direct • List")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack { InReadDirectListSample() }
}
