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
    var adView: UIView?

    override var pid: String {
        didSet {
            guard oldValue != pid, isViewLoaded else { return }
            setupPlacement()
        }
    }

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

        setupPlacement()
    }

    private func setupPlacement() {
        // Clean up existing placement and views
        if adView != nil {
            webViewHelper?.closeSlot()
        }
        placement = nil
        adView = nil

        // Create placement with new API
        let config = TeadsAdPlacementMediaConfig(
            pid: Int(pid) ?? 0,
            articleUrl: URL(string: "https://www.teads.com"),
            enableValidationMode: validationModeEnabled
        )

        placement = Teads.createPlacement(with: config, delegate: self)

        // Load ad and store view
        if let view = try? placement?.loadAd() {
            adView = view
        }
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
                print("Ad ready")
                // Open the slot with ad view
                if let view = adView {
                    webViewHelper?.openSlot(adView: view)
                }

            case .rendered:
                print("Ad rendered")

            case .heightUpdated:
                print("Height updated")
                // The ad view auto-resizes, no need to manually update slot

            case .viewed:
                print("Ad viewed (impression)")

            case .clicked:
                print("Ad clicked")

            case .failed:
                print("Ad failed: \(data?["reason"] ?? "Unknown")")
                webViewHelper?.closeSlot()

            case .play:
                print("Video play")

            case .pause:
                print("Video pause")

            case .complete:
                print("Video complete")
                webViewHelper?.closeSlot()

            default:
                break
        }
    }
}

extension InReadDirectWebViewController: TeadsWebViewHelperDelegate {
    func webViewHelperSlotStartToShow() {
        print("webViewHelperSlotStartToShow")
    }

    func webViewHelperSlotStartToHide() {
        print("webViewHelperSlotStartToHide")
    }

    func webViewHelperSlotFoundSuccessfully() {
        print("webViewHelperSlotFoundSuccessfully")
        // Ad is already loaded in viewDidLoad with the new API
    }

    func webViewHelperSlotNotFound() {
        print("webViewHelperSlotNotFound")
    }

    func webViewHelperOnError(error: String) {
        print("webViewHelperOnError \(error)")
    }
}
