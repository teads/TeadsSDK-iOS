//
//  ArticleViews.swift
//  TeadsSwiftUISampleApp
//
//  Copyright © 2026 Teads. All rights reserved.
//

import SwiftUI

/// Gradient article header.
struct ArticleHeaderImage: View {
    var height: CGFloat = 200

    var body: some View {
        Image("coffeeDesk")
            .resizable()
            .scaledToFill()
            .frame(height: height)
            .overlay(LinearGradient.teadsBrand.opacity(0.65))
            .clipped()
    }
}

/// Skeleton article lines.
struct FakeArticleLines: View {
    var lineCount = 6

    var body: some View {
        VStack(spacing: 10) {
            ForEach(0 ..< lineCount, id: \.self) { _ in
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color.fakeArticle)
                    .frame(height: 10)
            }
        }
    }
}

/// Fake article scaffold with an ad slot in the middle.
struct FakeArticle<AdSlot: View>: View {
    var topLines = 6
    var bottomLines = 12
    @ViewBuilder var adSlot: () -> AdSlot

    var body: some View {
        VStack(spacing: 20) {
            ArticleHeaderImage()
            FakeArticleLines(lineCount: topLines)
                .padding(.horizontal)
            adSlot()
            FakeArticleLines(lineCount: bottomLines)
                .padding(.horizontal)
        }
        .padding(.bottom)
    }
}
