//
//  InterstitialAdmobSample.swift
//  TeadsSwiftUISampleApp
//
//  Copyright © 2026 Teads. All rights reserved.
//

import GoogleMobileAds
import SwiftUI

/// Interstitial • AdMob.
///
/// Mirrors `InterstitialAdmobViewController`: a paywall article preview that loads an AdMob
/// interstitial, presents it on tap, and unlocks the rest of the article on dismiss.
struct InterstitialAdmobSample: View {
    let pid: String

    @StateObject private var viewModel: InterstitialAdmobViewModel

    init(pid: String) {
        self.pid = pid
        _viewModel = StateObject(wrappedValue: InterstitialAdmobViewModel(adUnitID: pid))
    }

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
                    PaywallSection(
                        teaser: ArticleContent.lockedParagraphs.first ?? "",
                        isLoading: viewModel.isWaitingForAd,
                        onWatchTapped: viewModel.watchAdTapped
                    )
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
final class InterstitialAdmobViewModel: NSObject, ObservableObject, FullScreenContentDelegate {
    @Published var isContentUnlocked = false
    @Published var isWaitingForAd = false

    private let adUnitID: String
    private var interstitialAd: InterstitialAd?

    init(adUnitID: String) {
        self.adUnitID = adUnitID
    }

    func load() {
        let request = Request()
        InterstitialAd.load(with: adUnitID, request: request) { [weak self] ad, error in
            Task { @MainActor in
                guard let self else { return }
                if let error {
                    print("Interstitial failed to load: \(error.localizedDescription)")
                    return
                }
                guard let ad else { return }
                ad.fullScreenContentDelegate = self
                self.interstitialAd = ad
                if self.isWaitingForAd { self.present(ad) }
            }
        }
    }

    func watchAdTapped() {
        if let interstitialAd {
            present(interstitialAd)
        } else {
            isWaitingForAd = true
        }
    }

    private func present(_ ad: InterstitialAd) {
        isWaitingForAd = false
        guard let rootVC = UIApplication.shared.firstKeyWindow?.rootViewController else { return }
        ad.present(from: rootVC)
    }

    // FullScreenContentDelegate
    nonisolated func adDidDismissFullScreenContent(_: any FullScreenPresentingAd) {
        Task { @MainActor in
            interstitialAd = nil
            isContentUnlocked = true
        }
    }

    nonisolated func ad(_: any FullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: any Error) {
        print("Interstitial failed to present: \(error.localizedDescription)")
        Task { @MainActor in isContentUnlocked = true }
    }

    nonisolated func adDidRecordImpression(_: any FullScreenPresentingAd) {
        print("Interstitial impression recorded")
    }

    nonisolated func adDidRecordClick(_: any FullScreenPresentingAd) {
        print("Interstitial click recorded")
    }
}

/// The blurred preview + "Watch Ad" card. Pure presentation, owns no logic.
private struct PaywallSection: View {
    let teaser: String
    let isLoading: Bool
    let onWatchTapped: () -> Void

    var body: some View {
        ZStack(alignment: .bottom) {
            Text(teaser)
                .font(.body)
                .foregroundStyle(.secondary)
                .lineLimit(4)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 16)

            LinearGradient(
                colors: [.clear, .black.opacity(0.001), Color.appBackground],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 100)

            VStack(spacing: 12) {
                Text("Premium Content")
                    .font(.system(size: 18, weight: .bold))
                Text("Watch an ad to read the rest of the article")
                    .font(.system(size: 14))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                if isLoading {
                    ProgressView()
                } else {
                    Button(action: onWatchTapped) {
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
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.secondarySystemBackground))
            )
        }
    }
}

#Preview {
    NavigationStack {
        InterstitialAdmobSample(pid: SamplePID.admobInterstitialTest)
    }
}
