//
//  InReadDirectLazyVGridSample.swift
//  TeadsSwiftUISampleApp
//
//  Copyright © 2026 Teads. All rights reserved.
//

import SwiftUI
import TeadsSDK

struct InReadDirectCollectionViewSample: View {
    let selection: SampleSelection

    private static let articleCount = 8
    private static let adIndex = 3

    private var config: TeadsAdPlacementMediaConfig {
        TeadsAdPlacementMediaConfig(
            pid: selection.integerPID,
            articleUrl: SamplePID.articleURL
        )
    }

    private let columns = [
        GridItem(.flexible(), spacing: 8),
        GridItem(.flexible(), spacing: 8),
    ]

    var body: some View {
        ScrollView {
            ArticleHeaderImage()

            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(0 ..< Self.articleCount, id: \.self) { index in
                    if index == Self.adIndex {
                        Color.clear.frame(height: 0)
                        TeadsMediaSwiftUIView(config: config)
                            .padding(.horizontal, 10)
                            .gridCellColumns(2)
                    }
                    ArticleCard()
                }
            }
            .padding(.horizontal, 8)
        }
        .background(Color.appBackground)
        .navigationBarTitleDisplayMode(.inline)
        .teadsBrandNavigationBar()
    }
}

private struct ArticleCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.fakeArticle)
                .aspectRatio(16 / 9, contentMode: .fit)
            FakeArticleLines(lineCount: 3)
        }
        .padding(8)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay(
            RoundedRectangle(cornerRadius: 8).stroke(Color.cellBorder, lineWidth: 0.5)
        )
    }
}

#Preview {
    NavigationStack {
        InReadDirectCollectionViewSample(selection: SampleSelection())
    }
}
