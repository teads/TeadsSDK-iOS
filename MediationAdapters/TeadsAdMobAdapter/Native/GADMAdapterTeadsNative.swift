//
//  GADMAdapterTeadsNative.swift
//  TeadsAdMobAdapter
//
//  Created by Jérémy Grosjean on 15/06/2021.
//

import UIKit
import TeadsSDK
import GoogleMobileAds

@objc(GADMAdapterTeadsNative)
final class GADMAdapterTeadsNative: NSObject, GADCustomEventNativeAd {

    weak var delegate: GADCustomEventNativeAdDelegate?
    private var placement: TeadsNativeAdPlacement?
    private var nativeAd: TeadsNativeAd?
    private var adOpportunityView: TeadsAdOpportunityTrackerView?

    @objc public required override init() {
        super.init()
    }

    func request(withParameter serverParameter: String, request: GADCustomEventRequest, adTypes: [Any], options: [Any], rootViewController: UIViewController) {

        // Check PID
        guard let pid = Int(serverParameter) else {
            let error = NSError.from(code: .pidNotFound,
                                     description: "No valid PID has been provided to load Teads banner ad.",
                                     domain: GADMAdapterTeadsConstants.teadsAdapterErrorDomain)
            delegate?.customEventNativeAd(self, didFailToLoadWithError: error)
            return
        }

        // Prepare ad settings
        guard let adSettings = try? TeadsAdapterSettings.instance(fromAdmobParameters: request.additionalParameters) else {
            return
        }
        placement = Teads.createNativePlacement(pid: pid, settings: adSettings.adPlacementSettings, delegate: self)
        placement?.requestAd(requestSettings: adSettings.adRequestSettings)
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
        let mediatedNativeAd = GADMAdapterTeadsMediatedNativeAd(teadsNativeAd: ad, adOpportunityView: adOpportunityView)
        nativeAd?.delegate = mediatedNativeAd
        nativeAd?.playbackDelegate = mediatedNativeAd

        delegate?.customEventNativeAd(self, didReceive: mediatedNativeAd)
        placement = nil
        adOpportunityView = nil
    }

    func didFailToReceiveAd(reason: AdFailReason) {
        delegate?.customEventNativeAd(self, didFailToLoadWithError: NSError(domain: "teads.placement", code: reason.errorCode.rawValue, userInfo: [NSLocalizedDescriptionKey: reason.errorMessage]))
    }

    func adOpportunityTrackerView(trackerView: TeadsAdOpportunityTrackerView) {
        adOpportunityView = trackerView
    }

}
