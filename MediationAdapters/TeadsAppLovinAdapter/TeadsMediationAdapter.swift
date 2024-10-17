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
    private var adSettings: TeadsAdapterSettings?
    weak var nativeDelegate: MANativeAdAdapterDelegate?

    var currentInReadPlacement: TeadsInReadAdPlacement?
    weak var bannerDelegate: MAAdViewAdapterDelegate?
    weak var inReadAdView: TeadsInReadAdView?
    var adFormat: MAAdFormat?

    @objc override func initialize(with _: MAAdapterInitializationParameters, completionHandler: @escaping (MAAdapterInitializationStatus, String?) -> Void) {
        Teads.configure()
        completionHandler(.doesNotApply, nil)
    }

    @objc override var sdkVersion: String {
        Teads.sdkVersion
    }

    @objc override var adapterVersion: String {
        sdkVersion
    }

    @objc override var isBeta: Bool {
        false
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
        self.adSettings = adSettings
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
            if let mediaScale = adSettings?.mediaScale {
                mediaView.mediaScale = mediaScale
            }
            builder.mediaView = mediaView
        }

        nativeDelegate?.didLoadAd(for: nativeAd, withExtraInfo: nil)
    }

    func didFailToReceiveAd(reason: AdFailReason) {
        let maxError = reason.maxError
        nativeDelegate?.didFailToLoadNativeAdWithError(maxError)
        bannerDelegate?.didFailToLoadAdViewAdWithError(maxError)
    }

    func adOpportunityTrackerView(trackerView: TeadsAdOpportunityTrackerView) {
        if nativeDelegate != nil {
            adOpportunityView = trackerView
        }
    }
}

extension TeadsMediationAdapter: TeadsAdDelegate {
    func willPresentModalView(ad _: TeadsAd) -> UIViewController? {
        ALUtils.topViewControllerFromKeyWindow()
    }

    func didRecordClick(ad _: TeadsAd) {
        nativeDelegate?.didClickNativeAd()
        bannerDelegate?.didClickAdViewAd()
    }

    func didRecordImpression(ad _: TeadsAd) {
        let event = ["event": "impression"]
        nativeDelegate?.didDisplayNativeAd(withExtraInfo: event)
        bannerDelegate?.didDisplayAdViewAd(withExtraInfo: event)
    }

    func didCatchError(ad _: TeadsAd, error: Error) {
        let maxError = MAAdapterError(adapterError: .init(nsError: error), mediatedNetworkErrorCode: error._code, mediatedNetworkErrorMessage: error.localizedDescription)
        bannerDelegate?.didFailToDisplayAdViewAdWithError(maxError)
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

extension AdFailReason {
    var maxError: MAAdapterError {
        switch code {
            case .errorNetwork:
                return .noConnection
            case .errorBadResponse:
                return .invalidConfiguration
            case .errorVastError:
                return .adDisplayFailedError
            case .errorInternal:
                return .internalError
            case .disabledApp, .errorUserIdMissing, .errorNoSlot:
                return .invalidConfiguration
            case .errorAdRequest:
                return .badRequest
            default:
                return .noFill
        }
    }
}
