//
//  MPAdapterTeadsMediatedNativeAd.swift
//  TeadsMoPubAdapter
//
//  Created by Jérémy Grosjean on 24/06/2021.
//

import MoPubSDK
import TeadsSDK
import UIKit

@objc(MPAdapterTeadsMediatedNativeAd)
final class MPAdapterTeadsMediatedNativeAd: NSObject, MPNativeAdAdapter {
    var defaultActionURL: URL?

    weak var delegate: MPNativeAdAdapterDelegate?

    var properties: [AnyHashable: Any] {
        var adProperties = [String: String]()
        if let title = teadsNativeAd.title?.text {
            adProperties[kAdTitleKey] = title
        }
        if let content = teadsNativeAd.content?.text {
            adProperties[kAdTextKey] = content
        }
        if let iconUrl = teadsNativeAd.icon?.url {
            adProperties[kAdIconImageKey] = iconUrl.absoluteString
        }
        if let imageUrl = teadsNativeAd.image?.url {
            adProperties[kAdMainImageKey] = imageUrl.absoluteString
        }
        if let callToAction = teadsNativeAd.callToAction?.text {
            adProperties[kAdCTATextKey] = callToAction
        }
        if let rating = teadsNativeAd.rating?.text {
            adProperties[kAdStarRatingKey] = rating
        }
        if let advertiser = teadsNativeAd.sponsored?.text {
            adProperties[kAdSponsoredByCompanyKey] = advertiser
        }
        return adProperties
    }

    var teadsNativeAd: TeadsNativeAd

    init(teadsNativeAd: TeadsNativeAd) {
        self.teadsNativeAd = teadsNativeAd
        super.init()
        self.teadsNativeAd.delegate = self
    }

    func enableThirdPartyClickTracking() -> Bool {
        return false
    }
}

extension MPAdapterTeadsMediatedNativeAd: TeadsAdDelegate {
    func didRecordImpression(ad _: TeadsAd) {
        delegate?.nativeAdWillLogImpression?(self)
        MPLogEvent.adShowSuccess(forAdapter: NSStringFromClass(MPAdapterTeadsNative.self))
        MPLogEvent.adDidAppear(forAdapter: NSStringFromClass(MPAdapterTeadsNative.self))
    }

    func didRecordClick(ad _: TeadsAd) {
        delegate?.nativeAdDidClick?(self)
        MPLogEvent.adTapped(forAdapter: NSStringFromClass(MPAdapterTeadsNative.self))
    }

    func willPresentModalView(ad _: TeadsAd) -> UIViewController? {
        return delegate?.viewControllerForPresentingModalView()
    }

    func didCatchError(ad _: TeadsAd, error: Error) {
        MPLogEvent.error(error, message: error.localizedDescription)
    }

    func didClose(ad _: TeadsAd) {
        MPLogEvent.adDidDisappear(forAdapter: NSStringFromClass(MPAdapterTeadsNative.self))
    }

    func didExpandedToFullscreen(ad _: TeadsAd) {
        MPLogEvent.adWillPresentModal(forAdapter: NSStringFromClass(MPAdapterTeadsNative.self))
    }

    func didCollapsedFromFullscreen(ad _: TeadsAd) {
        MPLogEvent.adDidDismissModal(forAdapter: NSStringFromClass(MPAdapterTeadsNative.self))
    }
}
