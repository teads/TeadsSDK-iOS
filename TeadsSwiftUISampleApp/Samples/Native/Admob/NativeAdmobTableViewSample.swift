//
//  NativeAdmobTableViewSample.swift
//  TeadsSwiftUISampleApp
//
//  Copyright © 2026 Teads. All rights reserved.
//

import GoogleMobileAds
import SwiftUI
import TeadsAdMobAdapter
import TeadsSDK

/// Native • AdMob • TableView.
///
/// Loads a Google AdMob native ad via the Teads adapter and renders it through a programmatic
/// `NativeAdView`. Mirrors `NativeAdmobTableViewController` (8 rows, ad inserted at row 3).
struct NativeAdmobTableViewSample: View {
    let pid: String

    @State private var loadedAd: NativeAd?
    @State private var loaderHolder = AdLoaderHolder()

    private static let articleCount = 8
    private static let adIndex = 3

    var body: some View {
        List {
            ArticleHeaderImage()
                .listRowInsets(EdgeInsets())
                .listRowSeparator(.hidden)

            ForEach(0 ..< Self.articleCount, id: \.self) { index in
                Group {
                    if index == Self.adIndex, let ad = loadedAd {
                        AdMobNativeAdHost(ad: ad)
                            .frame(height: 350)
                            .padding(.horizontal, 10)
                    } else {
                        FakeNativeArticleRow()
                    }
                }
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets())
            }
        }
        .listStyle(.plain)
        .navigationBarTitleDisplayMode(.inline)
        .teadsBrandNavigationBar()
        .onAppear { loaderHolder.load(adUnitID: pid) { ad in loadedAd = ad } }
    }
}

/// Retains the `AdLoader` for the lifetime of the sample.
@MainActor
private final class AdLoaderHolder: NSObject, AdLoaderDelegate, NativeAdLoaderDelegate {
    private var loader: AdLoader?
    private var onAd: ((NativeAd) -> Void)?

    func load(adUnitID: String, completion: @escaping (NativeAd) -> Void) {
        onAd = completion
        let rootVC = UIApplication.shared.firstKeyWindow?.rootViewController
        let loader = AdLoader(
            adUnitID: adUnitID,
            rootViewController: rootVC,
            adTypes: [.native],
            options: nil
        )
        loader.delegate = self

        let settings = TeadsAdapterSettings { settings in
            settings.enableDebug()
            settings.pageUrl("http://teads.tv")
        }
        let request = Request()
        request.register(settings)
        loader.load(request)
        self.loader = loader
    }

    nonisolated func adLoader(_: AdLoader, didFailToReceiveAdWithError error: Error) {
        print("AdMob native didFailToReceive: \(error.localizedDescription)")
    }

    nonisolated func adLoader(_: AdLoader, didReceive nativeAd: NativeAd) {
        Task { @MainActor in onAd?(nativeAd) }
    }
}

extension UIApplication {
    /// Returns the first key window across all connected scenes (used to look up the root
    /// view controller for interstitial presentation and AdMob loader's `rootViewController`).
    var firstKeyWindow: UIWindow? {
        connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap(\.windows)
            .first { $0.isKeyWindow }
    }
}

/// Programmatic `NativeAdView` that exposes its subviews so the AdMob SDK can bind them.
private struct AdMobNativeAdHost: UIViewRepresentable {
    let ad: NativeAd

    func makeUIView(context _: Context) -> NativeAdView {
        let adView = NativeAdView()
        adView.backgroundColor = .systemBackground
        adView.layer.cornerRadius = 8
        adView.layer.borderColor = UIColor.systemGray4.cgColor
        adView.layer.borderWidth = 0.5

        let mediaView = MediaView()
        mediaView.translatesAutoresizingMaskIntoConstraints = false
        adView.mediaView = mediaView
        adView.addSubview(mediaView)

        let headline = UILabel()
        headline.numberOfLines = 0
        headline.font = .systemFont(ofSize: 16, weight: .bold)
        headline.translatesAutoresizingMaskIntoConstraints = false
        adView.headlineView = headline
        adView.addSubview(headline)

        let cta = UIButton(type: .system)
        cta.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        cta.backgroundColor = UIColor.systemBlue
        cta.setTitleColor(.white, for: .normal)
        cta.layer.cornerRadius = 6
        cta.translatesAutoresizingMaskIntoConstraints = false
        adView.callToActionView = cta
        cta.isUserInteractionEnabled = false // CTA is handled by NativeAdView
        adView.addSubview(cta)

        NSLayoutConstraint.activate([
            mediaView.topAnchor.constraint(equalTo: adView.topAnchor, constant: 8),
            mediaView.leadingAnchor.constraint(equalTo: adView.leadingAnchor, constant: 8),
            mediaView.trailingAnchor.constraint(equalTo: adView.trailingAnchor, constant: -8),
            mediaView.heightAnchor.constraint(equalToConstant: 200),

            headline.topAnchor.constraint(equalTo: mediaView.bottomAnchor, constant: 8),
            headline.leadingAnchor.constraint(equalTo: adView.leadingAnchor, constant: 8),
            headline.trailingAnchor.constraint(equalTo: adView.trailingAnchor, constant: -8),

            cta.topAnchor.constraint(equalTo: headline.bottomAnchor, constant: 8),
            cta.trailingAnchor.constraint(equalTo: adView.trailingAnchor, constant: -8),
            cta.bottomAnchor.constraint(lessThanOrEqualTo: adView.bottomAnchor, constant: -8),
            cta.heightAnchor.constraint(equalToConstant: 36),
            cta.widthAnchor.constraint(greaterThanOrEqualToConstant: 100),
        ])

        adView.nativeAd = ad
        headline.text = ad.headline
        if let title = ad.callToAction { cta.setTitle(title, for: .normal) }
        mediaView.mediaContent = ad.mediaContent
        return adView
    }

    func updateUIView(_: NativeAdView, context _: Context) {}
}

#Preview {
    NavigationStack {
        NativeAdmobTableViewSample(pid: SamplePID.admobNativeDisplay)
    }
}
