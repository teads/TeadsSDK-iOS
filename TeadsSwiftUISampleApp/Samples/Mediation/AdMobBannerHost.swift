//
//  AdMobBannerHost.swift
//  TeadsSwiftUISampleApp
//
//  Copyright © 2026 Teads. All rights reserved.
//

import GoogleMobileAds
import SwiftUI
import TeadsAdMobAdapter
import TeadsSDK

/// Hosts a fluid AdMob `AdManagerBannerView` with the Teads adapter. The creative
/// height is bridged back to SwiftUI state so the layout reflows as it resizes.
struct AdMobBannerHost: View {
    enum Format {
        case mediumRectangle
        case banner
    }

    let adUnitID: String
    let format: Format

    @State private var height: CGFloat = 0

    var body: some View {
        AdMobBannerRepresentable(adUnitID: adUnitID, height: $height)
            .frame(height: height)
    }
}

private struct AdMobBannerRepresentable: UIViewRepresentable {
    let adUnitID: String
    @Binding var height: CGFloat

    func makeCoordinator() -> Coordinator {
        Coordinator(height: $height)
    }

    func makeUIView(context: Context) -> UIView {
        let container = UIView()
        container.clipsToBounds = true

        let banner = AdManagerBannerView(adSize: AdSizeFluid)
        banner.adUnitID = adUnitID
        // Restrict to Fluid so GMA doesn't invoke the mediation adapter once per candidate size.
        banner.validAdSizes = [nsValue(for: AdSizeFluid)]
        banner.rootViewController = UIApplication.shared.firstKeyWindow?.rootViewController
        banner.delegate = context.coordinator
        banner.isAutoloadEnabled = false
        banner.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 150)
        banner.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(banner)
        NSLayoutConstraint.activate([
            banner.topAnchor.constraint(equalTo: container.topAnchor),
            banner.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            banner.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            banner.bottomAnchor.constraint(equalTo: container.bottomAnchor),
        ])
        context.coordinator.banner = banner

        let settings = TeadsAdapterSettings { settings in
            settings.enableDebug()
            settings.registerAdView(banner, delegate: context.coordinator)
        }
        let request = Request()
        request.register(settings)
        banner.load(request)

        return container
    }

    func updateUIView(_: UIView, context _: Context) {}

    final class Coordinator: NSObject, BannerViewDelegate, TeadsMediatedAdViewDelegate {
        @Binding var height: CGFloat
        weak var banner: AdManagerBannerView?
        private var lastHeight: CGFloat = 0

        init(height: Binding<CGFloat>) {
            _height = height
        }

        func bannerViewDidReceiveAd(_: BannerView) {}

        func bannerView(_: BannerView, didFailToReceiveAdWithError error: Error) {
            print("AdMob banner failed to load: \(error.localizedDescription)")
        }

        func didUpdateRatio(_ adView: UIView, adRatio: TeadsAdRatio) {
            let width = adView.frame.width
            let newHeight = adRatio.calculateHeight(for: width)
            banner?.resize(AdSize(size: CGSize(width: width, height: newHeight), flags: 1))
            guard newHeight != lastHeight else { return }
            lastHeight = newHeight
            DispatchQueue.main.async { self.height = newHeight }
        }
    }
}
