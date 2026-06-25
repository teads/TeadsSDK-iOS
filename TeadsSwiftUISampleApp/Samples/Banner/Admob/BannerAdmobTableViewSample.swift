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

            ForEach(0 ..< 5, id: \.self) { _ in
                FakeArticleLines(lineCount: 6)
                    .padding(.vertical, 12)
                    .listRowSeparator(.hidden)
            }

            // Keeps the last content above the anchored banner.
            Color.clear
                .frame(height: AnchoredAdMobBanner.size.height + 16)
                .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
        .anchoredBanner {
            AnchoredAdMobBanner(adUnitID: adUnitID)
                .frame(width: AnchoredAdMobBanner.size.width, height: AnchoredAdMobBanner.size.height)
        }
        .navigationBarTitleDisplayMode(.inline)
        .teadsBrandNavigationBar()
    }
}

#Preview {
    NavigationStack {
        BannerAdmobTableViewSample(adUnitID: SamplePID.admobBanner)
    }
}
