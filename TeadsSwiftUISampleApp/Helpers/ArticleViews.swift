//
//  ArticleViews.swift
//  TeadsSwiftUISampleApp
//
//  Copyright © 2026 Teads. All rights reserved.
//

import SwiftUI

/// The article header (title + lead paragraph) reused across the InRead samples.
struct ArticleHeader: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(ArticleContent.title)
                .font(.largeTitle.bold())
            Text(ArticleContent.lead)
                .font(.body)
                .foregroundStyle(.secondary)
        }
    }
}

/// A single article paragraph.
struct ArticleParagraph: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.body)
    }
}
