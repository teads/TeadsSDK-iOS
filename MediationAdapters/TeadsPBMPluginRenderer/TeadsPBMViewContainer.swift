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
