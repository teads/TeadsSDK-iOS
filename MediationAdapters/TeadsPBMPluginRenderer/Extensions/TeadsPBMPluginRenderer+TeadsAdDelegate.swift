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
        DispatchQueue.main.sync {
            adContainer.interactionDelegate?.willPresentModal(from: adView)
        }
        return nil
    }

    public func didRecordImpression(ad: TeadsAd) {
        guard let adContainer = adViewContainers[ad.requestIdentifier.uuidString],
              let adView = adContainer.adView else { return }

        DispatchQueue.main.sync {
            adContainer.interactionDelegate?.trackImpression(forDisplayView: adView)
        }
    }

    public func didRecordClick(ad: TeadsAd) {
        guard let adContainer = adViewContainers[ad.requestIdentifier.uuidString],
              let adView = adContainer.adView else { return }

        DispatchQueue.main.sync {
            adContainer.interactionDelegate?.didLeaveApp(from: adView)
        }
    }

    public func didCatchError(ad: TeadsAd, error: any Error) {
        guard let adContainer = adViewContainers[ad.requestIdentifier.uuidString],
              let adView = adContainer.adView else { return }

        DispatchQueue.main.sync {
            adContainer.loadingDelegate?.displayView(adView, didFailWithError: error)
        }
    }

    public func didCollapsedFromFullscreen(ad: TeadsAd) {
        pluginEventDelegates[ad.requestIdentifier.uuidString]?.onAdCollapsedFromFullScreen()
    }

    public func didExpandedToFullscreen(ad: TeadsAd) {
        pluginEventDelegates[ad.requestIdentifier.uuidString]?.onAdExpandedToFullScreen()
    }
}
