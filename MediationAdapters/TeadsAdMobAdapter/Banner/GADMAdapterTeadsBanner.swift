//
//  GADMAdapterTeadsBanner.swift
//  TeadsAdMobAdapter
//
//  Created by Jérémy Grosjean on 07/06/2021.
//

import Foundation
import GoogleMobileAds
import TeadsSDK
#if canImport(TeadsAdapterCommon)
import TeadsAdapterCommon
#endif

@objc(GADMAdapterTeadsBanner)
public final class GADMAdapterTeadsBanner: NSObject, GADCustomEventBanner {
    private var currentBanner: TeadsInReadAdView?
    private var placement: TeadsInReadAdPlacement?
    @objc override public required init() {
        super.init()
    }

    @objc public weak var delegate: GADCustomEventBannerDelegate?

    @objc public func requestAd(
        _ adSize: GADAdSize,
        parameter serverParameter: String?,
        label _: String?,
        request: GADCustomEventRequest
    ) {
        // Check PID
        guard let rawPid = serverParameter, let pid = Int(rawPid) else {
            delegate?.customEventBanner(self, didFailAd: TeadsAdapterErrorCode.pidNotFound)
            return
        }

        // Prepare ad settings
        let adSettings = (try? TeadsAdapterSettings.instance(fromAdmobParameters: request.additionalParameters)) ?? TeadsAdapterSettings()

        currentBanner = TeadsInReadAdView(frame: CGRect(origin: CGPoint.zero, size: Helper.bannerSize(for: adSize.size.width)))

        placement = Teads.createInReadPlacement(pid: pid, settings: adSettings.adPlacementSettings, delegate: self)
        placement?.requestAd(requestSettings: adSettings.adRequestSettings)
    }
}

extension GADMAdapterTeadsBanner: TeadsInReadAdPlacementDelegate {
    public func didReceiveAd(ad: TeadsInReadAd, adRatio: TeadsAdRatio) {
        ad.delegate = self
        currentBanner?.bind(ad)
        currentBanner?.updateHeight(with: adRatio)
        if let adBanner = currentBanner {
            delegate?.customEventBanner(self, didReceiveAd: adBanner)
        }
    }

    public func didFailToReceiveAd(reason: AdFailReason) {
        delegate?.customEventBanner(self, didFailAd: reason)
    }

    public func adOpportunityTrackerView(trackerView _: TeadsAdOpportunityTrackerView) {
        // adOpportunityTrackerView is handled by TeadsSDK
    }

    public func didUpdateRatio(ad _: TeadsInReadAd, adRatio: TeadsAdRatio) {
        currentBanner?.updateHeight(with: adRatio)
    }
}

extension GADMAdapterTeadsBanner: TeadsAdDelegate {
    public func didRecordImpression(ad _: TeadsAd) {
        // not handled by GoogleMobileAds
    }

    public func didRecordClick(ad _: TeadsAd) {
        delegate?.customEventBannerWasClicked(self)
    }

    public func willPresentModalView(ad _: TeadsAd) -> UIViewController? {
        return delegate?.viewControllerForPresentingModalView
    }

    public func didCatchError(ad _: TeadsAd, error: Error) {
        delegate?.customEventBanner(self, didFailAd: error)
    }

    public func didClose(ad _: TeadsAd) {
        // not handled by GAD
    }

    public func didExpandedToFullscreen(ad _: TeadsAd) {
        delegate?.customEventBannerWillPresentModal(self)
    }

    public func didCollapsedFromFullscreen(ad _: TeadsAd) {
        delegate?.customEventBannerDidDismissModal(self)
    }
}
