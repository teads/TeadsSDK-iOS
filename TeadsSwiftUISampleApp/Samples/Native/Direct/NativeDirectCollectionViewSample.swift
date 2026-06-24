//
//  NativeDirectCollectionViewSample.swift
//  TeadsSwiftUISampleApp
//
//  Copyright © 2026 Teads. All rights reserved.
//

import SwiftUI

struct NativeDirectCollectionViewSample: View {
    let pid: Int

    private static let articleCount = 8
    private static let adIndex = 3

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 8) {
                ForEach(0 ..< Self.articleCount, id: \.self) { index in
                    if index == 0 {
                        ArticleHeaderImage()
                    } else if index == Self.adIndex {
                        TeadsNativeAdHost(pid: pid)
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
        NativeDirectCollectionViewSample(pid: SamplePID.directNativeDisplay)
    }
}
