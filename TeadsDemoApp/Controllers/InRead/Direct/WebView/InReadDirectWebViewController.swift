//
//  InReadDirectWebViewController.swift
//  TeadsDemoApp
//
//  Created by Jérémy Grosjean on 02/10/2017.
//  Copyright © 2018 Teads. All rights reserved.
//

import UIKit
import WebKit
import TeadsSDK

class InReadDirectWebViewController: TeadsArticleViewController, WKNavigationDelegate {

    @IBOutlet weak var webView: WKWebView!
    var webSync: SyncWebViewTFInReadAdView?
    var adView: TFAInReadAdView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let content = Bundle.main.path(forResource: "demo", ofType: "html"),
            let contentString = try? String(contentsOfFile: content) else {
                return
        }
        webView.navigationDelegate = self
        webView.loadHTMLString(contentString, baseURL: Bundle.main.bundleURL)
        
        adView = TFAInReadAdView(withPid: UserDefaults.standard.integer(forKey: "PID"))
        webSync = SyncWebViewTFInReadAdView(webView: webView, selector: "#teads-placement-slot", adView: adView, viewController: self)
    }
    
    // MARK: -
    // MARK: WKNavigationDelegate
    // MARK: -
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webSync?.injectJS()
    }
}
