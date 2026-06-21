//
//  ArticleViews.swift
//  TeadsSwiftUISampleApp
//
//  Copyright © 2026 Teads. All rights reserved.
//

import SwiftUI

/// The gradient article header image, mirroring the UIKit sample's `TeadsGradientImageView`
/// (the `coffeeDesk` photo overlaid with the Teads purple-to-blue gradient).
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

/// Gray skeleton "fake article" lines, mirroring the UIKit sample's `FakeArticleView`.
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

/// A fake article page: gradient header, skeleton text, an ad slot, then more skeleton text.
///
/// Reproduces the layout of the UIKit InRead article screens, with the ad injected in the middle.
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
