//
//  MPAdapterTeadsBanner.swift
//  TeadsAdMobAdapter
//
//  Created by Jérémy Grosjean on 21/06/2021.
//

import UIKit
import MoPubSDK
import TeadsSDK

@objc(MPAdapterTeadsBanner)
final class MPAdapterTeadsBanner: MPInlineAdAdapter, MPThirdPartyInlineAdAdapter {

    internal var pid: String?
    private var currentBanner: TeadsInReadAdView?
    private var placement: TeadsInReadAdPlacement?

    @objc public override func requestAd(with size: CGSize, adapterInfo info: [AnyHashable: Any], adMarkup: String?) {
        guard let rawPid = info[MPAdapterTeadsConstants.teadsPIDKey] as? String, let pid = Int(rawPid) else {
            let error = TeadsAdapterErrorCode.pidNotFound
            logEvent(MPLogEvent.adLoadFailed(forAdapter: className(), error: error))
            delegate?.inlineAdAdapter(self, didFailToLoadAdWithError: error)
            return
        }
        self.pid = rawPid

        let adSettings = (try? TeadsAdapterSettings.instance(fromMopubParameters: localExtras)) ?? TeadsAdapterSettings()
        adSettings.setIntegation(TeadsAdapterSettings.integrationMopub, version: MoPub.sharedInstance().version())
        currentBanner = TeadsInReadAdView(frame: CGRect(origin: CGPoint.zero, size: Helper.bannerSize(for: size.width)))

        placement = Teads.createInReadPlacement(pid: pid, settings: adSettings.adPlacementSettings, delegate: self)
        placement?.requestAd(requestSettings: adSettings.adRequestSettings)
    }

    private func logEvent(_ event: MPLogEvent) {
        MPLogging.logEvent(event, source: pid, from: Self.self)
    }

}

extension MPAdapterTeadsBanner: TeadsInReadAdPlacementDelegate {

    func didReceiveAd(ad: TeadsInReadAd, adRatio: TeadsAdRatio) {
        logEvent(MPLogEvent.adLoadSuccess(forAdapter: className()))
        logEvent(MPLogEvent.adShowAttempt(forAdapter: className()))
        logEvent(MPLogEvent.adShowSuccess(forAdapter: className()))

        ad.delegate = self
        currentBanner?.bind(ad)
        delegate?.inlineAdAdapter(self, didLoadAdWithAdView: currentBanner)
        currentBanner?.updateHeight(with: adRatio)
    }

    func didFailToReceiveAd(reason: AdFailReason) {
        logEvent(MPLogEvent.adLoadFailed(forAdapter: className(), error: reason))
        delegate?.inlineAdAdapter(self, didFailToLoadAdWithError: reason)
    }

    func adOpportunityTrackerView(trackerView: TeadsAdOpportunityTrackerView) {
        // adOpportunityTrackerView is handled by TeadsSDK
    }

    func didUpdateRatio(ad: TeadsInReadAd, adRatio: TeadsAdRatio) {
        currentBanner?.updateHeight(with: adRatio)
    }

}
extension MPAdapterTeadsBanner: TeadsAdDelegate {
    func didRecordImpression(ad: TeadsAd) {
        delegate?.inlineAdAdapterDidTrackImpression(self)
    }

    func didRecordClick(ad: TeadsAd) {
        delegate?.inlineAdAdapterDidTrackClick(self)
    }

    func willPresentModalView(ad: TeadsAd) -> UIViewController? {
        return delegate?.inlineAdAdapterViewController(forPresentingModalView: self)
    }

    func didCatchError(ad: TeadsAd, error: Error) {
        logEvent(MPLogEvent.adShowFailed(forAdapter: className(), error: error))
    }

    func didClose(ad: TeadsAd) {
        delegate?.inlineAdAdapterDidCollapse(self)
    }

    func didExpandedToFullscreen(ad: TeadsAd) {
        delegate?.inlineAdAdapterWillExpand(self)
    }

    func didCollapsedFromFullscreen(ad: TeadsAd) {
        delegate?.inlineAdAdapterDidCollapse(self)
    }
}
