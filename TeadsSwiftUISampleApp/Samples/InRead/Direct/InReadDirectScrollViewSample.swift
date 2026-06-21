//
//  InReadDirectScrollViewSample.swift
//  TeadsSwiftUISampleApp
//
//  Copyright © 2026 Teads. All rights reserved.
//

import SwiftUI
import TeadsSDK

/// InRead • Direct • ScrollView.
///
/// Drops the official `TeadsMediaSwiftUIView` (alias for
/// `TeadsAdPlacementSwiftUIView<TeadsAdPlacementMedia>`) straight into the article flow.
struct InReadDirectScrollViewSample: View {
    let selection: SampleSelection
    let validationMode: Bool

    private var config: TeadsAdPlacementMediaConfig {
        TeadsAdPlacementMediaConfig(
            pid: selection.integerPID,
            articleUrl: SamplePID.articleURL,
            enableValidationMode: validationMode
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
        InReadDirectScrollViewSample(selection: SampleSelection(), validationMode: true)
    }
}
