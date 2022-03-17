//
//  MPAdapterTeadsNative.swift
//  TeadsMoPubAdapter
//
//  Created by Jérémy Grosjean on 24/06/2021.
//

import TeadsSDK
import UIKit

import MoPubSDK

@objc(MPAdapterTeadsNative)
public final class MPAdapterTeadsNative: MPNativeCustomEvent {
    // MARK: - Members

    private var currentNativePlacement: TeadsNativeAdPlacement?
    // private var mediatedNativeAd: MPNativeAdAdapter?

    // MARK: - MPNativeCustomEvent Protocol

    @objc override public func requestAd(withCustomEventInfo info: [AnyHashable: Any], adMarkup _: String) {
        // Check PID
        guard let rawPid = info[MPAdapterTeadsConstants.teadsPIDKey] as? String, let pid = Int(rawPid) else {
            delegate.nativeCustomEvent(self, didFailToLoadAdWithError: TeadsAdapterErrorCode.pidNotFound)
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
        delegate.nativeCustomEvent(self, didFailToLoadAdWithError: reason)
    }

    public func adOpportunityTrackerView(trackerView _: TeadsAdOpportunityTrackerView) {
        // no implemented for now
    }
}
