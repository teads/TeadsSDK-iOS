//
//  WebViewViewController.swift
//  TeadsDemoApp
//
//  Created by Jérémy Grosjean on 02/10/2017.
//  Copyright © 2018 Teads. All rights reserved.
//

import UIKit
import WebKit
import TeadsSDK

class WebViewViewController: UIViewController, WKNavigationDelegate {

    var webView: WKWebView?
    var webSync: SyncWebViewTFInReadAdView?
    var adView: TFAInReadAdView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let content = Bundle.main.path(forResource: "index", ofType: "html"),
            let contentString = try? String(contentsOfFile: content) else {
                return
        }
        
        self.webView = WKWebView(frame: self.view.bounds)
        self.webView?.navigationDelegate = self
        self.webView!.autoresizingMask = [.flexibleBottomMargin, .flexibleHeight, .flexibleWidth, .flexibleLeftMargin, .flexibleTopMargin, .flexibleTopMargin]
        self.view.addSubview(self.webView!)
        self.webView?.loadHTMLString(contentString, baseURL: nil)
        
        self.adView = TFAInReadAdView(withPid: UserDefaults.standard.integer(forKey: "PID"))
        self.webSync = SyncWebViewTFInReadAdView(webView: self.webView!, selector: "#my-placement-id", adView: self.adView!, viewController: self)
    }
    
    // MARK: -
    // MARK: WKNavigationDelegate
    // MARK: -
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.webSync?.injectJS()
    }
}
