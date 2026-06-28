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

/// Hosts a Smart AdServer `SASBannerView` driven by the Teads adapter.
struct SASBannerHost: View {
    let formatId: Int

    @State private var height: CGFloat = 0

    var body: some View {
        SASBannerRepresentable(formatId: formatId, height: $height)
            .frame(height: height)
    }
}

private struct SASBannerRepresentable: UIViewRepresentable {
    let formatId: Int
    @Binding var height: CGFloat

    func makeCoordinator() -> Coordinator { Coordinator(height: $height) }

    func makeUIView(context: Context) -> UIView {
        let container = UIView()
        container.clipsToBounds = true

        let banner = SASBannerView(
            frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 250),
            loader: .activityIndicatorStyleWhite
        )
        banner.modalParentViewController = UIApplication.shared.firstKeyWindow?.rootViewController
        banner.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(banner)
        NSLayoutConstraint.activate([
            banner.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            banner.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            banner.topAnchor.constraint(equalTo: container.topAnchor),
            banner.bottomAnchor.constraint(equalTo: container.bottomAnchor),
        ])
        context.coordinator.banner = banner

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

        banner.load(with: placement)
        return container
    }

    func updateUIView(_ container: UIView, context: Context) {
        // Keep a valid presenting controller once the view is in the window.
        let rootVC = container.window?.rootViewController ?? UIApplication.shared.firstKeyWindow?.rootViewController
        if context.coordinator.banner?.modalParentViewController == nil {
            context.coordinator.banner?.modalParentViewController = rootVC
        }
    }

    final class Coordinator: NSObject, TeadsMediatedAdViewDelegate {
        @Binding var height: CGFloat
        weak var banner: SASBannerView?
        private var lastHeight: CGFloat = 0

        init(height: Binding<CGFloat>) { _height = height }

        func didUpdateRatio(_ adView: UIView, adRatio: TeadsAdRatio) {
            let width = adView.frame.width
            let newHeight = adRatio.calculateHeight(for: width)
            guard newHeight > 0, newHeight != lastHeight else { return }
            lastHeight = newHeight
            DispatchQueue.main.async { [weak self] in self?.height = newHeight }
        }
    }
}
