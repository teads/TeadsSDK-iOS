//
//  TeadsPBMPluginRenderer+TeadsAdDelegate.swift
//  TeadsPBMPluginRenderer
//
//  Created by Leonid Lemesev on 18/06/2025.
//

import TeadsSDK
import UIKit

extension TeadsPBMPluginRenderer: TeadsAdDelegate {
    public func willPresentModalView(ad: TeadsSDK.TeadsAd) -> UIViewController? {
        guard let adContainer = adViewContainers[ad.requestIdentifier.uuidString],
              let adView = adContainer.adView else { return nil }
        runOnMain {
            adContainer.interactionDelegate?.willPresentModal(from: adView)
        }

        var presentingViewController: UIViewController?
        if Thread.isMainThread {
            presentingViewController = adContainer.interactionDelegate?.viewControllerForModalPresentation(fromDisplayView: adView)
        } else {
            DispatchQueue.main.sync {
                presentingViewController = adContainer.interactionDelegate?.viewControllerForModalPresentation(fromDisplayView: adView)
            }
        }
        return presentingViewController
    }

    public func didRecordImpression(ad: TeadsAd) {
        guard let adContainer = adViewContainers[ad.requestIdentifier.uuidString],
              let adView = adContainer.adView else { return }

        runOnMain {
            adContainer.interactionDelegate?.trackImpression(forDisplayView: adView)
        }
    }

    public func didRecordClick(ad: TeadsAd) {
        guard let adContainer = adViewContainers[ad.requestIdentifier.uuidString],
              let adView = adContainer.adView else { return }

        runOnMain {
            adContainer.interactionDelegate?.didLeaveApp(from: adView)
        }
    }

    public func didCatchError(ad: TeadsAd, error: any Error) {
        guard let adContainer = adViewContainers[ad.requestIdentifier.uuidString],
              let adView = adContainer.adView else { return }

        runOnMain {
            adContainer.loadingDelegate?.displayView(adView, didFailWithError: error)
        }
    }

    public func didCollapsedFromFullscreen(ad: TeadsAd) {
        if let fingerprint = adViewContainers[ad.requestIdentifier.uuidString]?.adUnitConfigFingerprint {
            pluginEventDelegates[fingerprint]?.onAdCollapsedFromFullScreen()
        }
    }

    public func didExpandedToFullscreen(ad: TeadsAd) {
        if let fingerprint = adViewContainers[ad.requestIdentifier.uuidString]?.adUnitConfigFingerprint {
            pluginEventDelegates[fingerprint]?.onAdExpandedToFullScreen()
        }
    }
}
