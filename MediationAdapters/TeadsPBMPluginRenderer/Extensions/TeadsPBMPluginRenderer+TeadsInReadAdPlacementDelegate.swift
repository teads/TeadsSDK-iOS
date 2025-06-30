//
//  TeadsPBMPluginRenderer+TeadsInReadAdPlacementDelegate.swift
//  TeadsPBMPluginRenderer
//
//  Created by Leonid Lemesev on 18/06/2025.
//

import PrebidMobile
import TeadsSDK

// MARK: - TeadsInReadAdPlacementDelegate

extension TeadsPBMPluginRenderer: TeadsInReadAdPlacementDelegate {
    public func didReceiveAd(ad: TeadsSDK.TeadsInReadAd, adRatio _: TeadsSDK.TeadsAdRatio) {
        guard let adContainer = adViewContainers[ad.requestIdentifier.uuidString],
              let adView = adContainer.adView else {
            dispatchError(TeadsPBMPluginError.viewMissing)
            return
        }
        ad.delegate = self
        adView.teadsView.bind(ad)
        adContainer.loadingDelegate?.displayViewDidLoadAd(adView)
    }

    public func didUpdateRatio(ad: TeadsSDK.TeadsInReadAd, adRatio: TeadsSDK.TeadsAdRatio) {
        pluginEventDelegates[ad.requestIdentifier.uuidString]?.didUpdateRatio(adRatio: adRatio)
    }

    public func didFailToReceiveAd(reason: TeadsSDK.AdFailReason) {
        pluginEventDelegates[reason.requestIdentifier.uuidString]?.onFailedToLoadAd(reason: reason.description)
        dispatchError(reason)

        guard let adContainer = adViewContainers[reason.requestIdentifier.uuidString],
              let adView = adContainer.adView else {
            dispatchError(TeadsPBMPluginError.viewMissing)
            return
        }

        adContainer.loadingDelegate?.displayView(adView, didFailWithError: reason)
    }

    public func adOpportunityTrackerView(trackerView: TeadsSDK.TeadsAdOpportunityTrackerView) {
        guard let requestIdentifier = trackerView.requestIdentifier,
              let adContainer = adViewContainers[requestIdentifier.uuidString],
              let adView = adContainer.adView else { return }

        adView.addSubview(trackerView)
    }
}
