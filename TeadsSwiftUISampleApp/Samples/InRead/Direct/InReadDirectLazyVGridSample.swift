//
//  InReadDirectLazyVGridSample.swift
//  TeadsSwiftUISampleApp
//
//  Copyright © 2026 Teads. All rights reserved.
//

import SwiftUI
import TeadsSDK

/// InRead • Direct • LazyVGrid (the SwiftUI idiom for a CollectionView).
///
/// The ad spans the full grid width while the surrounding article cards flow in two columns.
struct InReadDirectLazyVGridSample: View {
    private let config = TeadsAdPlacementMediaConfig(
        pid: SamplePID.inReadDirectLandscape,
        articleUrl: SamplePID.articleURL
    )

    private let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(0 ..< 4, id: \.self) { index in
                    ArticleCard(text: ArticleContent.paragraphs[index % ArticleContent.paragraphs.count])
                }
            }
            .padding()

            // Full-width ad between two grid sections.
            TeadsMediaSwiftUIView(config: config)
                .padding(.horizontal)

            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(4 ..< 8, id: \.self) { index in
                    ArticleCard(text: ArticleContent.paragraphs[index % ArticleContent.paragraphs.count])
                }
            }
            .padding()
        }
        .navigationTitle("Direct • LazyVGrid")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct ArticleCard: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.footnote)
            .padding()
            .frame(maxWidth: .infinity, minHeight: 120, alignment: .topLeading)
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    NavigationStack { InReadDirectLazyVGridSample() }
}
