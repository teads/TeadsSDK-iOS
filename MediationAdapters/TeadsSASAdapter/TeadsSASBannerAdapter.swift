//
//  TeadsSASBannerAdapter.swift
//
//  Created by Jérémy Grosjean on 29/06/2021.
//

import UIKit
import SASDisplayKit
import TeadsSDK

@objc open class TeadsSASBannerAdapter: NSObject, SASMediationBannerAdapter {
    
    @objc public weak var delegate: SASMediationBannerAdapterDelegate?
    private var currentBanner: TeadsInReadAdView?
    private var placement: TeadsInReadAdPlacement?
    private weak var controller: UIViewController?
    
    @objc required public init(delegate: SASMediationBannerAdapterDelegate) {
        super.init()
        self.delegate = delegate
    }
    
    @objc public func requestBanner(withServerParameterString serverParameterString: String, clientParameters: [AnyHashable: Any], viewController: UIViewController) {
        controller = viewController
        
        guard let serverParameter = ServerParameter.instance(from: serverParameterString) else {
            delegate?.mediationBannerAdapter(self, didFailToLoadWithError: TeadsSASErrors.serverParameterError, noFill: false)
            return
        }
        
        guard let pid = serverParameter.placementId else {
            delegate?.mediationBannerAdapter(self, didFailToLoadWithError: TeadsSASErrors.noPidError, noFill: false)
            return
        }
        
        let adSettings = serverParameter.adSettings
        addExtrasToAdSettings(adSettings)
        let adViewSize = clientParameters["adViewSize"] as? CGSize ?? viewController.view.bounds.size
                
        currentBanner = TeadsInReadAdView(frame: CGRect(origin: .zero, size: Helper.bannerSize(for: adViewSize.width)))
        
        placement = Teads.createInReadPlacement(pid: pid, settings: adSettings.adPlacementSettings, delegate: self)
        placement?.requestAd(requestSettings: adSettings.adRequestSettings)
    }
    
    private func addExtrasToAdSettings(_ adSettings: TeadsAdapterSettings) {
        adSettings.addExtras(TeadsAdapterSettings.integrationTypeKey, for: TeadsAdapterSettings.integrationSAS)
        let sasVersion = Bundle.init(for: SASAdPlacement.self).infoDictionary?["CFBundleShortVersionString"] as? String ?? "unknown"
        adSettings.addExtras(TeadsAdapterSettings.integrationVersionKey, for: sasVersion)
    }
    
}



extension TeadsSASBannerAdapter: TeadsInReadAdPlacementDelegate {
    
    public func didReceiveAd(ad: TeadsInReadAd, adRatio: TeadsAdRatio) {
        ad.delegate = self
        currentBanner?.bind(ad)
        currentBanner?.updateHeight(with: adRatio)
        if let banner = currentBanner {
            delegate?.mediationBannerAdapter(self, didLoadBanner: banner)
        } else {
            delegate?.mediationBannerAdapter(self, didFailToLoadWithError: TeadsSASErrors.loadError, noFill: false)
        }
    }
    
    public func didFailToReceiveAd(reason: AdFailReason) {
        delegate?.mediationBannerAdapter(self, didFailToLoadWithError: TeadsSASErrors.noFillError, noFill: true)
    }
    
    public func didUpdateRatio(ad: TeadsInReadAd, adRatio: TeadsAdRatio) {
        currentBanner?.updateHeight(with: adRatio)
    }
    
    public func adOpportunityTrackerView(trackerView: TeadsAdOpportunityTrackerView) {
        
    }
    
}
extension TeadsSASBannerAdapter: TeadsAdDelegate {
    public func didRecordImpression(ad: TeadsAd) {
        
    }
    
    public func didRecordClick(ad: TeadsAd) {
        delegate?.mediationBannerAdapterDidReceiveAdClickedEvent(self)
    }
    
    public func willPresentModalView(ad: TeadsAd) -> UIViewController? {
        delegate?.mediationBannerAdapterWillPresentModalView(self)
        return controller
    }
    
    public func didCatchError(ad: TeadsAd, error: Error) {
        
    }
    
    public func didCloseAd(ad: TeadsAd) {
        
    }
    
}
