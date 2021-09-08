//
//  TeadsUIViewMPNativeAdRendering.swift
//  TeadsMoPubAdapter
//
//  Created by Jérémy Grosjean on 24/06/2021.
//

import UIKit
import TeadsSDK
import MoPubSDK

typealias TeadsUIViewMPNativeAdRendering = UIView & MPNativeAdRendering

@objc public final class MPAdapterTeadsNativeAdRenderer: NSObject, MPNativeAdRenderer {

    @objc public var viewSizeHandler: MPNativeViewSizeHandler!

    var rendererSettings: MPAdapterTeadsNativeAdRendererSettings!

    /// Publisher adView which is rendering.
    var adView: TeadsUIViewMPNativeAdRendering?

    /// YES if adView is in view hierarchy.
    var adViewInViewHierarchy: Bool?

    /// MPNativeAdRendererImageHandler instance.
    var renderingViewClass: TeadsUIViewMPNativeAdRendering.Type?

    /// Renderer settings are objects that allow you to expose configurable properties to the
    /// application. MPAdapterTeadsNativeAdRenderer renderer will be initialized with these settings.
    @objc required public init!(rendererSettings: MPNativeAdRendererSettings!) {
        viewSizeHandler = rendererSettings.viewSizeHandler
        self.rendererSettings = rendererSettings as? MPAdapterTeadsNativeAdRendererSettings
        renderingViewClass = self.rendererSettings.renderingViewClass
    }

    /// Construct and return an MPNativeAdRendererConfiguration object, you must set all the properties
    /// on the configuration object.
    @objc public static func rendererConfiguration(with rendererSettings: MPNativeAdRendererSettings!) -> MPNativeAdRendererConfiguration! {
        let config = MPNativeAdRendererConfiguration()
        config.rendererClass = MPAdapterTeadsNativeAdRenderer.self
        config.rendererSettings = rendererSettings
        config.supportedCustomEvents = [NSStringFromClass(MPAdapterTeadsNative.self)]
        return config
    }

    /// Returns an ad view rendered using provided |adapter|. Sets an |error| if any error is
    /// encountered.
    @objc public func retrieveView(with adapter: MPNativeAdAdapter!) throws -> UIView {
        guard let adapter = adapter as? MPAdapterTeadsMediatedNativeAd else {
            throw MPNativeAdNSErrorForRenderValueTypeError()
        }

        renderTeadsNativeAdView(with: adapter)

        guard let adView = adView else {
            throw MPNativeAdNSErrorForRenderValueTypeError()
        }
        return adView
    }

    /// Creates Teads Native AdView with adapter. We added TeadsNativeAdView assets on
    /// top of MoPub's adView, to track impressions & clicks.
    func renderTeadsNativeAdView(with adapter: MPAdapterTeadsMediatedNativeAd) {

        registerContainer(adapter: adapter)
        guard let adView = adView else {
            return
        }

        // Title
        register(component: adapter.teadsNativeAd.title,
                 in: adView.nativeTitleTextLabel?())

        // Main Text
        register(component: adapter.teadsNativeAd.content,
                 in: adView.nativeMainTextLabel?())

        // Call to action
        register(component: adapter.teadsNativeAd.callToAction,
                 in: adView.nativeCallToActionTextLabel?())

        // Icon image
        register(component: adapter.teadsNativeAd.icon,
                 in: adView.nativeIconImageView?())

        // Main image
        register(component: adapter.teadsNativeAd.image,
                 in: adView.nativeMainImageView?())

        // Advertiser
        register(component: adapter.teadsNativeAd.sponsored,
                 in: adView.nativeSponsoredByCompanyTextLabel?())
        
    }

    func registerContainer(adapter: MPAdapterTeadsMediatedNativeAd) {
        
        if let adView = renderingViewClass?.nibForAd?()?.instantiate(withOwner: self, options: nil).first as? TeadsUIViewMPNativeAdRendering {
            self.adView = adView
        } else {
            adView = renderingViewClass?.init(frame: .zero)
        }
        guard let adView = adView else {
            return
        }
        adView.frame = CGRect(x: 0, y: 0, width: 300, height: 250)
        adView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        adapter.teadsNativeAd.register(containerView: adView)
    }

    func register(component: CommonComponent?, in assetView: UIView?) {
        if let assetView = assetView, let component = component {
            assetView.bind(component: component)
        }
    }
}

