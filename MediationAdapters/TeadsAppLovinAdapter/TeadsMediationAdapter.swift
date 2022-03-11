//
//  TeadsMediationAdapter.swift
//  TeadsAppLovinAdapter
//
//  Created by Paul Nicolas on 15/02/2022.
//

import UIKit
import AppLovinSDK
import TeadsSDK

@objc(TeadsMediationAdapter)
final class TeadsMediationAdapter: ALMediationAdapter {
    var currentNativePlacement: TeadsNativeAdPlacement?
    weak var nativeDelegate: MANativeAdAdapterDelegate?

    var currentInReadPlacement: TeadsInReadAdPlacement?
    weak var bannerDelegate: MAAdViewAdapterDelegate?
    weak var currentAdView: TeadsInReadAdView?

    @objc override func initialize(with parameters: MAAdapterInitializationParameters, completionHandler: @escaping (MAAdapterInitializationStatus, String?) -> Void) {
        Teads.configure()
        completionHandler(.doesNotApply, nil)
    }

    @objc override var sdkVersion: String {
        return Teads.sdkVersion
    }

    @objc override var adapterVersion: String {
        return Teads.sdkVersion
    }

    @objc override var isBeta: Bool {
        return false
    }

    override func destroy() {
        
    }
}

@objc extension TeadsMediationAdapter: MANativeAdAdapter {
    func loadNativeAd(for parameters: MAAdapterResponseParameters, andNotify delegate: MANativeAdAdapterDelegate) {
        nativeDelegate = delegate
        guard let pid = Int(parameters.thirdPartyAdPlacementIdentifier) else {
            delegate.didFailToLoadNativeAdWithError(.invalidConfiguration)
            return
        }

        // Prepare ad settings
        let adSettings = (try? TeadsAdapterSettings.instance(fromAppLovinParameters: parameters.localExtraParameters)) ?? TeadsAdapterSettings()

        // Load native ad
        currentNativePlacement = Teads.createNativePlacement(pid: pid, settings: adSettings.adPlacementSettings, delegate: self)
        currentNativePlacement?.requestAd(requestSettings: adSettings.adRequestSettings)
    }
}

@objc extension TeadsMediationAdapter: MAAdViewAdapter {
    func loadAdViewAd(for parameters: MAAdapterResponseParameters, adFormat: MAAdFormat, andNotify delegate: MAAdViewAdapterDelegate) {
        bannerDelegate = delegate
        guard let pid = Int(parameters.thirdPartyAdPlacementIdentifier) else {
            delegate.didFailToLoadAdViewAdWithError(.invalidConfiguration)
            return
        }

        // Prepare ad settings
        let adSettings = (try? TeadsAdapterSettings.instance(fromAppLovinParameters: parameters.localExtraParameters)) ?? TeadsAdapterSettings()
        
        // Load inRead ad
        currentInReadPlacement = Teads.createInReadPlacement(pid: pid, settings: adSettings.adPlacementSettings, delegate: self)
        currentInReadPlacement?.requestAd(requestSettings: adSettings.adRequestSettings)
    }
}

extension TeadsMediationAdapter: TeadsInReadAdPlacementDelegate {
    func didReceiveAd(ad: TeadsInReadAd, adRatio: TeadsAdRatio) {
        let adView = TeadsInReadAdView(bind: ad)
        currentAdView = adView
        bannerDelegate?.didLoadAd(forAdView: adView)
    }

    func didUpdateRatio(ad: TeadsInReadAd, adRatio: TeadsAdRatio) {
        currentAdView?.updateHeight(with: adRatio)
    }
}

extension TeadsMediationAdapter: TeadsNativeAdPlacementDelegate {
    func didReceiveAd(ad: TeadsNativeAd) {
        guard let mediaComponent = ad.video ?? ad.image else {
            nativeDelegate?.didFailToLoadNativeAdWithError(.missingRequiredNativeAdAssets)
            return
        }

        ad.delegate = self

        let nativeAd = MANativeAd(format: .native) { builder in
            if let title = ad.title?.text {
                builder.title = title
            }

            builder.body = ad.content?.text
            builder.advertiser = ad.sponsored?.text
            builder.callToAction = ad.callToAction?.text

            let mediaView = TeadsMediaView()
            mediaView.bind(component: mediaComponent)
            builder.mediaView = mediaView

            ad.icon?.loadImage { icon in
                builder.icon = MANativeAdImage(image: icon)
            }
        }

        nativeDelegate?.didLoadAd(for: nativeAd, withExtraInfo: nil)
    }

    func didFailToReceiveAd(reason: AdFailReason) {
        nativeDelegate?.didFailToLoadNativeAdWithError(MAAdapterError(adapterError: .noFill, thirdPartySdkErrorCode: reason.errorCode, thirdPartySdkErrorMessage: reason.localizedDescription))
        bannerDelegate?.didFailToLoadAdViewAdWithError(MAAdapterError(adapterError: .noFill, thirdPartySdkErrorCode: reason.errorCode, thirdPartySdkErrorMessage: reason.localizedDescription))
    }

    func adOpportunityTrackerView(trackerView: TeadsAdOpportunityTrackerView) {
        // adOpportunityTrackerView is handled by TeadsSDK
    }
}

extension TeadsMediationAdapter: TeadsAdDelegate {
    func willPresentModalView(ad: TeadsAd) -> UIViewController? {
        return ALUtils.topViewControllerFromKeyWindow()
    }

    func didRecordClick(ad: TeadsAd) {
        nativeDelegate?.didClickNativeAd()
        bannerDelegate?.didClickAdViewAd()
    }

    func didRecordImpression(ad: TeadsAd) {
        nativeDelegate?.didDisplayNativeAd(withExtraInfo: ["event": "impression"])
        bannerDelegate?.didDisplayAdViewAd(withExtraInfo: ["event": "impression"])
    }

    func didCatchError(ad: TeadsAd, error: Error) {
        bannerDelegate?.didFailToDisplayAdViewAdWithError(MAAdapterError(adapterError: .noConnection, thirdPartySdkErrorCode: error._code, thirdPartySdkErrorMessage: error.localizedDescription))
    }

    func didClose(ad: TeadsAd) {
        bannerDelegate?.didHideAdViewAd()
    }

    func didExpandedToFullscreen(ad: TeadsAd) {
        bannerDelegate?.didExpandAdViewAd()
    }

    func didCollapsedFromFullscreen(ad: TeadsAd) {
        bannerDelegate?.didCollapseAdViewAd()
    }
}
