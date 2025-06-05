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
    var bannerView: AdManagerBannerView!

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

        bannerView = AdManagerBannerView(adSize: GADAdSizeMediumRectangle)
        // FIXME: This id below should be replaced by your own AdMob application and ad block/unit ids
        bannerView.adUnitID = pid
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

extension InReadAdmobWebViewController: BannerViewDelegate {
    func bannerViewDidReceiveAd(_ bannerView: BannerView) {
        print("SampleApp: banner is loaded.")
        webViewHelper?.openSlot(adView: bannerView)
    }

    func bannerView(_: BannerView, didFailToReceiveAdWithError error: Error) {
        print("SampleApp: banner failed to load with error: \(error)")
        webViewHelper?.closeSlot()
    }

    func bannerViewWillPresentScreen(_: BannerView) {
        print("SampleApp: banner will present screen.")
    }

    func bannerViewWillDismissScreen(_: BannerView) {
        print("SampleApp: banner will dismiss screen.")
    }

    func bannerViewDidDismissScreen(_: BannerView) {
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

        let request = Request()
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
