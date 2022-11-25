//
//  GADMAdapterTeadsNativeAd.swift
//  TeadsAdMobAdapter
//
//  Created by Thibaud Saint-Etienne on 27/10/2022.
//

import GoogleMobileAds
import TeadsSDK
import UIKit

@objc(GADMAdapterTeadsNativeAd)
final class GADMAdapterTeadsNativeAd: NSObject, GADMediationNativeAd {
    /// The ad event delegate to forward ad rendering events to the Google Mobile Ads SDK.
    var delegate: GADMediationNativeAdEventDelegate?

    /// Completion handler called after ad load
    var completionHandler: GADMediationNativeLoadCompletionHandler?

    private var placement: TeadsNativeAdPlacement?
    private var adConfiguration: GADMediationNativeAdConfiguration?
    private var adOpportunityView: TeadsAdOpportunityTrackerView?

    private var mappedImages = [GADNativeAdImage]()
    private var mappedIcon: GADNativeAdImage?
    private var teadsMediaView: TeadsMediaView?
    private var adSettings: TeadsAdapterSettings?

    private weak var viewController: UIViewController?

    var nativeAd: TeadsNativeAd?

    var headline: String? {
        nativeAd?.title?.text
    }

    var images: [GADNativeAdImage]? {
        mappedImages
    }

    var body: String? {
        nativeAd?.content?.text
    }

    var icon: GADNativeAdImage? {
        mappedIcon
    }

    var callToAction: String? {
        nativeAd?.callToAction?.text
    }

    var starRating: NSDecimalNumber? {
        guard let stringValue = nativeAd?.rating?.text else {
            return nil
        }
        return NSDecimalNumber(string: stringValue)
    }

    var store: String? {
        nil
    }

    var price: String? {
        nativeAd?.price?.text
    }

    var advertiser: String? {
        nativeAd?.sponsored?.text
    }

    var extraAssets: [String: Any]? {
        nil
    }

    var adChoicesView: UIView? {
        TeadsAdChoicesView(binding: nativeAd?.adChoices)
    }

    var mediaView: UIView? {
        // Used to return the mediaView if video content.
        teadsMediaView
    }

    var mediaContentAspectRatio: CGFloat {
        nativeAd?.video?.contentAspectRatio ?? 0
    }

    var hasVideoContent: Bool {
        nativeAd?.video != nil
    }

    override required init() {
        super.init()
    }

    func loadNativeAd(
        for adConfiguration: GADMediationNativeAdConfiguration,
        completionHandler: @escaping GADMediationNativeLoadCompletionHandler
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
        adSettings.setIntegation(TeadsAdapterSettings.integrationAdmob, version: GADMobileAds.sharedInstance().sdkVersion)
        self.adSettings = adSettings
        placement = Teads.createNativePlacement(pid: pid, settings: adSettings.adPlacementSettings, delegate: self)
        placement?.requestAd(requestSettings: adSettings.adRequestSettings)
    }

    func handlesUserClicks() -> Bool {
        // Let Teads SDK tracks clicks
        true
    }

    func handlesUserImpressions() -> Bool {
        // Let Teads SDK tracks impressions
        true
    }

    func didRender(
        in view: UIView,
        clickableAssetViews: [GADNativeAssetIdentifier: UIView],
        nonclickableAssetViews _: [GADNativeAssetIdentifier: UIView],
        viewController: UIViewController
    ) {
        self.viewController = viewController
        nativeAd?.register(containerView: view)
        if let adOpportunityView = adOpportunityView {
            view.addSubview(adOpportunityView)
            self.adOpportunityView = nil
        }
        clickableAssetViews.forEach { key, assetView in
            switch key {
                case .headlineAsset:
                    assetView.bind(component: nativeAd?.title)
                case .callToActionAsset:
                    assetView.bind(component: nativeAd?.callToAction)
                case .iconAsset:
                    assetView.bind(component: nativeAd?.icon)
                case .bodyAsset:
                    assetView.bind(component: nativeAd?.content)
                case .priceAsset:
                    assetView.bind(component: nativeAd?.price)
                case .imageAsset:
                    assetView.bind(component: nativeAd?.image)
                case .mediaViewAsset:
                    assetView.bind(component: nativeAd?.video)
                case .starRatingAsset:
                    assetView.bind(component: nativeAd?.rating)
                case .advertiserAsset:
                    assetView.bind(component: nativeAd?.sponsored)
                default:
                    break
            }
        }
    }

    private func loadNativeImages() {
        if let video = nativeAd?.video {
            teadsMediaView = TeadsMediaView(videoComponent: video)
            if let mediaScale = adSettings?.mediaScale {
                teadsMediaView?.mediaScale = mediaScale
            }
        }
        nativeAd?.image?.loadImage(async: false) { [weak self] image in
            self?.mappedImages = [GADNativeAdImage(image: image)]
        }

        nativeAd?.icon?.loadImage(async: false) { [weak self] image in
            self?.mappedIcon = GADNativeAdImage(image: image)
        }
    }
}

extension GADMAdapterTeadsNativeAd: TeadsNativeAdPlacementDelegate {
    func didReceiveAd(ad: TeadsNativeAd) {
        nativeAd = ad
        nativeAd?.delegate = self
        nativeAd?.playbackDelegate = self
        loadNativeImages()
        delegate = completionHandler?(self, nil)
        completionHandler = nil
        placement = nil
        adOpportunityView = nil
    }

    func didFailToReceiveAd(reason: AdFailReason) {
        delegate = completionHandler?(nil, reason)
        completionHandler = nil
        placement = nil
    }

    func adOpportunityTrackerView(trackerView: TeadsAdOpportunityTrackerView) {
        adOpportunityView = trackerView
    }
}

extension GADMAdapterTeadsNativeAd: TeadsAdDelegate {
    public func didRecordImpression(ad _: TeadsAd) {
        delegate?.reportImpression()
    }

    public func didRecordClick(ad _: TeadsAd) {
        delegate?.reportClick()
    }

    public func willPresentModalView(ad _: TeadsAd) -> UIViewController? {
        delegate?.willPresentFullScreenView()
        return viewController
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

extension GADMAdapterTeadsNativeAd: TeadsPlaybackDelegate {
    func didPlay(_: TeadsAd) {
        delegate?.didPlayVideo()
    }

    func didPause(_: TeadsAd) {
        delegate?.didPauseVideo()
    }

    func didComplete(_: TeadsAd) {
        delegate?.didEndVideo()
    }

    func adStartPlayingAudio(_: TeadsAd) {
        delegate?.didUnmuteVideo()
    }

    func adStopPlayingAudio(_: TeadsAd) {
        delegate?.didMuteVideo()
    }
}
