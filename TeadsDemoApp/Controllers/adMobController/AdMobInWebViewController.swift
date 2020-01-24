//
//  AdMobInWebViewController.swift
//  TeadsDemoApp
//
//  Created by Jérémy Grosjean on 03/07/2019.
//  Copyright © 2019 Teads. All rights reserved.
//

import UIKit
import WebKit
import GoogleMobileAds
import TeadsAdMobAdapter

class AdMobInWebViewController: UIViewController, WKNavigationDelegate, GADBannerViewDelegate {

    @IBOutlet weak var webView: WKWebView!
    var webSync: SyncWebViewAdView!
    var bannerView: GADBannerView!

    // FIXME This ids should be replaced by your own AdMob application and ad block/unit ids
    let ADMOB_AD_UNIT_ID = "ca-app-pub-3570580224725271/5615499706"
    
    private var currentBanner: GADBannerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let content = Bundle.main.path(forResource: "index", ofType: "html"),
            let contentString = try? String(contentsOfFile: content) else {
                return
        }
        self.webView.navigationDelegate = self
        self.webView.loadHTMLString(contentString, baseURL: nil)
        
        self.bannerView = GADBannerView(adSize: kGADAdSizeMediumRectangle)
        self.bannerView.translatesAutoresizingMaskIntoConstraints = false
        self.bannerView.adUnitID = ADMOB_AD_UNIT_ID
        self.bannerView.rootViewController = self
        self.bannerView.delegate = self
        
        let request = GADRequest()
        let teadsExtras = GADMAdapterTeadsExtras()
        // Needed by european regulation
        // See https://mobile.teads.tv/sdk/documentation/ios/gdpr-consent
        //        teadsExtras.subjectToGDPR = "1"
        //        teadsExtras.consent = "0001100101010101"
        
        // The article url if you are a news publisher
        //teadsExtras.pageUrl = "http://page.com/article1"
        
        request.register(teadsExtras.getCustomEventExtras(forCustomEventLabel: "Teads"))
        self.bannerView.load(request)
        self.webSync = SyncWebViewAdView(webView: self.webView, selector: "#my-placement-id", adView: self.bannerView)
    }
    
    // MARK: - GADBannerViewDelegate Protocol
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("DemoApp: banner is loaded.")
    }
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print("DemoApp: banner failed to load with error: \(error)")
        self.currentBanner = nil
        self.webSync.webViewHelper.closeSlot()
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
    
    // MARK: -
    // MARK: WKNavigationDelegate
    // MARK: -
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.webSync?.injectJS()
    }

}
