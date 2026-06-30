//
//  AppLovinBannerHost.swift
//  TeadsSwiftUISampleApp
//
//  Copyright © 2026 Teads. All rights reserved.
//

import AppLovinSDK
import SwiftUI
import TeadsAppLovinAdapter
import TeadsSDK

/// Hosts an AppLovin `MAAdView` driven by the Teads adapter.
struct AppLovinBannerHost: UIViewRepresentable {
    let adUnitID: String
    let isMREC: Bool

    func makeCoordinator() -> Coordinator { Coordinator() }

    func makeUIView(context: Context) -> ResizingContainer {
        let container = ResizingContainer()

        let format: MAAdFormat = isMREC ? .mrec : .banner
        let banner = MAAdView(adUnitIdentifier: adUnitID, adFormat: format)
        banner.translatesAutoresizingMaskIntoConstraints = false
        banner.backgroundColor = .clear
        banner.delegate = context.coordinator
        container.addSubview(banner)
        NSLayoutConstraint.activate([
            banner.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            banner.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            banner.topAnchor.constraint(equalTo: container.topAnchor),
            banner.bottomAnchor.constraint(equalTo: container.bottomAnchor),
        ])

        let settings = TeadsAdapterSettings { settings in
            settings.enableDebug()
            settings.pageUrl("https://teads.com")
            settings.registerAdView(banner, delegate: context.coordinator)
        }
        banner.register(teadsAdSettings: settings)

        context.coordinator.bind(container: container)
        banner.loadAd()
        return container
    }

    func updateUIView(_: ResizingContainer, context _: Context) {}

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

    final class Coordinator: NSObject, MAAdViewAdDelegate, TeadsMediatedAdViewDelegate {
        private weak var container: ResizingContainer?

        func bind(container: ResizingContainer) { self.container = container }

        // MAAdViewAdDelegate
        func didLoad(_: MAAd) {}
        func didFailToLoadAd(forAdUnitIdentifier _: String, withError error: MAError) {
            print("AppLovin failed to load: \(error.message)")
            container?.update(height: 0)
        }

        func didDisplay(_: MAAd) {}
        func didHide(_: MAAd) {}
        func didClick(_: MAAd) {}
        func didExpand(_: MAAd) {}
        func didCollapse(_: MAAd) {}
        func didFail(toDisplay _: MAAd, withError _: MAError) {}

        // TeadsMediatedAdViewDelegate
        func didUpdateRatio(_: UIView, adRatio: TeadsAdRatio) {
            guard let container else { return }
            container.update(height: adRatio.calculateHeight(for: container.bounds.width))
        }
    }
}
