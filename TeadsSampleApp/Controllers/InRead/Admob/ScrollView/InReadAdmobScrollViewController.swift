//
//  InReadAdmobScrollViewController.swift
//  TeadsSampleApp
//
//  Copyright © 2018 Teads. All rights reserved.
//

import GoogleMobileAds
import TeadsAdMobAdapter
import TeadsSDK
import UIKit

class InReadAdmobScrollViewController: TeadsViewController {
        
    var bannerView: DFPBannerView!
    @IBOutlet weak var slotView: UIView!
    @IBOutlet weak var slotViewHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 1. Create AdMob view and add it to hierarchy
        bannerView = DFPBannerView(adSize: kGADAdSizeMediumRectangle)
        slotView.addSubview(bannerView)
        
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        bannerView.centerXAnchor.constraint(equalTo: slotView.centerXAnchor).isActive = true
        bannerView.centerYAnchor.constraint(equalTo: slotView.centerYAnchor).isActive = true

        // 2. Attach Delegate (will include Teads events)
        bannerView.adUnitID = pid // Replace with your adunit
        bannerView.rootViewController = self
        bannerView.delegate = self

        // 3. Load a new ad (this will call AdMob and Teads afterward)
        let request = GADRequest()
        let adSettings = TeadsAdSettings { (settings) in
            settings.enableDebug()
            settings.disableLocation()
            try? settings.subscribeAdResizeDelegate(self, forAdView: bannerView)
            // Needed by european regulation
            // See https://mobile.teads.tv/sdk/documentation/ios/gdpr-consent
            //settings.userConsent(subjectToGDPR: "1", consent: "0001100101010101")
            
            // The article url if you are a news publisher
            //settings.pageUrl("http://page.com/article1")
        }
        
        let extras = try? adSettings.toDictionary()
        let customEventExtras = GADCustomEventExtras()
        customEventExtras.setExtras(extras, forLabel: "Teads")

        request.register(customEventExtras)
        
        bannerView.load(request)
    }
    
    private func resizeAd(height: CGFloat) {
        bannerView.resize(GADAdSizeFromCGSize(CGSize(width: slotView.frame.width, height: height)))
        slotViewHeightConstraint.constant = height
    }

}

extension InReadAdmobScrollViewController: GADBannerViewDelegate {
    
    /// Tells the delegate an ad request loaded an ad.
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        // reset the size to "kGADAdSizeMediumRectangle" if a didFailToReceiveAdWithError was triggered before.
        resizeAd(height: bannerView.adSize.size.height)
    }
    
    /// Tells the delegate an ad request failed.
    func adView(_ bannerView: GADBannerView,
                didFailToReceiveAdWithError error: GADRequestError) {
        resizeAd(height: 0)
        print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    
    /// Tells the delegate that a full-screen view will be presented in response
    /// to the user clicking on an ad.
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
        // not used
    }
    
    /// Tells the delegate that the full-screen view will be dismissed.
    func adViewWillDismissScreen(_ bannerView: GADBannerView) {
        // not used
    }
    
    /// Tells the delegate that the full-screen view has been dismissed.
    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
        // not used
    }
    
    /// Tells the delegate that a user click will open another app (such as
    /// the App Store), backgrounding the current app.
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
        // not used
    }
    
}

extension InReadAdmobScrollViewController: TFAMediatedAdViewDelegate {
    
    func didUpdateRatio(_ adView: UIView, ratio: CGFloat) {
        resizeAd(height: slotView.frame.width / ratio)
    }
    
}
