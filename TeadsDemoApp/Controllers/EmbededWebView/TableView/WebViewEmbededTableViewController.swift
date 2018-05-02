//
//  WebViewEmbededTableViewController.swift
//  TeadsDemoApp
//
//  Created by Jérémy Grosjean on 03/10/2017.
//  Copyright © 2017 Jérémy Grosjean. All rights reserved.
//

import UIKit
import TeadsSDK
import WebKit
class WebViewEmbededTableViewController: UITableViewController, WKNavigationDelegate {

    let teadsTextCellIdentifier = "TeadsFirstCell"
    let teadsGrayedCellidentifier = "TeadsGrayedCell"
    let webViewCellIdentifier = "WebViewCell"
    let adRowNumber = 16
    var webView: WKWebView!
    var webSync: SyncWebViewTFACustomAdView?
    var adView: TFACustomAdView?
    var webViewHeight: CGFloat?
    var contentSizeObserver: NSKeyValueObservation?
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParentViewController || self.isBeingDismissed {
            self.stopObservingContentSize()
        }
    }
    
    deinit {
        self.stopObservingContentSize()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let content = Bundle.main.path(forResource: "index", ofType: "html"),
            let contentString = try? String(contentsOfFile: content) else {
                return
        }
        
        self.webView = WKWebView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 200))
        self.webView?.navigationDelegate = self
        self.webView?.autoresizingMask = [.flexibleBottomMargin, .flexibleHeight, .flexibleWidth, .flexibleLeftMargin, .flexibleTopMargin, .flexibleTopMargin]
        self.webView?.scrollView.isScrollEnabled = false
        self.webView?.loadHTMLString(contentString, baseURL: nil)
        
        self.adView = TFACustomAdView(pid: UserDefaults.standard.string(forKey: "PID")!)
        self.webSync = SyncWebViewTFACustomAdView(webView: self.webView!, selector: "#my-placement-id", adView: self.adView!)
               
        self.startObservingContentSize()
    }

    func startObservingContentSize() {
        if self.webView != nil, self.contentSizeObserver == nil {
            self.contentSizeObserver = self.webView!.scrollView.observe(\.contentSize, options: [.initial, .new]) { (_, change) in
                if let newValue = change.newValue as CGSize?, newValue != CGSize.zero {
                    DispatchQueue.main.async {
                        if self.adView != nil {
                            self.webViewHeight = newValue.height
                            self.webView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.webViewHeight!)
                        }
                    }
                }
            }
        }
    }
    
    func stopObservingContentSize() {
        self.contentSizeObserver?.invalidate()
        self.contentSizeObserver = nil
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: self.teadsTextCellIdentifier, for: indexPath)
            return cell
        } else if indexPath.row == self.adRowNumber {
            let webViewCell = tableView.dequeueReusableCell(withIdentifier: self.webViewCellIdentifier, for: indexPath)
            if self.webView.superview != nil {
                self.webView.removeFromSuperview()
            }
            self.startObservingContentSize()
            webViewCell.contentView.addSubview(self.webView)
            return webViewCell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: self.teadsGrayedCellidentifier, for: indexPath)
            return cell
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == adRowNumber {
            return self.webViewHeight != nil ? self.webViewHeight! : CGFloat(200.0)
        }
        return 90
    }

    // MARK: -
    // MARK: WKNavigationDelegate
    // MARK: -
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.webSync?.injectJS()
    }
    
}
