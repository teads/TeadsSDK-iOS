//
//  TeadsSASNativeAdapter.swift
//  TeadsSASAdapter
//
//  Created by Paul Nicolas on 23/11/2021.
//

import Foundation
import SASDisplayKit
import TeadsSDK
import UIKit

@objc(TeadsSASNativeAdapter)
final class TeadsSASNativeAdapter: NSObject, SASMediationNativeAdAdapter {
    weak var delegate: SASMediationNativeAdAdapterDelegate?
    private weak var viewController: UIViewController?
    private var placement: TeadsNativeAdPlacement?
    private var nativeAd: TeadsNativeAd?
    private var teadsMediaView: TeadsMediaView?
    private var adSettings: TeadsAdapterSettings?

    init(delegate: SASMediationNativeAdAdapterDelegate) {
        self.delegate = delegate
    }

    deinit {
        unregisterViews()
    }

    func requestNativeAd(withServerParameterString serverParameterString: String, clientParameters _: [AnyHashable: Any]) {
        guard let serverParameter = ServerParameter.instance(from: serverParameterString) else {
            delegate?.mediationNativeAdAdapter(self, didFailToLoadWithError: TeadsAdapterErrorCode.serverParameterError, noFill: false)
            return
        }

        guard let pid = serverParameter.placementId else {
            delegate?.mediationNativeAdAdapter(self, didFailToLoadWithError: TeadsAdapterErrorCode.pidNotFound, noFill: false)
            return
        }

        let adSettings = serverParameter.adSettings
        TeadsSASBannerAdapter.addExtrasToAdSettings(adSettings)

        placement = Teads.createNativePlacement(pid: pid, settings: adSettings.adPlacementSettings, delegate: self)
        placement?.requestAd(requestSettings: adSettings.adRequestSettings)
        self.adSettings = adSettings
    }

    func register(_ view: UIView, tappableViews: [Any]?, overridableViews _: [AnyHashable: Any], from viewController: UIViewController) {
        self.viewController = viewController

        nativeAd?.register(containerView: view)

        let views: [UIView] = tappableViews?.compactMap { $0 as? UIView } ?? []

        let callToAction = nativeAd?.callToAction
        let ctaButton = views
            .filter {
                if let button = $0 as? UIButton {
                    return button.titleLabel?.text == callToAction?.text
                }
                if let label = $0 as? UILabel {
                    return label.text == callToAction?.text
                }
                return false
            }
            .first
        ctaButton?.bind(component: callToAction)
    }

    func unregisterViews() {
        // do nothing
    }

    func adChoicesURL() -> URL? {
        return nativeAd?.adChoices?.clickThroughUrl
    }

    func hasMedia() -> Bool {
        return nativeAd?.video != nil
    }

    func mediaView() -> UIView? {
        return teadsMediaView
    }
}

extension TeadsSASNativeAdapter: TeadsNativeAdPlacementDelegate {
    func didReceiveAd(ad: TeadsNativeAd) {
        ad.delegate = self
        nativeAd = ad
        if let video = ad.video {
            teadsMediaView = TeadsMediaView(videoComponent: video)
            if let mediaScale = adSettings?.mediaScale {
                teadsMediaView?.mediaScale = mediaScale
            }
        }
        delegate?.mediationNativeAdAdapter(self, didLoad: ad.sasMediationNativeAdInfo)
    }

    func didFailToReceiveAd(reason: AdFailReason) {
        delegate?.mediationNativeAdAdapter(self, didFailToLoadWithError: reason, noFill: reason.isNoFill)
    }

    func adOpportunityTrackerView(trackerView _: TeadsAdOpportunityTrackerView) {
        // not supported in native format
    }
}

extension TeadsSASNativeAdapter: TeadsAdDelegate {
    func willPresentModalView(ad _: TeadsAd) -> UIViewController? {
        return viewController
    }

    func didRecordClick(ad _: TeadsAd) {
        delegate?.mediationNativeAdAdapterDidReceiveAdClickedEvent(self)
    }
}

extension TeadsNativeAd {
    var sasMediationNativeAdInfo: SASMediationNativeAdInfo {
        let info = SASMediationNativeAdInfo(title: title?.text ?? "")
        info.body = content?.text
        info.callToAction = callToAction?.text
        info.sponsored = sponsored?.text
        info.price = price?.text

        if let ratingText = rating?.text, let rating = Float(ratingText) {
            info.rating = rating
        }

        if let image = image {
            info.coverImage = SASNativeAdImage(url: image.url)
        }

        if let icon = icon {
            info.icon = SASNativeAdImage(url: icon.url)
        }

        return info
    }
}
