//
//  InReadDirectWebViewController.swift
//  TeadsSampleApp
//
//  Created by Jérémy Grosjean on 02/10/2017.
//  Copyright © 2018 Teads. All rights reserved.
//

import TeadsSDK
import UIKit
import WebKit

class InReadDirectWebViewController: TeadsViewController, WKNavigationDelegate {
    @IBOutlet var webView: WKWebView!
    var webViewHelper: TeadsWebViewHelper?

    var placement: TeadsInReadAdPlacement?

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let content = Bundle.main.path(forResource: "sample", ofType: "html"),
              let contentString = try? String(contentsOfFile: content) else {
            return
        }
        let contentStringWithIntegrationType = contentString.replacingOccurrences(of: "{INTEGRATION_TYPE}", with: "InRead Direct WebView Integration")

        // The html identifier where you want your slot to open`
        let domCSSSlotSelector = "#teads-placement-slot"
        webView.navigationDelegate = self
        webView.loadHTMLString(contentStringWithIntegrationType, baseURL: Bundle.main.bundleURL)

        /// init helper
        webViewHelper = TeadsWebViewHelper(webView: webView, selector: domCSSSlotSelector, delegate: self)

        let pSettings = TeadsAdPlacementSettings { _ in
            // settings.enableDebug()
        }

        // keep a strong reference to placement instance
        placement = Teads.createInReadPlacement(pid: Int(pid) ?? 0, settings: pSettings, delegate: self)
    }

    // MARK: WKNavigationDelegate

    func webView(_: WKWebView, didFinish _: WKNavigation!) {
        print("injectJS")
        webViewHelper?.injectJS()
    }
}

extension InReadDirectWebViewController: TeadsInReadAdPlacementDelegate {
    func didUpdateRatio(ad _: TeadsInReadAd, adRatio: TeadsAdRatio) {
        // update slot with the right ratio
        webViewHelper?.updateSlot(adRatio: adRatio)
        print("didUpdateRatio")
    }

    func didReceiveAd(ad: TeadsInReadAd, adRatio: TeadsAdRatio) {
        // open the slot
        webViewHelper?.openSlot(ad: ad, adRatio: adRatio)
        print("didReceiveAd")
        ad.playbackDelegate = self
        ad.delegate = self
    }

    func didFailToReceiveAd(reason: AdFailReason) {
        print("didFailToReceiveAd \(reason.localizedDescription)")
    }

    func adOpportunityTrackerView(trackerView: TeadsAdOpportunityTrackerView) {
        webViewHelper?.setAdOpportunityTrackerView(trackerView)
    }
}

extension InReadDirectWebViewController: TeadsAdDelegate {
    func didClose(ad _: TeadsAd) {
        webViewHelper?.closeSlot()
    }

    func didRecordImpression(ad _: TeadsAd) {}

    func didRecordClick(ad _: TeadsAd) {}

    func willPresentModalView(ad _: TeadsAd) -> UIViewController? {
        print("willPresentModalView")
        return self
    }

    func didCatchError(ad _: TeadsAd, error: Error) {
        print("didCatchError \(error.localizedDescription)")
    }
}

extension InReadDirectWebViewController: TeadsPlaybackDelegate {
    func adStartPlayingAudio(_: TeadsAd) {
        print("adStartPlayingAudio")
    }

    func adStopPlayingAudio(_: TeadsAd) {
        print("adStopPlayingAudio")
    }
}

extension InReadDirectWebViewController: TeadsWebViewHelperDelegate {
    func webViewHelperSlotStartToShow() {
        print("webViewHelperSlotStartToShow")
    }

    func webViewHelperSlotStartToHide() {
        print("webViewHelperSlotStartToHide")
    }

    func webViewHelperSlotFoundSuccessfully() {
        print("webViewHelperSlotFoundSuccessfully")
        placement?.requestAd(requestSettings: TeadsAdRequestSettings { settings in
            settings.pageUrl("https://www.teads.tv")
        })
    }

    func webViewHelperSlotNotFound() {
        print("webViewHelperSlotNotFound")
    }

    func webViewHelperOnError(error: String) {
        print("webViewHelperOnError \(error)")
    }
}
