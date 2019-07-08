//
//  SyncWebViewAdView.swift
//  TeadsApp
//
//  Created by Jérémy Grosjean on 20/05/2019.
//  Copyright © 2019 Teads. All rights reserved.
//

import UIKit
import GoogleMobileAds
import TeadsAdMobAdapter
import WebKit

class SyncWebViewAdView: NSObject, WebViewHelperDelegate {
    
    weak var webView: WKWebView?
    weak var adView: UIView?
    var webViewHelper: WebViewHelper
    var isLoaded = false
    var adViewConstraints = [NSLayoutConstraint]()
    
    public init(webView: WKWebView, selector: String, adView: UIView) {
        webViewHelper = WebViewHelper(webView: webView, selector: selector)
        self.adView = adView
        self.webView = webView
        super.init()
        webViewHelper.delegate = self
    }
    
    deinit {
        webViewHelper.clean()
    }
    
    public func injectJS() {
        //Inject the js in your webview when the webview is ready
        webViewHelper.injectJS()
    }
    
    // MARK: WebViewHelperDelegate
    
    public func webViewHelperJSIsReady() {
        webViewHelper.openSlot()
        // Landscape ads are 16/9, setting the ratio to 16/10 give more space to display the ads and result in a better looking square ads
        webViewHelper.updateSlot(adRatio: 16/10)
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
        if let admobBannerView = adView, let webView = webView {
            if !isLoaded {
                isLoaded = true
                webView.scrollView.addSubview(admobBannerView)
                admobBannerView.translatesAutoresizingMaskIntoConstraints = false
            }
            //change the constraint according to coordonate that the delegate send us
            customAdViewConstraint(left: left, top: top, right: right, bottom: bottom)
        }
    }
    
    /// change the constraint of the ad so it follows what the bootstrap ask
    func customAdViewConstraint(left: Int, top: Int, right: Int, bottom: Int) {
        if let admobBannerView = adView, let webView = webView {
            NSLayoutConstraint.deactivate(adViewConstraints)
            adViewConstraints.removeAll()
            adViewConstraints.append(admobBannerView.leadingAnchor.constraint(equalTo: webView.scrollView.leadingAnchor, constant: CGFloat(left)))
            adViewConstraints.append(admobBannerView.topAnchor.constraint(equalTo: webView.scrollView.topAnchor, constant: CGFloat(top)))
            adViewConstraints.append(admobBannerView.widthAnchor.constraint(equalToConstant: CGFloat(right-left)))
            NSLayoutConstraint.activate(adViewConstraints)
        }
    }
}
