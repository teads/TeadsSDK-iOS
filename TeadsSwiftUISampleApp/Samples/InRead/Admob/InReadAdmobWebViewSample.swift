//
//  InReadAdmobWebViewSample.swift
//  TeadsSwiftUISampleApp
//
//  Copyright © 2026 Teads. All rights reserved.
//

import GoogleMobileAds
import SwiftUI
import TeadsAdMobAdapter
import TeadsSDK
import WebKit

/// InRead • AdMob • WebView.
///
/// Mirrors `InReadAdmobWebViewController`: AdMob loads via the Teads adapter, and once the WebView
/// helper finds the JS slot we feed the AdMob banner into it.
struct InReadAdmobWebViewSample: View {
    let pid: String

    var body: some View {
        AdMobWebViewContainer(adUnitID: pid)
            .ignoresSafeArea(edges: .bottom)
            .navigationBarTitleDisplayMode(.inline)
            .teadsBrandNavigationBar()
    }
}

private struct AdMobWebViewContainer: UIViewRepresentable {
    let adUnitID: String

    func makeCoordinator() -> Coordinator { Coordinator(adUnitID: adUnitID) }
    func makeUIView(context: Context) -> WKWebView { context.coordinator.makeWebView() }
    func updateUIView(_: WKWebView, context _: Context) {}

    final class Coordinator: NSObject, TeadsMediatedAdViewDelegate, BannerViewDelegate, TeadsWebViewHelperDelegate {
        private let adUnitID: String
        private var webViewHelper: TeadsWebViewHelper?
        private var banner: AdManagerBannerView?

        init(adUnitID: String) {
            self.adUnitID = adUnitID
        }

        func makeWebView() -> WKWebView {
            let webView = WKWebView()
            webViewHelper = TeadsWebViewHelper(webView: webView, selector: "#teads-placement-slot", delegate: self)
            webView.loadHTMLString(WebViewArticleHTML.document, baseURL: nil)

            let bannerView = AdManagerBannerView(adSize: AdSizeMediumRectangle)
            bannerView.adUnitID = adUnitID
            bannerView.delegate = self
            DispatchQueue.main.async {
                bannerView.rootViewController = webView.window?.rootViewController
            }
            banner = bannerView
            return webView
        }

        // MARK: TeadsWebViewHelperDelegate

        func webViewHelperSlotFoundSuccessfully() {
            guard let banner else { return }
            let settings = TeadsAdapterSettings { settings in
                settings.enableDebug()
                settings.registerAdView(banner, delegate: self)
            }
            let request = Request()
            request.register(settings)
            banner.load(request)
        }

        func webViewHelperOnError(error: String) {
            print("AdMob WebView helper error: \(error)")
        }

        // MARK: BannerViewDelegate

        func bannerViewDidReceiveAd(_ bannerView: BannerView) {
            webViewHelper?.openSlot(adView: bannerView)
        }

        func bannerView(_: BannerView, didFailToReceiveAdWithError error: Error) {
            print("AdMob WebView banner failed: \(error.localizedDescription)")
            webViewHelper?.closeSlot()
        }

        // MARK: TeadsMediatedAdViewDelegate

        func didUpdateRatio(_: UIView, adRatio: TeadsAdRatio) {
            guard let webViewHelper, let banner else { return }
            let width = webViewHelper.adViewHTMLElementWidth
            banner.resize(AdSize(size: CGSize(width: width, height: adRatio.calculateHeight(for: width)), flags: 1))
            webViewHelper.updateSlot(adRatio: adRatio)
        }
    }
}

#Preview {
    NavigationStack {
        InReadAdmobWebViewSample(pid: SamplePID.admobLandscape)
    }
}
