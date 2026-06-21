//
//  MediaFeedShowcaseSample.swift
//  TeadsSwiftUISampleApp
//
//  Copyright © 2026 Teads. All rights reserved.
//

import SwiftUI
import TeadsSDK

/// Media + Feed Showcase.
///
/// SwiftUI port of `MediaFeedShowcaseViewController`: drops a Media (video) placement and a Feed
/// (content recommendations) placement into the same article. The Media one uses
/// `TeadsMediaSwiftUIView`; the Feed one uses `TeadsFeedSwiftUIView`.
struct MediaFeedShowcaseSample: View {
    let validationMode: Bool

    private var mediaConfig: TeadsAdPlacementMediaConfig {
        TeadsAdPlacementMediaConfig(
            pid: SamplePID.directLandscape,
            articleUrl: SamplePID.articleURL,
            enableValidationMode: validationMode
        )
    }

    private var feedConfig: TeadsAdPlacementFeedConfig {
        TeadsAdPlacementFeedConfig(
            articleUrl: URL(string: "https://mobile-demo.outbrain.com")!,
            widgetId: "MB_2",
            installationKey: "NANOWDGT01",
            widgetIndex: 0
        )
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                ArticleHeaderImage()

                VStack(alignment: .leading, spacing: 16) {
                    Text("Media + Feed Placement Showcase")
                        .font(.system(size: 24, weight: .bold))

                    Text("This example demonstrates the integration of both Media Placement (video ads) and Feed Placement (content recommendations) following Teads SDK best practices.")
                        .font(.system(size: 16))
                        .foregroundStyle(.secondary)

                    paragraph()

                    sectionHeader("Media Placement (Video Ad)")
                    TeadsMediaSwiftUIView(config: mediaConfig)
                        .frame(minHeight: 200)

                    paragraph()
                    paragraph()

                    sectionHeader("Feed Placement (Content Recommendations)")
                    TeadsFeedSwiftUIView(config: feedConfig)
                        .frame(minHeight: 200)
                }
                .padding(16)
            }
        }
        .background(Color.appBackground)
        .navigationBarTitleDisplayMode(.inline)
        .teadsBrandNavigationBar()
    }

    private func sectionHeader(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 18, weight: .semibold))
    }

    private func paragraph() -> some View {
        Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.")
            .font(.system(size: 16))
    }
}

#Preview {
    NavigationStack {
        MediaFeedShowcaseSample(validationMode: true)
    }
}
