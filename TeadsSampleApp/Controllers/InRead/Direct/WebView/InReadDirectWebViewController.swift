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

    var placement: TeadsAdPlacementMedia?

    override func viewDidLoad() {
        super.viewDidLoad()

        // The html identifier where you want your slot to open`
        let domCSSSlotSelector = "#teads-placement-slot"

        /// init helper before loading html content
        webViewHelper = TeadsWebViewHelper(webView: webView, selector: domCSSSlotSelector, delegate: self)

        guard let content = Bundle.main.path(forResource: "sample", ofType: "html"),
              let contentString = try? String(contentsOfFile: content) else {
            return
        }
        let contentStringWithIntegrationType = contentString.replacingOccurrences(of: "{INTEGRATION_TYPE}", with: "InRead Direct WebView Integration")

        webView.loadHTMLString(contentStringWithIntegrationType, baseURL: Bundle.main.bundleURL)

        let pSettings = TeadsAdPlacementSettings { _ in
            // settings.enableDebug()
        }

        // Create placement with unified API
        let config = TeadsAdPlacementMediaConfig(
            pid: Int(pid) ?? 0,
            articleUrl: URL(string: "https://www.teads.com")
        )
        placement = TeadsAdPlacementMedia(config, delegate: self)
    }
}

extension InReadDirectWebViewController: TeadsAdPlacementEventsDelegate {
    func adPlacement(
        _: TeadsAdPlacementIdentifiable?,
        didEmitEvent event: TeadsAdPlacementEventName,
        data: [String: Any]?
    ) {
        switch event {
            case .ready:
                if let adRatio = data?["adRatio"] as? TeadsAdRatio {
                    // For WebView integration, we need to get the ad and adRatio
                    // Note: WebView helper may need special handling with the new API
                    print("didReceiveAd - ready event")
                }
            case .heightUpdated:
                if let adRatio = data?["adRatio"] as? TeadsAdRatio {
                    webViewHelper?.updateSlot(adRatio: adRatio)
                    print("didUpdateRatio")
                }
            case .failed:
                if let error = data?["error"] {
                    print("didFailToReceiveAd \(error)")
                }
            default:
                break
        }
    }
}

// TeadsAdDelegate is handled through unified events system

extension InReadDirectWebViewController: TeadsWebViewHelperDelegate {
    func webViewHelperSlotStartToShow() {
        print("webViewHelperSlotStartToShow")
    }

    func webViewHelperSlotStartToHide() {
        print("webViewHelperSlotStartToHide")
    }

    func webViewHelperSlotFoundSuccessfully() {
        print("webViewHelperSlotFoundSuccessfully")
        do {
            if let adView = try placement?.loadAd() {
                // For WebView, the ad needs special handling through webViewHelper
                // The helper may need to be updated to work with the new API
                print("Ad loaded successfully")
            }
        } catch {
            print("Failed to load ad: \(error)")
        }
    }

    func webViewHelperSlotNotFound() {
        print("webViewHelperSlotNotFound")
    }

    func webViewHelperOnError(error: String) {
        print("webViewHelperOnError \(error)")
    }
}
