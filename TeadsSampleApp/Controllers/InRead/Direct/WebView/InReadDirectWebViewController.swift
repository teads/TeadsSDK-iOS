//
//  InReadDirectWebViewController.swift
//  TeadsSampleApp
//
//  Created by Jérémy Grosjean on 02/10/2017.
//  Copyright © 2018 Teads. All rights reserved.
//

import UIKit
import WebKit
import TeadsSDK

class InReadDirectWebViewController: TeadsViewController, WKNavigationDelegate {

    @IBOutlet weak var webView: WKWebView!
    var webViewHelper: TeadsWebViewHelper?
    
    var placement: TeadsInReadAdPlacement?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let content = Bundle.main.path(forResource: "sample", ofType: "html"),
            let contentString = try? String(contentsOfFile: content) else {
                return
        }
        let contentStringWithIntegrationType = contentString.replacingOccurrences(of: "{INTEGRATION_TYPE}", with: "InRead Direct WebView Integration")
        webView.navigationDelegate = self
        webView.loadHTMLString(contentStringWithIntegrationType, baseURL: Bundle.main.bundleURL)
        
        
        /// init helper
        webViewHelper = TeadsWebViewHelper(webView: webView, selector: "#teads-placement-slot", delegate: self)
        
        let pSettings = TeadsAdPlacementSettings { (settings) in
            //settings.enableDebug()
        }
        placement = Teads.createInReadPlacement(pid: Int(pid) ?? 0, settings: pSettings, delegate: self)
        
        placement?.requestAd(requestSettings: TeadsAdRequestSettings { settings in
            settings.pageUrl("https://www.teads.tv")
        })
        
    }
    
    // MARK: WKNavigationDelegate
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("injectJS")
        webViewHelper?.injectJS()
    }
}

extension InReadDirectWebViewController: TeadsInReadAdPlacementDelegate {
    
    func didUpdateRatio(ad: TeadsInReadAd, adRatio: TeadsAdRatio) {
        //update slot with the right ratio
        webViewHelper?.updateSlot(adRatio: adRatio)
        print("didUpdateRatio")
    }
    
    func didReceiveAd(ad: TeadsInReadAd, adRatio: TeadsAdRatio) {
        //open the slot
        webViewHelper?.openSlot(ad: ad, adRatio: adRatio)
        print("didReceiveAd")
        ad.playbackDelegate = self
        ad.delegate = self
    }
    
    func didFailToReceiveAd(reason: AdFailReason) {
        print("didFailToReceiveAd \(reason.localizedDescription)")
    }
    
    func adOpportunityTrackerView(trackerView: TeadsAdOpportunityTrackerView) {
        self.webViewHelper?.setAdOpportunityTrackerView(trackerView)
    }
}

extension InReadDirectWebViewController: TeadsAdDelegate {
    
    func didClose(ad: TeadsAd) {
        self.webViewHelper?.closeSlot()
    }
    
    func didRecordImpression(ad: TeadsAd) {
        
    }
    
    func didRecordClick(ad: TeadsAd) {
        
    }
    
    func willPresentModalView(ad: TeadsAd) -> UIViewController? {
        print("willPresentModalView")
        return self
    }
    
    func didCatchError(ad: TeadsAd, error: Error) {
        print("didCatchError \(error.localizedDescription)")
    }
}

extension InReadDirectWebViewController: TeadsPlaybackDelegate {
    func adStartPlayingAudio(_ ad: TeadsAd) {
        print("adStartPlayingAudio")
    }
    
    func adStopPlayingAudio(_ ad: TeadsAd) {
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
    
    func webViewHelperSlotNotFound() {
        print("webViewHelperSlotNotFound")
    }
    
    func webViewHelperOnError(error: String) {
        print("webViewHelperOnError \(error)")
    }
}
