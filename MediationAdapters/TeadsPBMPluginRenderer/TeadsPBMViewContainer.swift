//
//  TeadsPBMViewContainer.swift
//  TeadsPBMPluginRenderer
//
//  Created by Leonid Lemesev on 18/06/2025.
//

import PrebidMobile

class TeadsPBMViewContainer {
    weak var adView: TeadsPBMDisplayView?

    weak var loadingDelegate: (any DisplayViewLoadingDelegate)?

    weak var interactionDelegate: (any DisplayViewInteractionDelegate)?

    /// Prebid ad unit config fingerprint used to bridge with pluginEventDelegates
    var adUnitConfigFingerprint: String?

    /// Whether Prebid has been notified that the ad loaded (call displayViewDidLoadAd only once)
    var didNotifyAdLoaded = false

    init(
        adView: TeadsPBMDisplayView,
        loadingDelegate: any DisplayViewLoadingDelegate,
        interactionDelegate: any DisplayViewInteractionDelegate
    ) {
        self.adView = adView
        self.loadingDelegate = loadingDelegate
        self.interactionDelegate = interactionDelegate
    }
}
