//
//  BannerAdmobTableViewSample.swift
//  TeadsSwiftUISampleApp
//
//  Copyright © 2026 Teads. All rights reserved.
//

import SwiftUI

struct BannerAdmobTableViewSample: View {
    let adUnitID: String

    var body: some View {
        List {
            ArticleHeaderImage()
                .listRowInsets(EdgeInsets())
                .listRowSeparator(.hidden)

            FakeArticleLines(lineCount: 6)
                .padding(.vertical, 12)
                .listRowSeparator(.hidden)

            AdMobBannerHost(adUnitID: adUnitID, format: .banner)
                .listRowInsets(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                .listRowSeparator(.hidden)

            FakeArticleLines(lineCount: 6)
                .padding(.vertical, 12)
                .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
        .navigationBarTitleDisplayMode(.inline)
        .teadsBrandNavigationBar()
    }
}

#Preview {
    NavigationStack {
        BannerAdmobTableViewSample(adUnitID: SamplePID.admobBanner)
    }
}
