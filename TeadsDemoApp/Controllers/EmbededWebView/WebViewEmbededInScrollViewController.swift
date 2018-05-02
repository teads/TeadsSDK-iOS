//
//  WebViewEmbededInScrollViewController.swift
//  TeadsDemoApp
//
//  Created by Jérémy Grosjean on 03/10/2017.
//  Copyright © 2017 Jérémy Grosjean. All rights reserved.
//

import UIKit
import WebKit
import TeadsSDK

class WebViewEmbededInScrollViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var topView: UIView!
    var webView: WKWebView?
    var webSync: SyncWebViewTFACustomAdView?
    var adView: TFACustomAdView?
    var contentSizeObserver: NSKeyValueObservation?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let content = Bundle.main.path(forResource: "index", ofType: "html"),
            let contentString = try? String(contentsOfFile: content) else {
                return
        }
        
        self.webView = WKWebView(frame: CGRect(x: 0, y: self.topView.frame.size.height, width: self.scrollView.frame.width, height: self.scrollView.frame.size.height-self.topView.frame.size.height))
        self.webView?.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.webView?.navigationDelegate = self
        self.webView?.scrollView.isScrollEnabled = false
        self.scrollView.addSubview(self.webView!)
        self.webView?.loadHTMLString(contentString, baseURL: nil)
        
        self.adView = TFACustomAdView(pid: UserDefaults.standard.string(forKey: "PID")!)
        self.webSync = SyncWebViewTFACustomAdView(webView: self.webView!, selector: "#my-placement-id", adView: self.adView!)
        
        self.startObservingContentSize()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParentViewController || self.isBeingDismissed {
            self.stopObservingContentSize()
        }
    }
    
    func startObservingContentSize() {
        if self.webView != nil, self.contentSizeObserver == nil {
            self.contentSizeObserver = self.webView!.scrollView.observe(\.contentSize, options: [.initial, .new]) { (_, change) in
                if let newValue = change.newValue as CGSize?, newValue != CGSize.zero {
                    self.resizeEverything()
                }
            }
        }
    }
    
    func stopObservingContentSize() {
        self.contentSizeObserver?.invalidate()
        self.contentSizeObserver = nil
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize" {
            self.resizeEverything()
        }
    }
    
    func resizeEverything() {
        if self.webView != nil {
            DispatchQueue.main.async {
                self.webView?.frame = CGRect(x: 0, y: self.topView.frame.size.height, width: self.scrollView.frame.size.width, height: self.webView!.scrollView.contentSize.height)
                self.scrollView.contentSize = CGSize(width: self.scrollView.frame.size.width, height: self.topView.frame.size.height + self.webView!.scrollView.contentSize.height)
            }
        }
    }
    
    deinit {
        self.stopObservingContentSize()
    }
    
    // MARK: -
    // MARK: WebBridge Delegate
    // MARK: -
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.webSync?.injectJS()
    }
}
