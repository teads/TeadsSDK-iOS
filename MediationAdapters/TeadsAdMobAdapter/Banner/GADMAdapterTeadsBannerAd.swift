//
//  GADMAdapterTeadsBannerAd.swift
//  TeadsAdMobAdapter
//
//  Created by Thibaud Saint-Etienne on 27/10/2022.
//

import Foundation
import GoogleMobileAds
import TeadsSDK

@objc(GADMAdapterTeadsBannerAd)
public final class GADMAdapterTeadsBannerAd: NSObject, MediationBannerAd {
    /// The Teads Ad network InRead AdView
    var bannerAd: TeadsInReadAdView?

    /// The ad event delegate to forward ad rendering events to the Google Mobile Ads SDK.
    var delegate: MediationBannerAdEventDelegate?

    /// Completion handler called after ad load
    var completionHandler: GADMediationBannerLoadCompletionHandler?

    public var view: UIView {
        bannerAd ?? UIView()
    }

    private var placement: TeadsInReadAdPlacement?
    private var adConfiguration: MediationBannerAdConfiguration?
    private var adSettings: TeadsAdapterSettings?

    public func loadBanner(
        for adConfiguration: MediationBannerAdConfiguration,
        completionHandler: @escaping GADMediationBannerLoadCompletionHandler
    ) {
        // Check PID
        guard let rawPid = adConfiguration.credentials.settings["parameter"] as? String, let pid = Int(rawPid) else {
            delegate = completionHandler(nil, TeadsAdapterErrorCode.pidNotFound)
            return
        }

        self.completionHandler = completionHandler
        self.adConfiguration = adConfiguration

        // Prepare ad settings
        let adSettings = (adConfiguration.extras as? TeadsAdapterSettings) ?? TeadsAdapterSettings()
        adSettings.setIntegration(type: .adMob, version: AdMobHelper.getGMAVersionNumber())
        self.adSettings = adSettings

        let adSize = adConfiguration.adSize
        bannerAd = TeadsInReadAdView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: adSize.size.width, height: adSize.size.height)))

        placement = Teads.createInReadPlacement(pid: pid, settings: adSettings.adPlacementSettings, delegate: self)
        placement?.requestAd(requestSettings: adSettings.adRequestSettings)
    }
}

extension GADMAdapterTeadsBannerAd: TeadsInReadAdPlacementDelegate {
    public func didReceiveAd(ad: TeadsInReadAd, adRatio: TeadsAdRatio) {
        ad.delegate = self
        bannerAd?.bind(ad)
        if adSettings?.hasSubscribedToAdResizing ?? false {
            bannerAd?.updateHeight(with: adRatio)
        }
        delegate = completionHandler?(self, nil)
        completionHandler = nil
    }

    public func didFailToReceiveAd(reason: AdFailReason) {
        delegate = completionHandler?(nil, reason)
        completionHandler = nil
    }

    public func adOpportunityTrackerView(trackerView _: TeadsAdOpportunityTrackerView) {
        // adOpportunityTrackerView is handled by TeadsSDK
    }

    public func didUpdateRatio(ad _: TeadsInReadAd, adRatio: TeadsAdRatio) {
        if adSettings?.hasSubscribedToAdResizing ?? false {
            bannerAd?.updateHeight(with: adRatio)
        }
    }
}

extension GADMAdapterTeadsBannerAd: TeadsAdDelegate {
    public func didRecordImpression(ad _: TeadsAd) {
        delegate?.reportImpression()
    }

    public func didRecordClick(ad _: TeadsAd) {
        delegate?.reportClick()
    }

    public func willPresentModalView(ad _: TeadsAd) -> UIViewController? {
        delegate?.willPresentFullScreenView()
        return adConfiguration?.topViewController
    }

    public func didCatchError(ad _: TeadsAd, error: Error) {
        delegate?.didFailToPresentWithError(error)
    }

    public func didExpandedToFullscreen(ad _: TeadsAd) {
        delegate?.willPresentFullScreenView()
    }

    public func didCollapsedFromFullscreen(ad _: TeadsAd) {
        delegate?.didDismissFullScreenView()
    }
}
