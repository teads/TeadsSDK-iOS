//
//  InReadDirectWebViewSample.swift
//  TeadsSwiftUISampleApp
//
//  Copyright © 2026 Teads. All rights reserved.
//

import SwiftUI
import TeadsSDK
import WebKit

/// `TeadsWebViewHelper` discovers a JS slot in the page and opens/closes it as the placement emits events.
struct InReadDirectWebViewSample: View {
    let selection: SampleSelection

    var body: some View {
        TeadsWebViewContainer(pid: selection.integerPID)
            .ignoresSafeArea(edges: .bottom)
            .navigationBarTitleDisplayMode(.inline)
            .teadsBrandNavigationBar()
    }
}

private struct TeadsWebViewContainer: UIViewRepresentable {
    let pid: Int

    func makeCoordinator() -> Coordinator {
        Coordinator(pid: pid)
    }

    func makeUIView(context: Context) -> WKWebView {
        context.coordinator.makeWebView()
    }

    func updateUIView(_: WKWebView, context _: Context) {}

    final class Coordinator: NSObject, TeadsAdPlacementEventsDelegate, TeadsWebViewHelperDelegate {
        private let pid: Int
        private var webViewHelper: TeadsWebViewHelper?
        private var placement: TeadsAdPlacementMedia?
        private var adView: UIView?

        private var isSlotFound = false
        private var isSlotOpened = false
        private var currentAdHeight: CGFloat = 0

        init(pid: Int) {
            self.pid = pid
        }

        func makeWebView() -> WKWebView {
            let webView = WKWebView()
            let slotSelector = "#teads-placement-slot"
            webViewHelper = TeadsWebViewHelper(webView: webView, selector: slotSelector, delegate: self)

            let config = TeadsAdPlacementMediaConfig(
                pid: pid,
                articleUrl: SamplePID.articleURL,
                enableValidationMode: true
            )
            placement = Teads.createPlacement(with: config, delegate: self)
            adView = try? placement?.loadAd()

            webView.loadHTMLString(WebViewArticleHTML.document, baseURL: nil)
            return webView
        }

        private func tryOpenSlot() {
            guard !isSlotOpened, isSlotFound, let adView else { return }
            isSlotOpened = true
            webViewHelper?.openSlot(adView: adView)
            if currentAdHeight > 0 {
                webViewHelper?.updateSlotWithHeight(currentAdHeight)
            }
        }

        // MARK: TeadsAdPlacementEventsDelegate

        func adPlacement(
            _: (any TeadsAdPlacementIdentifiable)?,
            didEmitEvent event: TeadsAdPlacementEventName,
            data: [String: Any]?
        ) {
            switch event {
                case .ready:
                    tryOpenSlot()
                case .heightUpdated:
                    if let height = data?["height"] as? CGFloat {
                        currentAdHeight = height
                        if isSlotOpened, height > 0 {
                            webViewHelper?.updateSlotWithHeight(height)
                        }
                    }
                case .failed, .complete:
                    webViewHelper?.closeSlot()
                default:
                    break
            }
        }

        // MARK: TeadsWebViewHelperDelegate

        func webViewHelperSlotFoundSuccessfully() {
            isSlotFound = true
            tryOpenSlot()
        }

        func webViewHelperOnError(error: String) {
            print("Teads WebView helper error: \(error)")
        }
    }
}

#Preview {
    NavigationStack {
        InReadDirectWebViewSample(selection: SampleSelection())
    }
}
