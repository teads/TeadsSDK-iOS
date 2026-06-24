//
//  InterstitialDirectSample.swift
//  TeadsSwiftUISampleApp
//
//  Copyright © 2026 Teads. All rights reserved.
//

import SwiftUI
import TeadsSDK

struct InterstitialDirectSample: View {
    @StateObject private var viewModel = InterstitialDirectViewModel()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(ArticleContent.title)
                    .font(.system(size: 24, weight: .bold))

                Text(ArticleContent.previewParagraph)
                    .font(.body)
                    .foregroundStyle(.secondary)

                if viewModel.isContentUnlocked {
                    ForEach(ArticleContent.lockedParagraphs, id: \.self) { paragraph in
                        Text(paragraph)
                            .font(.body)
                            .foregroundStyle(.secondary)
                    }
                } else {
                    VStack(spacing: 12) {
                        Text("Premium Content")
                            .font(.system(size: 18, weight: .bold))
                        Text("Watch an ad to read the rest of the article")
                            .font(.system(size: 14))
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                        if viewModel.isWaitingForAd {
                            ProgressView()
                        } else {
                            Button(action: viewModel.watchAdTapped) {
                                Text("Watch Ad")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundStyle(.white)
                                    .padding(.horizontal, 32)
                                    .padding(.vertical, 12)
                                    .background(Color.blue)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                        }
                    }
                    .padding(24)
                    .frame(maxWidth: .infinity)
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemBackground)))
                }
            }
            .padding(16)
        }
        .background(Color.appBackground)
        .navigationBarTitleDisplayMode(.inline)
        .teadsBrandNavigationBar()
        .onAppear { viewModel.load() }
    }
}

@MainActor
final class InterstitialDirectViewModel: NSObject, ObservableObject, TeadsFullScreenEventsDelegate {
    @Published var isContentUnlocked = false
    @Published var isWaitingForAd = false

    private var placement: TeadsAdPlacementInterstitial?
    private var isReady = false

    func load() {
        let config = TeadsAdPlacementInterstitialConfig(
            articleUrl: SamplePID.interstitialDirectArticleURL,
            widgetId: SamplePID.interstitialDirectWidgetId,
            installationKey: SamplePID.outbrainInstallationKey
        )
        let placement = TeadsAdPlacementInterstitial(config, delegate: self)
        self.placement = placement
        placement.loadAd()
    }

    func watchAdTapped() {
        if isReady {
            present()
        } else {
            isWaitingForAd = true
        }
    }

    private func present() {
        isWaitingForAd = false
        guard let placement, placement.isReady else { return }
        guard let rootVC = UIApplication.shared.firstKeyWindow?.rootViewController else { return }
        placement.show(from: rootVC)
    }

    // TeadsAdPlacementEventsDelegate
    nonisolated func adPlacement(
        _: (any TeadsAdPlacementIdentifiable)?,
        didEmitEvent event: TeadsAdPlacementEventName,
        data: [String: Any]?
    ) {
        Task { @MainActor in
            switch event {
                case .ready:
                    isReady = true
                    if isWaitingForAd { present() }
                case .failed:
                    print("Direct interstitial failed: \(data?["reason"] as? String ?? "unknown")")
                    isWaitingForAd = false
                    isContentUnlocked = true
                default:
                    break
            }
        }
    }

    // TeadsFullScreenEventsDelegate
    nonisolated func fullScreenPlacement(
        _: (any TeadsAdPlacementIdentifiable)?,
        didEmitEvent event: TeadsFullScreenEventName,
        data _: [String: Any]?
    ) {
        Task { @MainActor in
            if event == .dismissed {
                placement?.invalidate()
                placement = nil
                isContentUnlocked = true
            }
        }
    }
}

#Preview {
    NavigationStack {
        InterstitialDirectSample()
    }
}
