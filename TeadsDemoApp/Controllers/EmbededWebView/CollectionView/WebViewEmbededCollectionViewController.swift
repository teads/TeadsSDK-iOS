//
//  WebViewEmbededCollectionViewController.swift
//  TeadsDemoApp
//
//  Created by Jérémy Grosjean on 04/10/2017.
//  Copyright © 2018 Teads. All rights reserved.
//

import UIKit
import WebKit
import TeadsSDK

private let reuseIdentifier = "Cell"

class WebViewEmbededCollectionViewController: UICollectionViewController, WKNavigationDelegate, UICollectionViewDelegateFlowLayout {
    let reuseIdentifier = "teadsCell"
    let reuseTeadsIdentifier = "teadsAdCell"
    let adRowNumber = 16
    var webView: WKWebView!
    var webSync: SyncWebViewTFInReadAdView?
    var adView: TFAInReadAdView?
    var webViewHeight: CGFloat?
    var contentSizeObserver: NSKeyValueObservation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let content = Bundle.main.path(forResource: "index", ofType: "html"),
            let contentString = try? String(contentsOfFile: content) else {
                return
        }
        
        self.webView = WKWebView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 200))
        self.webView.navigationDelegate = self
        self.webView.scrollView.isScrollEnabled = false
        self.webView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.webView.loadHTMLString(contentString, baseURL: nil)
        
        self.adView = TFAInReadAdView(withPid: UserDefaults.standard.integer(forKey: "PID"))
        self.webSync = SyncWebViewTFInReadAdView(webView: self.webView!, selector: "#my-placement-id", adView: self.adView!)
        
        self.collectionView!.register(TeadsAdEmbededCollectionViewCell.self, forCellWithReuseIdentifier: self.reuseTeadsIdentifier)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParent || self.isBeingDismissed {
            self.stopObservingContentSize()
        }
    }
    
    deinit {
        self.stopObservingContentSize()
    }
    
    func startObservingContentSize() {
        if self.webView != nil, self.contentSizeObserver == nil {
            self.contentSizeObserver = self.webView!.scrollView.observe(\.contentSize, options: [.initial, .new]) { (_, change) in
                if let newValue = change.newValue as CGSize?, newValue != CGSize.zero {
                    DispatchQueue.main.async {
                        if self.adView != nil {
                            if self.webViewHeight != newValue.height {
                                self.webViewHeight = newValue.height
                                self.webView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.webViewHeight!)
                                self.collectionView?.reloadItems(at: [IndexPath(row: self.adRowNumber, section: 0)])
                                self.webSync?.webViewHelper.updateSlot(adRatio: self.adView!.adRatio)
                            }
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

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: UICollectionViewCell?
        if self.adRowNumber == indexPath.row {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.reuseTeadsIdentifier, for: indexPath) as? TeadsAdEmbededCollectionViewCell
            self.webView.removeFromSuperview()
            cell!.contentView.addSubview(self.webView)
            self.startObservingContentSize()
            self.webView?.frame = cell!.contentView.bounds

        } else {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.reuseIdentifier, for: indexPath) as? RandomCollectionViewCell
        }
        return cell != nil ? cell! :UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if self.adRowNumber == indexPath.row {
            return CGSize(width: self.view.frame.width, height: self.webViewHeight != nil ? self.webViewHeight! : 200)
        } else {
            return CGSize(width: 150, height: 100)
        }
    }
    
    // MARK: -
    // MARK: WKNavigationDelegate
    // MARK: -
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.webSync?.injectJS()
    }

}
