//
//  GADMAdapterTeadsNative.swift
//  TeadsAdMobAdapter
//
//  Created by Jérémy Grosjean on 15/06/2021.
//

import GoogleMobileAds
import TeadsSDK
import UIKit
@_exported import Common

@objc(GADMAdapterTeadsNative)
final class GADMAdapterTeadsNative: NSObject, GADCustomEventNativeAd {
    weak var delegate: GADCustomEventNativeAdDelegate?
    private var placement: TeadsNativeAdPlacement?
    private var nativeAd: TeadsNativeAd?
    private var adOpportunityView: TeadsAdOpportunityTrackerView?
    private var adSettings: TeadsAdapterSettings?

    @objc override public required init() {
        super.init()
    }

    func request(withParameter serverParameter: String, request: GADCustomEventRequest, adTypes _: [Any], options _: [Any], rootViewController _: UIViewController) {
        // Check PID
        guard let pid = Int(serverParameter) else {
            delegate?.customEventNativeAd(self, didFailToLoadWithError: TeadsAdapterErrorCode.pidNotFound)
            return
        }

        // Prepare ad settings
        guard let adSettings = try? TeadsAdapterSettings.instance(fromAdmobParameters: request.additionalParameters) else {
            delegate?.customEventNativeAd(self, didFailToLoadWithError: TeadsAdapterErrorCode.serverParameterError)
            return
        }
        placement = Teads.createNativePlacement(pid: pid, settings: adSettings.adPlacementSettings, delegate: self)
        placement?.requestAd(requestSettings: adSettings.adRequestSettings)
        self.adSettings = adSettings
    }

    func handlesUserClicks() -> Bool {
        // Let Teads SDK tracks clicks
        return true
    }

    func handlesUserImpressions() -> Bool {
        // Let Teads SDK tracks impressions
        return true
    }
}

extension GADMAdapterTeadsNative: TeadsNativeAdPlacementDelegate {
    func didReceiveAd(ad: TeadsNativeAd) {
        nativeAd = ad
        let mediatedNativeAd = GADMAdapterTeadsMediatedNativeAd(teadsNativeAd: ad, adOpportunityView: adOpportunityView, adSettings: adSettings)
        nativeAd?.delegate = mediatedNativeAd
        nativeAd?.playbackDelegate = mediatedNativeAd

        delegate?.customEventNativeAd(self, didReceive: mediatedNativeAd)
        placement = nil
        adOpportunityView = nil
    }

    func didFailToReceiveAd(reason: AdFailReason) {
        delegate?.customEventNativeAd(self, didFailToLoadWithError: reason)
    }

    func adOpportunityTrackerView(trackerView: TeadsAdOpportunityTrackerView) {
        adOpportunityView = trackerView
    }
}
