//
//  InReadAdmobWebViewController.swift
//  TeadsSampleApp
//
//  Created by Jérémy Grosjean on 03/07/2019.
//  Copyright © 2019 Teads. All rights reserved.
//

import UIKit
import WebKit
import GoogleMobileAds
import TeadsSDK
import TeadsAdMobAdapter

class InReadAdmobWebViewController: TeadsViewController {

    @IBOutlet weak var webView: WKWebView!
    var webViewHelper: TeadsWebViewHelper?
    var bannerView: GAMBannerView!

    // FIXME This ids should be replaced by your own AdMob application and ad block/unit ids
    let ADMOB_AD_UNIT_ID = "ca-app-pub-3940256099942544/2934735716"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let content = Bundle.main.path(forResource: "sample", ofType: "html"),
            let contentString = try? String(contentsOfFile: content) else {
                return
        }
        let contentStringWithIntegrationType = contentString.replacingOccurrences(of: "{INTEGRATION_TYPE}", with: "InRead Admob WebView Integration")
        webView.navigationDelegate = self
        webView.loadHTMLString(contentStringWithIntegrationType, baseURL: Bundle.main.bundleURL)
        
        bannerView = GAMBannerView(adSize: GADAdSizeMediumRectangle)
        bannerView.adUnitID = pid // Replace with your adunit
        bannerView.rootViewController = self
        bannerView.delegate = self
        
        /// init helper
        webViewHelper = TeadsWebViewHelper(webView: webView, selector: "#teads-placement-slot", delegate: self)
        
        let adSettings = TeadsAdapterSettings { (settings) in
            settings.enableDebug()
            settings.disableLocation()
            try? settings.registerAdView(bannerView, delegate: self)

            // Needed by european regulation
            // See https://mobile.teads.tv/sdk/documentation/ios/gdpr-consent
            //settings.userConsent(subjectToGDPR: "1", consent: "0001100101010101")
            
            // The article url if you are a news publisher
            //settings.pageUrl("http://page.com/article1")
        }
        
        let customEventExtras = GADMAdapterTeads.customEventExtra(with: adSettings)
        
        let request = GADRequest()
        request.register(customEventExtras)

        bannerView.load(request)
    }

}

extension InReadAdmobWebViewController: TeadsMediatedAdViewDelegate {
    public func didUpdateRatio(_ adView: UIView, adRatio: TeadsAdRatio) {
        guard let webViewHelper = webViewHelper else {
            return
        }
        bannerView?.resize(GADAdSize(size: CGSize(width: webViewHelper.adViewHTMLElementWidth, height: adRatio.calculateHeight(for: webViewHelper.adViewHTMLElementWidth)), flags: 1))
       webViewHelper.updateSlot(adRatio: adRatio)
    }
}

extension InReadAdmobWebViewController: GADBannerViewDelegate {
    
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("SampleApp: banner is loaded.")
        webViewHelper?.openSlot(adView: bannerView)
    }
    
    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
        print("SampleApp: banner failed to load with error: \(error)")
        webViewHelper?.closeSlot()
    }
    
    func bannerViewWillPresentScreen(_ bannerView: GADBannerView) {
        print("SampleApp: banner will present screen.")
    }
    
    func bannerViewWillDismissScreen(_ bannerView: GADBannerView) {
        print("SampleApp: banner will dismiss screen.")
    }
    
    func bannerViewDidDismissScreen(_ bannerView: GADBannerView) {
        print("SampleApp: banner did dismiss screen.")
    }
    
}

extension InReadAdmobWebViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webViewHelper?.injectJS()
    }
    
}

extension InReadAdmobWebViewController: TeadsWebViewHelperDelegate {
    func webViewHelperSlotStartToShow() {
        print("webViewHelperSlotStartToShow")
    }
    
    func webViewHelperSlotStartToHide() {
        print("webViewHelperSlotStartToHide")
    }
    
    func webViewHelperSlotNotFound() {
        print("webViewHelperSlotNotFound")
    }
    
    func webViewHelperOnError(error: String) {
        print("webViewHelperOnError \(error)")
    }
}
