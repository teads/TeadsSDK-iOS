//
//  TeadsPBMDisplayView.swift
//  TeadsPBMPluginRenderer
//
//  Refactored by Richard Dépierre on 18/06/2025.
//

import Foundation
import PrebidMobile
import TeadsSDK

// MARK: - Teads Prebid Display View

/// A wrapper view conforming to `PrebidMobileDisplayViewProtocol` that
/// hosts a `TeadsInReadAdView` and relays load/interaction callbacks to Prebid.
class TeadsPBMDisplayView: UIView, PrebidMobileDisplayViewProtocol {
    /// The underlying Teads in-read ad view.
    let teadsView: TeadsInReadAdView

    // MARK: - Initializers

    override required init(frame: CGRect) {
        // Create Teads ad view with same frame
        teadsView = TeadsInReadAdView(frame: frame)
        super.init(frame: frame)

        // Add and constrain the Teads ad view to fill this container
        addSubview(teadsView)
        teadsView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            teadsView.topAnchor.constraint(equalTo: topAnchor),
            teadsView.leadingAnchor.constraint(equalTo: leadingAnchor),
            teadsView.trailingAnchor.constraint(equalTo: trailingAnchor),
            teadsView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    /// Unavailable since this view is not intended to be instantiated from a nib/storyboard.
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - PrebidMobileDisplayViewProtocol

    /// Notifies Prebid that the creative is ready to be displayed.
    ///
    /// Called by Prebid after this view is returned from `createBannerView`.
    func loadAd() {
        // No-op because the ad is already loaded on view init.
    }
}
