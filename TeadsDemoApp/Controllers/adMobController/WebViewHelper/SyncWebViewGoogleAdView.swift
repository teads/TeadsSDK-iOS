//
//  SyncWebViewGoogleAdView.swift
//  TeadsApp
//
//  Created by Jérémy Grosjean on 20/05/2019.
//  Copyright © 2019 Teads. All rights reserved.
//

import UIKit
import GoogleMobileAds
import TeadsAdMobAdapter
import WebKit

class SyncWebViewGoogleAdView: NSObject, WebViewHelperDelegate {

    weak var webView: WKWebView?
    weak var admobBannerView: GADBannerView?
    var webViewHelper: WebViewHelper
    var isLoaded = false
    var adViewConstraints = [NSLayoutConstraint]()
    var bannerSize: GADAdSize
    
    public init(webView: WKWebView, selector: String, admobBannerView: GADBannerView, bannerSize: GADAdSize) {
        self.webViewHelper = WebViewHelper(webView: webView, selector: selector)
        self.admobBannerView = admobBannerView
        self.webView = webView
        self.bannerSize = bannerSize
        super.init()
        self.webViewHelper.delegate = self
    }
    
    deinit {
        self.webViewHelper.clean()
    }
    
    public func injectJS() {
        //Inject the js in your webview when the webview is ready
        self.webViewHelper.injectJS()
    }
    
    // MARK: WebViewHelperDelegate
    
    public func webViewHelperJSIsReady() {
        self.webViewHelper.openSlot()
        // Landscape ads are 16/9, setting the ratio to 16/10 give more space to display the ads and result in a better looking square ads
        self.webViewHelper.updateSlot(adRatio: 16/10)
    }
    public func webViewHelperSlotStartToShow() {
        
    }
    
    public func webViewHelperSlotStartToHide() {
        
    }
    
    func webViewHelperSlotNotFound() {
        
    }
    
    func webViewHelperOnError(error: String) {
        
    }
    
    public func webViewHelperUpdatedSlot(left: Int, top: Int, right: Int, bottom: Int) {
        // if the adView is not already loaded load it and add it to the scrollView of your webview
        if let admobBannerView = self.admobBannerView, let webView = self.webView {
            if !self.isLoaded {
                self.isLoaded = true
                webView.scrollView.addSubview(admobBannerView)
                admobBannerView.translatesAutoresizingMaskIntoConstraints = false
            }
            //change the constraint according to coordonate that the delegate send us
            self.customAdViewConstraint(left: left, top: top, right: right, bottom: bottom)
        }
    }
    
    /// change the constraint of the ad so it follows what the bootstrap ask
    func customAdViewConstraint(left: Int, top: Int, right: Int, bottom: Int) {
        if let admobBannerView = self.admobBannerView, let webView = self.webView {
            NSLayoutConstraint.deactivate(self.adViewConstraints)
            self.adViewConstraints.removeAll()
            self.adViewConstraints.append(admobBannerView.leadingAnchor.constraint(equalTo: webView.scrollView.leadingAnchor, constant: CGFloat(left)))
            self.adViewConstraints.append(admobBannerView.topAnchor.constraint(equalTo: webView.scrollView.topAnchor, constant: CGFloat(top)))
            self.adViewConstraints.append(admobBannerView.widthAnchor.constraint(equalToConstant: CGFloat(right-left)))
            NSLayoutConstraint.activate(self.adViewConstraints)
        }
    }
}
