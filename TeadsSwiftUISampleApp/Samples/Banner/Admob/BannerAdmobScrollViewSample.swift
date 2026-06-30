//
//  BannerAdmobScrollViewSample.swift
//  TeadsSwiftUISampleApp
//
//  Copyright © 2026 Teads. All rights reserved.
//

import SwiftUI

struct BannerAdmobScrollViewSample: View {
    let adUnitID: String

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ArticleHeaderImage()
                FakeArticleLines(lineCount: 10).padding(.horizontal)
                FakeArticleLines(lineCount: 10).padding(.horizontal)
                FakeArticleLines(lineCount: 10).padding(.horizontal)
                FakeArticleLines(lineCount: 10).padding(.horizontal)
                // Keeps the last content above the anchored banner.
                Color.clear.frame(height: AnchoredAdMobBanner.size.height + 16)
            }
            .padding(.bottom)
        }
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
        BannerAdmobScrollViewSample(adUnitID: SamplePID.admobBanner)
    }
}
