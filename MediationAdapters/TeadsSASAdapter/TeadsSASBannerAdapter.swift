//
//  TeadsSASBannerAdapter.swift
//  TeadsSASAdapter
//
//  Created by Jérémy Grosjean on 29/06/2021.
//

import SASDisplayKit
import TeadsSDK
import UIKit

@objc(TeadsSASBannerAdapter)
final class TeadsSASBannerAdapter: NSObject, SASMediationBannerAdapter {
    @objc public weak var delegate: SASMediationBannerAdapterDelegate?
    private var currentBanner: TeadsInReadAdView?
    private var placement: TeadsInReadAdPlacement?
    private weak var controller: UIViewController?
    private var adSettings: TeadsAdapterSettings?

    @objc public required init(delegate: SASMediationBannerAdapterDelegate) {
        super.init()
        self.delegate = delegate
    }

    @objc public func requestBanner(withServerParameterString serverParameterString: String, clientParameters: [AnyHashable: Any], viewController: UIViewController) {
        controller = viewController

        guard let serverParameter = ServerParameter.instance(from: serverParameterString) else {
            delegate?.mediationBannerAdapter(self, didFailToLoadWithError: TeadsAdapterErrorCode.serverParameterError, noFill: false)
            return
        }

        guard let pid = serverParameter.placementId else {
            delegate?.mediationBannerAdapter(self, didFailToLoadWithError: TeadsAdapterErrorCode.pidNotFound, noFill: false)
            return
        }

        let adSettings = serverParameter.adSettings
        Self.addExtrasToAdSettings(adSettings)
        self.adSettings = adSettings
        let adViewSize = clientParameters["adViewSize"] as? CGSize ?? viewController.view.bounds.size

        currentBanner = TeadsInReadAdView(frame: CGRect(origin: .zero, size: Helper.bannerSize(for: adViewSize.width)))

        placement = Teads.createInReadPlacement(pid: pid, settings: adSettings.adPlacementSettings, delegate: self)
        placement?.requestAd(requestSettings: adSettings.adRequestSettings)
    }

    static func addExtrasToAdSettings(_ adSettings: TeadsAdapterSettings) {
        let sasVersion = Bundle(for: SASAdPlacement.self).infoDictionary?["CFBundleShortVersionString"] as? String ?? "unknown"
        adSettings.setIntegation(TeadsAdapterSettings.integrationSAS, version: sasVersion)
    }
}

extension TeadsSASBannerAdapter: TeadsInReadAdPlacementDelegate {
    public func didReceiveAd(ad: TeadsInReadAd, adRatio: TeadsAdRatio) {
        ad.delegate = self
        currentBanner?.bind(ad)
        if adSettings?.hasSubscribedToAdResizing ?? false {
            currentBanner?.updateHeight(with: adRatio)
        }
        if let banner = currentBanner {
            delegate?.mediationBannerAdapter(self, didLoadBanner: banner)
        } else {
            delegate?.mediationBannerAdapter(self, didFailToLoadWithError: TeadsAdapterErrorCode.loadError, noFill: false)
        }
    }

    public func didFailToReceiveAd(reason: AdFailReason) {
        delegate?.mediationBannerAdapter(self, didFailToLoadWithError: reason, noFill: reason.isNoFill)
    }

    public func didUpdateRatio(ad _: TeadsInReadAd, adRatio: TeadsAdRatio) {
        if adSettings?.hasSubscribedToAdResizing ?? false {
            currentBanner?.updateHeight(with: adRatio)
        }
    }

    public func adOpportunityTrackerView(trackerView _: TeadsAdOpportunityTrackerView) {
        // adOpportunityTrackerView is handled by TeadsSDK
    }
}

extension TeadsSASBannerAdapter: TeadsAdDelegate {
    public func didRecordImpression(ad _: TeadsAd) {
        // not handled by SASDisplayKit
    }

    public func didRecordClick(ad _: TeadsAd) {
        delegate?.mediationBannerAdapterDidReceiveAdClickedEvent(self)
    }

    public func willPresentModalView(ad _: TeadsAd) -> UIViewController? {
        delegate?.mediationBannerAdapterWillPresentModalView(self)
        return controller
    }

    public func didCatchError(ad _: TeadsAd, error: Error) {
        delegate?.mediationBannerAdapter(self, didFailToLoadWithError: error, noFill: false)
    }

    public func didClose(ad _: TeadsAd) {
        // not handled by SASDisplayKit
    }

    public func didExpandedToFullscreen(ad _: TeadsAd) {
        delegate?.mediationBannerAdapterWillPresentModalView(self)
    }

    public func didCollapsedFromFullscreen(ad _: TeadsAd) {
        delegate?.mediationBannerAdapterWillDismissModalView(self)
    }
}

extension AdFailReason {
    var isNoFill: Bool {
        return code == .errorNotFilled
    }
}
