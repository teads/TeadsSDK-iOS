//
//  InReadSASTableViewSample.swift
//  TeadsSwiftUISampleApp
//
//  Copyright © 2026 Teads. All rights reserved.
//

import SwiftUI

/// InRead • SAS • TableView.
struct InReadSASTableViewSample: View {
    let formatId: Int

    var body: some View {
        List {
            ArticleHeaderImage()
                .listRowInsets(EdgeInsets())
                .listRowSeparator(.hidden)

            FakeArticleLines(lineCount: 6)
                .padding()
                .listRowSeparator(.hidden)

            SASBannerHost(formatId: formatId)
                .padding(.horizontal, 10)
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                .listRowSeparator(.hidden)

            FakeArticleLines(lineCount: 6)
                .padding()
                .listRowSeparator(.hidden)

            FakeArticleLines(lineCount: 6)
                .padding()
                .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
        .navigationBarTitleDisplayMode(.inline)
        .teadsBrandNavigationBar()
    }
}

#Preview {
    NavigationStack {
        InReadSASTableViewSample(formatId: SamplePID.sasLandscape)
    }
}
