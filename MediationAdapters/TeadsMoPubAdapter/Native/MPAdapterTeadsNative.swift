//
//  MPAdapterTeadsNative.swift
//  TeadsAdMobAdapter
//
//  Created by Jérémy Grosjean on 24/06/2021.
//

import UIKit
import TeadsSDK

import MoPubSDK

@objc(MPAdapterTeadsNative)
public final class MPAdapterTeadsNative: MPNativeCustomEvent {

    // MARK: - Members
    private var currentNativePlacement: TeadsNativeAdPlacement?
    // private var mediatedNativeAd: MPNativeAdAdapter?

    // MARK: - MPNativeCustomEvent Protocol
    @objc public override func requestAd(withCustomEventInfo info: [AnyHashable: Any], adMarkup: String) {
        // Check PID
        guard let rawPid = info[MPAdapterTeadsConstants.teadsPIDKey] as? String, let pid = Int(rawPid) else {
            let error = NSError.from(code: .pidNotFound,
                                     description: "No valid PID has been provided to load Teads banner ad.",
                                     domain: MPAdapterTeadsConstants.teadsAdapterErrorDomain)
            delegate.nativeCustomEvent(self, didFailToLoadAdWithError: error)
            return
        }

        // Prepare ad settings
        let adSettings = (try? TeadsAdapterSettings.instance(fromMopubParameters: localExtras)) ?? TeadsAdapterSettings()
        adSettings.setIntegation(TeadsAdapterSettings.integrationMopub, version: MoPub.sharedInstance().version())

        // Load native ad
        currentNativePlacement = Teads.createNativePlacement(pid: pid, settings: adSettings.adPlacementSettings, delegate: self)
        currentNativePlacement?.requestAd(requestSettings: adSettings.adRequestSettings)
    }

}

extension MPAdapterTeadsNative: TeadsNativeAdPlacementDelegate {
    public func didReceiveAd(ad: TeadsNativeAd) {
        let mediatedNativeAd = MPAdapterTeadsMediatedNativeAd(teadsNativeAd: ad)
        let nativeAd = MPNativeAd(adAdapter: mediatedNativeAd)
        delegate.nativeCustomEvent(self, didLoad: nativeAd)
    }

    public func didFailToReceiveAd(reason: AdFailReason) {
        delegate.nativeCustomEvent(self, didFailToLoadAdWithError: NSError(domain: "teads.placement", code: reason.errorCode.rawValue, userInfo: [NSLocalizedDescriptionKey: reason.errorMessage]))
    }

    public func adOpportunityTrackerView(trackerView: TeadsAdOpportunityTrackerView) {
        // no implemented for now
    }
}
