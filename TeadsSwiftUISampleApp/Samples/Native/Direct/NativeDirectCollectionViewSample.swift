//
//  NativeDirectCollectionViewSample.swift
//  TeadsSwiftUISampleApp
//
//  Copyright © 2026 Teads. All rights reserved.
//

import SwiftUI

/// Native • Direct • CollectionView.
///
/// 8 article cards in a single-column lazy stack with a Teads native ad inserted at index 3
/// (matches the UIKit `NativeDirectCollectionViewController`'s `adItemNumber = 3`).
struct NativeDirectCollectionViewSample: View {
    let pid: Int
    let validationMode: Bool

    private static let articleCount = 8
    private static let adIndex = 3

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 8) {
                ForEach(0 ..< Self.articleCount, id: \.self) { index in
                    if index == 0 {
                        ArticleHeaderImage()
                    } else if index == Self.adIndex {
                        TeadsNativeAdHost(pid: pid, validationMode: validationMode)
                            .frame(height: 250)
                            .padding(.horizontal, 8)
                    } else {
                        FakeNativeArticleRow()
                    }
                }
            }
        }
        .background(Color.appBackground)
        .navigationBarTitleDisplayMode(.inline)
        .teadsBrandNavigationBar()
    }
}

#Preview {
    NavigationStack {
        NativeDirectCollectionViewSample(pid: SamplePID.directNativeDisplay, validationMode: true)
    }
}
