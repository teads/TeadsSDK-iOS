//
//  TeadsMediationAdapter.swift
//  TeadsAppLovinAdapter
//
//  Created by Paul Nicolas on 15/02/2022.
//

import AppLovinSDK
import TeadsSDK
import UIKit

@objc(TeadsMediationAdapter)
final class TeadsMediationAdapter: ALMediationAdapter {
    var currentObserver: NSKeyValueObservation?

    var adOpportunityView: TeadsAdOpportunityTrackerView?

    var currentNativePlacement: TeadsNativeAdPlacement?
    var nativeAd: TeadsNativeAd?
    weak var nativeDelegate: MANativeAdAdapterDelegate?

    var currentInReadPlacement: TeadsInReadAdPlacement?
    weak var bannerDelegate: MAAdViewAdapterDelegate?
    weak var inReadAdView: TeadsInReadAdView?
    var adFormat: MAAdFormat?

    @objc override func initialize(with _: MAAdapterInitializationParameters, completionHandler: @escaping (MAAdapterInitializationStatus, String?) -> Void) {
        Teads.configure()
        
        completionHandler(.doesNotApply, nil)
    }

    @objc public override var sdkVersion: String {
        return Teads.sdkVersion
    }

    @objc public override var adapterVersion: String {
        return Teads.sdkVersion
    }

    @objc public override var isBeta: Bool {
        return false
    }

    override func destroy() {
        currentNativePlacement = nil
        nativeAd = nil

        currentInReadPlacement = nil
        inReadAdView = nil

        currentObserver?.invalidate()
        currentObserver = nil
    }

    deinit {
        destroy()
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
        self.adFormat = adFormat
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
    func didReceiveAd(ad: TeadsInReadAd, adRatio _: TeadsAdRatio) {
        let adView = TeadsInReadAdView(bind: ad)
        inReadAdView = adView
        bannerDelegate?.didLoadAd(forAdView: adView)
        // adOpportunityView = nil

        currentObserver = inReadAdView?.observe(\.center, options: NSKeyValueObservingOptions.new, changeHandler: { [weak self] adView, _ in
            guard let bannerView = adView.superview,
                  let adFormat = self?.adFormat else {
                self?.currentObserver?.invalidate()
                return
            }

            if adFormat == .mrec {
                guard let fixedHeightConstraint = bannerView.constraints.first(where: { $0.firstAttribute == .height }),
                      let fixedWidthConstraint = bannerView.constraints.first(where: { $0.firstAttribute == .width }) else {
                    return
                }

                bannerView.removeConstraints([fixedHeightConstraint, fixedWidthConstraint])
                adView.bottomAnchor.constraint(equalTo: bannerView.bottomAnchor, constant: 0).isActive = true
                adView.widthAnchor.constraint(equalTo: bannerView.widthAnchor, multiplier: 1).isActive = true
            } else {
                guard let fixedHeightConstraint = bannerView.constraints.first(where: { $0.firstAttribute == .height }) else {
                    return
                }

                bannerView.removeConstraint(fixedHeightConstraint)
                adView.bottomAnchor.constraint(equalTo: bannerView.bottomAnchor, constant: 0).isActive = true
            }

            self?.currentObserver?.invalidate()
            self?.currentObserver = nil
        })
    }

    func didUpdateRatio(ad _: TeadsInReadAd, adRatio: TeadsAdRatio) {
        inReadAdView?.updateHeight(with: adRatio)
    }
}

extension TeadsMediationAdapter: TeadsNativeAdPlacementDelegate {
    func didReceiveAd(ad: TeadsNativeAd) {
        guard let mediaComponent = ad.video ?? ad.image else {
            nativeDelegate?.didFailToLoadNativeAdWithError(.missingRequiredNativeAdAssets)
            return
        }
        nativeAd = ad
        ad.delegate = self

        let nativeAd = AppLovinTeadsNativeAd(parent: self) { builder in
            if let title = ad.title?.text {
                builder.title = title
            }
            builder.advertiser = ad.sponsored?.text
            builder.body = ad.content?.text
            builder.callToAction = ad.callToAction?.text

            ad.icon?.loadImage { icon in
                builder.icon = MANativeAdImage(image: icon)
            }

            builder.optionsView = TeadsAdChoicesView(binding: ad.adChoices)

            let mediaView = TeadsMediaView()
            mediaView.bind(component: mediaComponent)
            builder.mediaView = mediaView
        }

        nativeDelegate?.didLoadAd(for: nativeAd, withExtraInfo: nil)
    }

    public func didFailToReceiveAd(reason: AdFailReason) {
        nativeDelegate?.didFailToLoadNativeAdWithError(MAAdapterError(adapterError: .noFill, thirdPartySdkErrorCode: reason.errorCode, thirdPartySdkErrorMessage: reason.localizedDescription))
        bannerDelegate?.didFailToLoadAdViewAdWithError(MAAdapterError(adapterError: .noFill, thirdPartySdkErrorCode: reason.errorCode, thirdPartySdkErrorMessage: reason.localizedDescription))
    }

    func adOpportunityTrackerView(trackerView: TeadsAdOpportunityTrackerView) {
        if nativeDelegate != nil {
            adOpportunityView = trackerView
        }
    }
}

extension TeadsMediationAdapter: TeadsAdDelegate {
    func willPresentModalView(ad _: TeadsAd) -> UIViewController? {
        return ALUtils.topViewControllerFromKeyWindow()
    }

    func didRecordClick(ad _: TeadsAd) {
        nativeDelegate?.didClickNativeAd()
        bannerDelegate?.didClickAdViewAd()
    }

    func didRecordImpression(ad _: TeadsAd) {
        nativeDelegate?.didDisplayNativeAd(withExtraInfo: ["event": "impression"])
        bannerDelegate?.didDisplayAdViewAd(withExtraInfo: ["event": "impression"])
    }

    func didCatchError(ad _: TeadsAd, error: Error) {
        bannerDelegate?.didFailToDisplayAdViewAdWithError(MAAdapterError(adapterError: .noConnection, thirdPartySdkErrorCode: error._code, thirdPartySdkErrorMessage: error.localizedDescription))
    }

    func didClose(ad _: TeadsAd) {
        bannerDelegate?.didHideAdViewAd()
    }

    func didExpandedToFullscreen(ad _: TeadsAd) {
        bannerDelegate?.didExpandAdViewAd()
    }

    func didCollapsedFromFullscreen(ad _: TeadsAd) {
        bannerDelegate?.didCollapseAdViewAd()
    }
}
