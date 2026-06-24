//
//  InReadDirectListSample.swift
//  TeadsSwiftUISampleApp
//
//  Copyright © 2026 Teads. All rights reserved.
//

import SwiftUI
import TeadsSDK

struct InReadDirectTableViewSample: View {
    let selection: SampleSelection

    private static let articleCount = 8
    private static let adInterval = 3

    private var config: TeadsAdPlacementMediaConfig {
        TeadsAdPlacementMediaConfig(
            pid: selection.integerPID,
            articleUrl: SamplePID.articleURL
        )
    }

    var body: some View {
        List {
            ArticleHeaderImage()
                .listRowInsets(EdgeInsets())
                .listRowSeparator(.hidden)

            ForEach(0 ..< Self.articleCount, id: \.self) { index in
                Group {
                    FakeArticleRow()
                    if index > 0, index % Self.adInterval == 0 {
                        TeadsMediaSwiftUIView(config: config)
                            .listRowInsets(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                            .listRowSeparator(.hidden)
                    }
                }
            }
        }
        .listStyle(.plain)
        .navigationBarTitleDisplayMode(.inline)
        .teadsBrandNavigationBar()
    }
}

private struct FakeArticleRow: View {
    var body: some View {
        FakeArticleLines(lineCount: 5)
            .padding(.vertical, 12)
            .padding(.horizontal, 8)
            .listRowSeparator(.hidden)
    }
}

#Preview {
    NavigationStack {
        InReadDirectTableViewSample(selection: SampleSelection())
    }
}
