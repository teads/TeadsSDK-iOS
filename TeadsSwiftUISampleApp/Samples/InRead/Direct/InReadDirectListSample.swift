//
//  InReadDirectListSample.swift
//  TeadsSwiftUISampleApp
//
//  Copyright © 2026 Teads. All rights reserved.
//

import SwiftUI
import TeadsSDK

/// InRead • Direct • List (the SwiftUI idiom for the UIKit TableView integration).
///
/// 8 article rows with Teads ads inserted every 3rd article row, matching the UIKit sample's
/// `InReadDirectTableViewController` behavior. Each ad is a separate placement that auto-resizes.
struct InReadDirectTableViewSample: View {
    let selection: SampleSelection
    let validationMode: Bool

    private static let articleCount = 8
    private static let adInterval = 3 // matches `incrementPosition` in UIKit

    private var config: TeadsAdPlacementMediaConfig {
        TeadsAdPlacementMediaConfig(
            pid: selection.integerPID,
            articleUrl: SamplePID.articleURL,
            enableValidationMode: validationMode
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

/// A skeleton row resembling the UIKit `fakeArticleCell`.
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
        InReadDirectTableViewSample(selection: SampleSelection(), validationMode: true)
    }
}
