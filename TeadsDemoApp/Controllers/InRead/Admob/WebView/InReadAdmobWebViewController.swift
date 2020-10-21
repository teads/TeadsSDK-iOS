//
//  InReadAdmobWebViewController.swift
//  TeadsDemoApp
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
    var bannerView: DFPBannerView!

    // FIXME This ids should be replaced by your own AdMob application and ad block/unit ids
    let ADMOB_AD_UNIT_ID = "ca-app-pub-3940256099942544/2934735716"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let content = Bundle.main.path(forResource: "demo", ofType: "html"),
            let contentString = try? String(contentsOfFile: content) else {
                return
        }
        webView.navigationDelegate = self
        webView.loadHTMLString(contentString, baseURL: Bundle.main.bundleURL)
        
        bannerView = DFPBannerView(adSize: kGADAdSizeMediumRectangle)
        bannerView.adUnitID = ADMOB_AD_UNIT_ID
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
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("DemoApp: banner is loaded.")
    }
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print("DemoApp: banner failed to load with error: \(error)")
        webSync.webViewHelper.closeSlot()
    }
    
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
        print("DemoApp: banner will present screen.")
    }
    
    func adViewWillDismissScreen(_ bannerView: GADBannerView) {
        print("DemoApp: banner will dismiss screen.")
    }
    
    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
        print("DemoApp: banner did dismiss screen.")
    }
    
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
        print("DemoApp: banner will leave application.")
    }
    
}

extension InReadAdmobWebViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webSync?.injectJS()
    }
    
}
