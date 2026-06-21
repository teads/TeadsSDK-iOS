//
//  SASBannerHost.swift
//  TeadsSwiftUISampleApp
//
//  Copyright © 2026 Teads. All rights reserved.
//

import SASDisplayKit
import SwiftUI
import TeadsSASAdapter
import TeadsSDK

/// Hosts a Smart AdServer `SASBannerView` driven by the Teads adapter inside SwiftUI.
struct SASBannerHost: UIViewRepresentable {
    let formatId: Int

    func makeCoordinator() -> Coordinator { Coordinator() }

    func makeUIView(context: Context) -> ResizingContainer {
        let container = ResizingContainer()
        let banner = SASBannerView(
            frame: .init(x: 0, y: 0, width: 320, height: 200),
            loader: .activityIndicatorStyleWhite
        )
        DispatchQueue.main.async { [weak banner, weak container] in
            banner?.modalParentViewController = container?.window?.rootViewController
        }
        banner.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(banner)
        NSLayoutConstraint.activate([
            banner.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            banner.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            banner.topAnchor.constraint(equalTo: container.topAnchor),
            banner.bottomAnchor.constraint(equalTo: container.bottomAnchor),
        ])

        let settings = TeadsAdapterSettings { settings in
            settings.enableDebug()
            settings.pageUrl("https://teads.tv")
            settings.registerAdView(banner, delegate: context.coordinator)
        }

        var keywordTargeting = "yourkw=something"
        keywordTargeting = TeadsSASAdapterHelper.concatAdSettingsToKeywords(
            keywordsStrings: keywordTargeting,
            adSettings: settings
        )
        let placement = SASAdPlacement(
            siteId: SamplePID.sasSiteId,
            pageId: SamplePID.sasPageId,
            formatId: formatId,
            keywordTargeting: keywordTargeting
        )

        context.coordinator.bind(container: container)
        banner.load(with: placement)
        return container
    }

    func updateUIView(_: ResizingContainer, context _: Context) {}

    final class ResizingContainer: UIView {
        private var heightConstraint: NSLayoutConstraint?

        override init(frame: CGRect) {
            super.init(frame: frame)
            translatesAutoresizingMaskIntoConstraints = false
            heightConstraint = heightAnchor.constraint(equalToConstant: 250)
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

    final class Coordinator: NSObject, TeadsMediatedAdViewDelegate {
        private weak var container: ResizingContainer?

        func bind(container: ResizingContainer) { self.container = container }

        func didUpdateRatio(_: UIView, adRatio: TeadsAdRatio) {
            guard let container else { return }
            container.update(height: adRatio.calculateHeight(for: container.bounds.width))
        }
    }
}
