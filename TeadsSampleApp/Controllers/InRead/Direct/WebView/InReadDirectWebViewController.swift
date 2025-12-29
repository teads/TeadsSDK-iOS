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

    // Track slot state
    private var isSlotOpened = false
    private var isSlotFound = false
    private var isAdReady = false
    private var currentAdHeight: CGFloat = 0

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
        isSlotOpened = false
        isAdReady = false
        currentAdHeight = 0

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

    /// Try to open the slot when both conditions are met:
    /// 1. The HTML slot is found
    /// 2. The ad is ready (or we have an adView)
    private func tryOpenSlot() {
        guard !isSlotOpened,
              isSlotFound,
              let view = adView else {
            return
        }

        print("Opening slot with adView")
        isSlotOpened = true
        webViewHelper?.openSlot(adView: view)

        // If we already have a valid height, update the slot
        if currentAdHeight > 0 {
            webViewHelper?.updateSlotWithHeight(currentAdHeight)
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
                isAdReady = true
                // Try to open the slot if not already opened
                tryOpenSlot()

            case .rendered:
                print("Ad rendered")

            case .heightUpdated:
                if let height = data?["height"] as? CGFloat {
                    print("Height updated: \(height)")
                    currentAdHeight = height
                    // Only update if slot is already opened and height is valid
                    if isSlotOpened, height > 0 {
                        webViewHelper?.updateSlotWithHeight(height)
                    }
                }

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
        isSlotFound = true
        // Try to open the slot now that it's found
        tryOpenSlot()
    }

    func webViewHelperSlotNotFound() {
        print("webViewHelperSlotNotFound")
    }

    func webViewHelperOnError(error: String) {
        print("webViewHelperOnError \(error)")
    }
}
