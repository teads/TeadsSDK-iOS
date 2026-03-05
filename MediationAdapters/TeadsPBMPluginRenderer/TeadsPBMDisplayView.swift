//
//  TeadsPBMDisplayView.swift
//  TeadsPBMPluginRenderer
//
//  Refactored by Richard Dépierre on 18/06/2025.
//

import Foundation
import PrebidMobile
import TeadsSDK
import UIKit

// MARK: - Teads Prebid Display View

/// A wrapper view conforming to `PrebidMobileDisplayViewProtocol` that
/// hosts a `TeadsInReadAdView` and relays callbacks to Prebid.
class TeadsPBMDisplayView: UIView, PrebidMobileDisplayViewProtocol {
    /// The Teads ad view, set when `didReceiveAd` is called.
    private(set) var teadsAdView: TeadsInReadAdView?

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    /// Unavailable since this view is not intended to be instantiated from a nib/storyboard.
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Ad View Embedding

    /// Embeds a `TeadsInReadAdView` bound to the received ad.
    func embed(_ adView: TeadsInReadAdView) {
        teadsAdView = adView
        addSubview(adView)
        adView.translatesAutoresizingMaskIntoConstraints = false

        // Bottom constraint at low priority so TeadsInReadAdView's internal
        // height constraint (.defaultHigh) drives the content size.
        let bottom = adView.bottomAnchor.constraint(equalTo: bottomAnchor)
        bottom.priority = .defaultLow

        NSLayoutConstraint.activate([
            adView.topAnchor.constraint(equalTo: topAnchor),
            adView.leadingAnchor.constraint(equalTo: leadingAnchor),
            adView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottom,
        ])
    }

    // MARK: - PrebidMobileDisplayViewProtocol

    /// Called by Prebid after this view is returned from `createBannerView`.
    func loadAd() {
        // No-op — the ad is loaded via TeadsPrebidAdPlacement.loadAd(adResponse:).
    }
}
