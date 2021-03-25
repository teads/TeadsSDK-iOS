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
import TeadsAdMobAdapter
import TeadsSDK

class InReadAdmobWebViewController: TeadsViewController {

    @IBOutlet weak var webView: WKWebView!
    var webSync: SyncWebViewAdView!
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
        
        bannerView = GAMBannerView(adSize: kGADAdSizeMediumRectangle)
        bannerView.adUnitID = pid // Replace with your adunit
        bannerView.rootViewController = self
        bannerView.delegate = self
        
        webSync = SyncWebViewAdView(webView: webView, selector: "#teads-placement-slot", adView: bannerView)
        
        let request = GADRequest()
        let adSettings = TeadsAdSettings { (settings) in
            settings.enableDebug()
            settings.disableLocation()
            try? settings.subscribeAdResizeDelegate(webSync, forAdView: bannerView)

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

}

extension InReadAdmobWebViewController: GADBannerViewDelegate {
    
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("SampleApp: banner is loaded.")
    }
    
    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
        print("SampleApp: banner failed to load with error: \(error)")
        webSync.webViewHelper.closeSlot()
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
        webSync?.injectJS()
    }
    
}
