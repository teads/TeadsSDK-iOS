//
//  InReadDirectPagedTabViewSample.swift
//  TeadsSwiftUISampleApp
//
//  Copyright © 2026 Teads. All rights reserved.
//

import SwiftUI
import TeadsSDK

struct InReadDirectPageViewSample: View {
    let selection: SampleSelection
    let validationMode: Bool

    private static let pageCount = 20

    private var config: TeadsAdPlacementMediaConfig {
        TeadsAdPlacementMediaConfig(
            pid: selection.integerPID,
            articleUrl: SamplePID.articleURL,
            enableValidationMode: validationMode
        )
    }

    var body: some View {
        TabView {
            ForEach(0 ..< Self.pageCount, id: \.self) { index in
                page(index: index)
                    .tag(index)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
        .indexViewStyle(.page(backgroundDisplayMode: .always))
        .background(Color.appBackground)
        .navigationBarTitleDisplayMode(.inline)
        .teadsBrandNavigationBar()
    }

    @ViewBuilder
    private func page(index: Int) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("ARTICLE \(index + 1) of \(Self.pageCount)")
                    .font(.system(size: 20, weight: .bold))
                    .padding(.horizontal)
                    .padding(.top, 12)

                ArticleHeaderImage()

                if index == 0 {
                    TeadsMediaSwiftUIView(config: config)
                        .padding(.horizontal)
                }

                FakeArticleLines(lineCount: 8)
                    .padding(.horizontal)
                    .padding(.bottom, 20)
            }
        }
    }
}

#Preview {
    NavigationStack {
        InReadDirectPageViewSample(selection: SampleSelection(), validationMode: true)
    }
}
