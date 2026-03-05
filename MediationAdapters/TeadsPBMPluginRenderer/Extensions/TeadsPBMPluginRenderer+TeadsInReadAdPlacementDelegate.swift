//
//  TeadsPBMPluginRenderer+TeadsInReadAdPlacementDelegate.swift
//  TeadsPBMPluginRenderer
//
//  Created by Leonid Lemesev on 18/06/2025.
//

import PrebidMobile
import TeadsSDK
import UIKit

// MARK: - TeadsInReadAdPlacementDelegate

extension TeadsPBMPluginRenderer: TeadsInReadAdPlacementDelegate {
    public func didReceiveAd(ad: TeadsInReadAd, adRatio: TeadsAdRatio) {
        let requestId = ad.requestIdentifier.uuidString
        guard let adContainer = adViewContainers[requestId],
              let displayView = adContainer.adView else { return }

        // Create the Teads ad view on the main thread (UIView must be initialized on main)
        ad.delegate = self
        runOnMain {
            let teadsAdView = TeadsInReadAdView(bind: ad)
            displayView.embed(teadsAdView)

            // Notify Prebid that the ad loaded
            if !adContainer.didNotifyAdLoaded {
                adContainer.didNotifyAdLoaded = true
                adContainer.loadingDelegate?.displayViewDidLoadAd(displayView)
            }

            // Forward initial ratio to plugin event delegates
            if let fingerprint = adContainer.adUnitConfigFingerprint {
                self.pluginEventDelegates[fingerprint]?.didUpdateRatio(adRatio: adRatio)
            }
        }
    }

    public func didUpdateRatio(ad: TeadsInReadAd, adRatio: TeadsAdRatio) {
        let requestId = ad.requestIdentifier.uuidString
        guard let adContainer = adViewContainers[requestId] else { return }

        if let fingerprint = adContainer.adUnitConfigFingerprint {
            pluginEventDelegates[fingerprint]?.didUpdateRatio(adRatio: adRatio)
        }
    }

    public func didFailToReceiveAd(reason: AdFailReason) {
        for (_, container) in adViewContainers {
            // Notify Prebid loading delegate of the failure
            if let adView = container.adView {
                runOnMain {
                    container.loadingDelegate?.displayView(adView, didFailWithError: reason)
                }
            }

            // Forward failure to the matching plugin event delegate
            if let fingerprint = container.adUnitConfigFingerprint {
                pluginEventDelegates[fingerprint]?.onFailedToLoadAd(reason: reason.description)
            }
        }
    }

    public func adOpportunityTrackerView(trackerView: TeadsAdOpportunityTrackerView) {
        // Tracker view handling — attach to the display view associated with this request
        guard
            let requestId = trackerView.requestIdentifier?.uuidString,
            let container = adViewContainers[requestId],
            let displayView = container.adView else { return }

        runOnMain {
            displayView.addSubview(trackerView)
        }
    }
}
