//
//  GADMAdapterTeadsMediatedNativeAd.swift
//  TeadsAdMobAdapter
//
//  Created by Jérémy Grosjean on 15/06/2021.
//

import UIKit
import TeadsSDK
import GoogleMobileAds

class GADMAdapterTeadsMediatedNativeAd: NSObject {
    let teadsNativeAd: TeadsNativeAd
    var mappedImages = [GADNativeAdImage]()
    var mappedIcon: GADNativeAdImage?
    private var adOpportunityView: TeadsAdOpportunityTrackerView?
    var teadsMediaView: TeadsMediaView?
    weak var viewController: UIViewController?
    
    init(teadsNativeAd: TeadsNativeAd, adOpportunityView: TeadsAdOpportunityTrackerView?) {
        self.teadsNativeAd = teadsNativeAd
        self.adOpportunityView = adOpportunityView
        if let video = teadsNativeAd.video {
            teadsMediaView = TeadsMediaView(videoComponent: video)
        }
        super.init()
        teadsNativeAd.image?.loadImage(async: false) { [weak self] image in
            self?.mappedImages = [GADNativeAdImage(image: image)]
        }

        teadsNativeAd.icon?.loadImage(async: false) { [weak self] image in
            self?.mappedIcon = GADNativeAdImage(image: image)
        }

    }
}

extension GADMAdapterTeadsMediatedNativeAd: GADMediatedUnifiedNativeAd {
    
    var extraAssets: [String : Any]? {
        return nil
    }
    
    var advertiser: String? {
        return teadsNativeAd.sponsored?.text
    }

    var headline: String? {
        return teadsNativeAd.title?.text
    }

    var images: [GADNativeAdImage]? {
        return mappedImages
    }

    var body: String? {
        return teadsNativeAd.content?.text
    }

    var icon: GADNativeAdImage? {
        return mappedIcon
    }

    var callToAction: String? {
        return teadsNativeAd.callToAction?.text
    }

    var starRating: NSDecimalNumber? {
        guard let stringValue = teadsNativeAd.rating?.text else {
            return nil
        }
        return NSDecimalNumber(string: stringValue)
    }

    var store: String? {
        return nil
    }

    var price: String? {
        return teadsNativeAd.price?.text
    }

    var mediaView: UIView? {
        // Used to return the mediaView if video content
        // Set to nil as we only handle images atm
        return teadsMediaView
    }
    
    var hasVideoContent: Bool {
        return teadsNativeAd.video != nil
    }

    var adChoicesView: UIView? {
        // AdChoices is completely handle from the SDK side because this doesn't work here atm
        return nil
    }
    
    func didRender(in view: UIView, clickableAssetViews: [GADNativeAssetIdentifier: UIView], nonclickableAssetViews: [GADNativeAssetIdentifier: UIView], viewController: UIViewController) {
        self.viewController = viewController
        teadsNativeAd.register(containerView: view)
        if let adOpportunityView = adOpportunityView {
            view.addSubview(adOpportunityView)
            self.adOpportunityView = nil
        }
        clickableAssetViews.forEach { (key, assetView) in
            switch key {
            case .headlineAsset:
                guard let headline = teadsNativeAd.title else {
                    break
                }
                assetView.bind(component: headline)
            case .callToActionAsset:
                guard let callToAction = teadsNativeAd.callToAction else {
                    break
                }
                assetView.bind(component: callToAction)
            case .iconAsset:
                guard let icon = teadsNativeAd.icon else {
                    break
                }
                assetView.bind(component: icon)
            case .bodyAsset:
                guard let body = teadsNativeAd.content else {
                    break
                }
                assetView.bind(component: body)
            case .priceAsset:
                guard let price = teadsNativeAd.price else {
                    break
                }
                assetView.bind(component: price)
            case .imageAsset:
                guard let image = teadsNativeAd.image else {
                    break
                }
                assetView.bind(component: image)
            case .mediaViewAsset:
                guard let video = teadsNativeAd.video else {
                    break
                }
                assetView.bind(component: video)
            case .starRatingAsset:
                guard let starRating = teadsNativeAd.rating else {
                    break
                }
                assetView.bind(component: starRating)
            case .advertiserAsset:
                guard let advertiser = teadsNativeAd.sponsored else {
                    break
                }
                assetView.bind(component: advertiser)
            default:
                break
            }
        }
    }
}

extension GADMAdapterTeadsMediatedNativeAd: TeadsAdDelegate {
    func didRecordImpression(ad: TeadsAd) {
        GADMediatedUnifiedNativeAdNotificationSource.mediatedNativeAdDidRecordImpression(self)
    }
    
    func didRecordClick(ad: TeadsAd) {
        GADMediatedUnifiedNativeAdNotificationSource.mediatedNativeAdDidRecordClick(self)
    }
    
    func willPresentModalView(ad: TeadsAd) -> UIViewController? {
        return viewController
    }
    
    func didCatchError(ad: TeadsAd, error: Error) {
        //don't know what to do yet
    }
    
    func didClose(ad: TeadsAd) {
        //don't know what to do yet
    }
    
    public func didExpandedToFullscreen(ad: TeadsAd) {
        GADMediatedUnifiedNativeAdNotificationSource.mediatedNativeAdWillPresentScreen(self)
    }
    
    public func didCollapsedFromFullscreen(ad: TeadsAd) {
        GADMediatedUnifiedNativeAdNotificationSource.mediatedNativeAdDidDismissScreen(self)
    }
    
}
