//
//  AnchoredBanner.swift
//  TeadsSwiftUISampleApp
//
//  Copyright © 2026 Teads. All rights reserved.
//

import GoogleMobileAds
import SwiftUI
import TeadsSDK

/// Tracks the Direct banner's reported height for the content's bottom spacer.
final class BannerHeightDelegate: NSObject, ObservableObject, TeadsAdPlacementEventsDelegate {
    @Published var height: CGFloat = 0

    func adPlacement(_: TeadsAdPlacementIdentifiable?, didEmitEvent event: TeadsAdPlacementEventName, data: [String: Any]?) {
        guard event == .heightUpdated, let height = data?["height"] as? CGFloat else { return }
        self.height = height
    }
}

/// Fixed 320×50 AdMob banner for the anchored slot. Mediation is resolved
/// server-side from the ad unit, so no per-request adapter settings are needed.
struct AnchoredAdMobBanner: UIViewRepresentable {
    static let size = AdSizeBanner.size

    let adUnitID: String

    func makeUIView(context _: Context) -> BannerView {
        let banner = BannerView(adSize: AdSizeBanner)
        banner.adUnitID = adUnitID
        banner.rootViewController = UIApplication.shared.firstKeyWindow?.rootViewController
        banner.isAutoloadEnabled = false
        banner.load(Request())
        return banner
    }

    func updateUIView(_: BannerView, context _: Context) {}
}

extension View {
    /// Pins `banner` to the bottom of the screen as a sticky overlay over the
    /// receiver (the scrollable article), bleeding into the bottom safe area.
    func anchoredBanner(@ViewBuilder _ banner: () -> some View) -> some View {
        ZStack(alignment: .bottom) {
            self
            banner()
                .background(Color(.systemBackground))
                .shadow(color: .black.opacity(0.12), radius: 8, x: 0, y: -2)
        }
        .ignoresSafeArea(edges: .bottom)
    }
}
