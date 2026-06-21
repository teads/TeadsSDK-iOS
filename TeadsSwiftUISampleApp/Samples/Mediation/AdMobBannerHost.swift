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

/// Hosts a Google `AdManagerBannerView` with the Teads adapter inside SwiftUI, resizing the
/// SwiftUI container as Teads emits `didUpdateRatio` events.
struct AdMobBannerHost: UIViewRepresentable {
    /// AdMob banner format. Most InRead integrations use `.fluid` (matches UIKit ScrollView sample);
    /// the TableView/WebView samples use a medium-rectangle initial size.
    enum Format {
        case fluid
        case mediumRectangle
    }

    let adUnitID: String
    let format: Format

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    func makeUIView(context: Context) -> ResizingContainer {
        let container = ResizingContainer()
        let adSize: AdSize = (format == .fluid) ? AdSizeFluid : AdSizeMediumRectangle
        let banner = AdManagerBannerView(adSize: adSize)
        banner.adUnitID = adUnitID
        banner.delegate = context.coordinator
        banner.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(banner)
        NSLayoutConstraint.activate([
            banner.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            banner.centerYAnchor.constraint(equalTo: container.centerYAnchor),
        ])

        DispatchQueue.main.async {
            banner.rootViewController = banner.window?.rootViewController
        }

        let settings = TeadsAdapterSettings { settings in
            settings.enableDebug()
            settings.registerAdView(banner, delegate: context.coordinator)
        }
        let request = Request()
        request.register(settings)

        context.coordinator.bind(container: container, banner: banner)
        banner.load(request)

        return container
    }

    func updateUIView(_: ResizingContainer, context _: Context) {}

    // MARK: Container

    /// Container view whose intrinsic height tracks the Teads ad ratio so SwiftUI relays it out.
    final class ResizingContainer: UIView {
        private var heightConstraint: NSLayoutConstraint?

        override init(frame: CGRect) {
            super.init(frame: frame)
            translatesAutoresizingMaskIntoConstraints = false
            heightConstraint = heightAnchor.constraint(equalToConstant: 0)
            heightConstraint?.priority = .required
            heightConstraint?.isActive = true
        }

        @available(*, unavailable)
        required init?(coder _: NSCoder) {
            fatalError("init(coder:) is not supported")
        }

        func update(height: CGFloat) {
            heightConstraint?.constant = height
            invalidateIntrinsicContentSize()
        }
    }

    // MARK: Coordinator

    final class Coordinator: NSObject, BannerViewDelegate, TeadsMediatedAdViewDelegate {
        private weak var container: ResizingContainer?
        private weak var banner: AdManagerBannerView?

        func bind(container: ResizingContainer, banner: AdManagerBannerView) {
            self.container = container
            self.banner = banner
        }

        // BannerViewDelegate
        func bannerViewDidReceiveAd(_: BannerView) {}
        func bannerView(_: BannerView, didFailToReceiveAdWithError error: Error) {
            print("AdMob banner failed to load: \(error.localizedDescription)")
            container?.update(height: 0)
        }

        // TeadsMediatedAdViewDelegate
        func didUpdateRatio(_: UIView, adRatio: TeadsAdRatio) {
            guard let container, let banner else { return }
            let width = container.bounds.width
            let height = adRatio.calculateHeight(for: width)
            container.update(height: height)
            banner.resize(adSizeFor(cgSize: CGSize(width: width, height: height)))
        }
    }
}
