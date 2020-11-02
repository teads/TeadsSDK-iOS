//
//  SyncWebViewTFACustomAdView.swift
//  TeadsSDK
//
//  Created by Jérémy Grosjean on 15/09/2017.
//  Copyright © 2018 Teads. All rights reserved.
//

import UIKit
import WebKit
import TeadsSDK

public class SyncWebViewTFInReadAdView: NSObject, WebViewHelperDelegate, TFAAdDelegate {
    
    weak var webView: WKWebView?
    var webViewHelper: WebViewHelper
    weak var adView: TFAInReadAdView?
    var teadsAdSettings: TeadsAdSettings?
    var isLoaded = false
    var adViewConstraints = [NSLayoutConstraint]()
    var adViewHeightConstraint: NSLayoutConstraint?
    var adRatio: CGFloat = 16/9.0
    weak var viewController: UIViewController?
    
    public init(webView: WKWebView, selector: String, adView: TFAInReadAdView, viewController: UIViewController, adSettings: TeadsAdSettings? = nil) {
        webViewHelper = WebViewHelper(webView: webView, selector: selector)
        self.adView = adView
        super.init()
        self.adView?.delegate = self
        webViewHelper.delegate = self
        self.webView = webView
        self.viewController = viewController
        teadsAdSettings = adSettings
        //We use the observer to know when the rotation happen to resize the ad
        NotificationCenter.default.addObserver(self, selector: #selector(rotationDetected), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    deinit {
        self.webViewHelper.clean()
        NotificationCenter.default.removeObserver(self)
    }
    
    public func injectJS() {
        //Inject the js in your webview when the webview is ready
        webViewHelper.injectJS()
    }
    
    @objc func rotationDetected() {
        //update the slot when the rotation occurs
        webViewHelper.updateSlot(adRatio: adRatio)
    }
    
    // MARK: WebViewHelperDelegate
    
    public func webViewHelperJSIsReady() {
        //insert the slot when the webview helper is ready
        webViewHelper.insertSlot()
    }
    public func webViewHelperSlotStartToShow() {
    }
    public func webViewHelperSlotStartToHide() {
        
    }
    public func webViewHelperUpdatedSlot(left: Int, top: Int, right: Int, bottom: Int) {
        // if the adView is not already loaded load it and add it to the scrollView of your webview
        if let adView = self.adView, let webView = self.webView {
            if !isLoaded {
                isLoaded = true
                adView.load(teadsAdSettings: teadsAdSettings)
                webView.scrollView.addSubview(adView)
                adView.translatesAutoresizingMaskIntoConstraints = false
            }
            //change the constraint according to coordonate that the delegate send us
            customAdViewConstraint(left: left, top: top, right: right, bottom: bottom)
        }
    }
    
    /// change the constraint of the ad so it follows what the bootstrap ask
    func customAdViewConstraint(left: Int, top: Int, right: Int, bottom: Int) {
        if let adView = self.adView, let webView = self.webView {
            NSLayoutConstraint.deactivate(adViewConstraints)
            adViewConstraints.removeAll()
            adViewConstraints.append(adView.leadingAnchor.constraint(equalTo: webView.scrollView.leadingAnchor, constant: CGFloat(left)))
            adViewConstraints.append(adView.topAnchor.constraint(equalTo: webView.scrollView.topAnchor, constant: CGFloat(top)))
            adViewConstraints.append(adView.widthAnchor.constraint(equalToConstant: CGFloat(right-left)))
            adViewHeightConstraint = adView.heightAnchor.constraint(equalToConstant: CGFloat(bottom-top))
            adViewConstraints.append(adViewHeightConstraint!)
            NSLayoutConstraint.activate(adViewConstraints)
        }
    }
    
    public func webViewHelperSlotNotFound() {
    }
    
    public func webViewHelperOnError(error: String) {
    }
    
    // MARK: TeadsAdDelegate
    
    public func didReceiveAd(_ ad: TFAAdView, adRatio: CGFloat) {
        self.adRatio = adRatio
        //update slot with the right ratio
        webViewHelper.updateSlot(adRatio: self.adRatio)
        //open the slot
        webViewHelper.openSlot()
    }
    
    public func didFailToReceiveAd(_ ad: TFAAdView, adFailReason: AdFailReason) {
        
    }
    
    
    public func adClose(_ ad: TFAAdView, userAction: Bool) {
        //close the slot
        webViewHelper.closeSlot()
        //hide the ad too
        if let heightConstraint = self.adViewHeightConstraint {
            heightConstraint.constant = 0
        }
        //animate the hiding of the ad
        UIView.animate(withDuration: 0.25) {
            self.adView?.superview?.layoutIfNeeded()
        }
        //be careful if you want to load another ad in the same page don't remove the observer
        NotificationCenter.default.removeObserver(self)
    }
    
    public func adError(_ ad: TFAAdView, errorMessage: String) {
        //be careful if you want to load another ad in the same page don't remove the observer
        NotificationCenter.default.removeObserver(self)
    }
    
    public func didUpdateRatio(_ ad: TFAAdView, ratio: CGFloat) {
        adRatio = ratio
        //update slot with the right ratio
        webViewHelper.updateSlot(adRatio: ratio)
    }
    
    public func adDidCloseFullscreen(_ ad: TFAAdView) {
        //update the slot in case there was a rotation or a layout change to be sure that the ad has the right layout
        webViewHelper.updateSlot(adRatio: adRatio)
    }
    
    public func adBrowserWillOpen(_ ad: TFAAdView) -> UIViewController? {
        return viewController
    }
}
