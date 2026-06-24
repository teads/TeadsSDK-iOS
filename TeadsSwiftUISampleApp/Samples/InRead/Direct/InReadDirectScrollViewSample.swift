//
//  InReadDirectScrollViewSample.swift
//  TeadsSwiftUISampleApp
//
//  Copyright © 2026 Teads. All rights reserved.
//

import SwiftUI
import TeadsSDK

struct InReadDirectScrollViewSample: View {
    let selection: SampleSelection

    private var config: TeadsAdPlacementMediaConfig {
        TeadsAdPlacementMediaConfig(
            pid: selection.integerPID,
            articleUrl: SamplePID.articleURL
        )
    }

    var body: some View {
        ScrollView {
            FakeArticle {
                TeadsMediaSwiftUIView(config: config)
                    .padding(.horizontal)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .teadsBrandNavigationBar()
    }
}

#Preview {
    NavigationStack {
        InReadDirectScrollViewSample(selection: SampleSelection())
    }
}
