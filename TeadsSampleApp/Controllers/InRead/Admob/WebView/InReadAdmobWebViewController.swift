//
//  InReadAdmobWebViewController.swift
//  TeadsSampleApp
//
//  Created by Jérémy Grosjean on 03/07/2019.
//  Copyright © 2019 Teads. All rights reserved.
//

import GoogleMobileAds
import TeadsAdMobAdapter
import TeadsSDK
import UIKit
import WebKit

class InReadAdmobWebViewController: TeadsViewController {
    @IBOutlet var webView: WKWebView!
    var webViewHelper: TeadsWebViewHelper?
    var bannerView: GAMBannerView!

    // FIXME: This ids should be replaced by your own AdMob application and ad block/unit ids
    let ADMOB_AD_UNIT_ID = "ca-app-pub-3940256099942544/2934735716"

    override func viewDidLoad() {
        super.viewDidLoad()

        /// init helper before loading html content
        webViewHelper = TeadsWebViewHelper(webView: webView, selector: "#teads-placement-slot", delegate: self)

        guard let content = Bundle.main.path(forResource: "sample", ofType: "html"),
              let contentString = try? String(contentsOfFile: content) else {
            return
        }
        let contentStringWithIntegrationType = contentString.replacingOccurrences(of: "{INTEGRATION_TYPE}", with: "InRead Admob WebView Integration")

        webView.loadHTMLString(contentStringWithIntegrationType, baseURL: Bundle.main.bundleURL)

        bannerView = GAMBannerView(adSize: GADAdSizeMediumRectangle)
        bannerView.adUnitID = pid // Replace with your adunit
        bannerView.rootViewController = self
        bannerView.delegate = self
    }
}

extension InReadAdmobWebViewController: TeadsMediatedAdViewDelegate {
    public func didUpdateRatio(_: UIView, adRatio: TeadsAdRatio) {
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

    func bannerView(_: GADBannerView, didFailToReceiveAdWithError error: Error) {
        print("SampleApp: banner failed to load with error: \(error)")
        webViewHelper?.closeSlot()
    }

    func bannerViewWillPresentScreen(_: GADBannerView) {
        print("SampleApp: banner will present screen.")
    }

    func bannerViewWillDismissScreen(_: GADBannerView) {
        print("SampleApp: banner will dismiss screen.")
    }

    func bannerViewDidDismissScreen(_: GADBannerView) {
        print("SampleApp: banner did dismiss screen.")
    }
}

extension InReadAdmobWebViewController: TeadsWebViewHelperDelegate {
    func webViewHelperSlotStartToShow() {
        print("webViewHelperSlotStartToShow")
    }

    func webViewHelperSlotStartToHide() {
        print("webViewHelperSlotStartToHide")
    }

    func webViewHelperSlotFoundSuccessfully() {
        print("webViewHelperSlotFoundSuccessfully")
        let adSettings = TeadsAdapterSettings { settings in
            settings.enableDebug()
            try? settings.registerAdView(bannerView, delegate: self)

            // Needed by european regulation
            // See https://mobile.teads.tv/sdk/documentation/ios/gdpr-consent
            // settings.userConsent(subjectToGDPR: "1", consent: "0001100101010101")

            // The article url if you are a news publisher
            // settings.pageUrl("http://page.com/article1")
        }

        let request = GADRequest()
        request.register(adSettings)

        bannerView.load(request)
    }

    func webViewHelperSlotNotFound() {
        print("webViewHelperSlotNotFound")
    }

    func webViewHelperOnError(error: String) {
        print("webViewHelperOnError \(error)")
    }
}
