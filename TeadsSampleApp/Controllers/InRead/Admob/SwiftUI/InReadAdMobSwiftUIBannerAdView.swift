//
//  InReadAdMobSwiftUIBannerAdView.swift
//  TeadsSampleApp
//
//  Created by Thibaud Saint-Etienne on 02/06/2022.
//  Copyright © 2022 Teads. All rights reserved.
//

import Foundation
import GoogleMobileAds
import SwiftUI
import TeadsAdMobAdapter
import TeadsSDK

@propertyWrapper class StrongContainer<T> {
    var wrappedValue: T

    init(wrappedValue: T) {
        self.wrappedValue = wrappedValue
    }
}

@available(iOS 13.0, *)
public struct InReadAdMobSwiftUIBannerAdView: UIViewRepresentable, View {
    private var gamBannerAdView: GAMBannerView

    @StrongContainer private var bannerViewDidReceiveAd: (GAMBannerView) -> Void = { _ in }
    @StrongContainer private var bannerView: (GAMBannerView, Error) -> Void = { _, _ in }
    @StrongContainer private var bannerViewWillPresentScreen: (GAMBannerView) -> Void = { _ in }
    @StrongContainer private var bannerViewWillDismissScreen: (GAMBannerView) -> Void = { _ in }
    @StrongContainer private var bannerViewDidDismissScreen: (GAMBannerView) -> Void = { _ in }
    @StrongContainer private var didUpdateRatio: (UIView, TeadsAdRatio) -> Void = { _, _ in }

    public init(gamBannerAdView: GAMBannerView) {
        self.gamBannerAdView = gamBannerAdView
    }

    public func makeUIView(context: Context) -> GAMBannerView {
        gamBannerAdView.delegate = context.coordinator
        let adSettings = TeadsAdapterSettings { settings in
            settings.enableDebug()
            try? settings.registerAdView(gamBannerAdView, delegate: context.coordinator)
        }

        let customEventExtras = GADMAdapterTeads.customEventExtra(with: adSettings)
        let request = GADRequest()
        request.register(customEventExtras)
        gamBannerAdView.load(request)

        return gamBannerAdView
    }

    public func updateUIView(_: GAMBannerView, context _: Context) {}

    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    public class Coordinator: NSObject, GADBannerViewDelegate, TeadsMediatedAdViewDelegate {
        var parent: InReadAdMobSwiftUIBannerAdView

        init(_ parent: InReadAdMobSwiftUIBannerAdView) {
            self.parent = parent
        }

        public func bannerViewDidReceiveAd(_: GADBannerView) {
            parent.bannerViewDidReceiveAd(parent.gamBannerAdView)
        }

        public func bannerView(_: GADBannerView, didFailToReceiveAdWithError error: Error) {
            parent.bannerView(parent.gamBannerAdView, error)
        }

        public func bannerViewWillPresentScreen(_: GADBannerView) {
            parent.bannerViewWillPresentScreen(parent.gamBannerAdView)
        }

        public func bannerViewWillDismissScreen(_: GADBannerView) {
            parent.bannerViewWillDismissScreen(parent.gamBannerAdView)
        }

        public func bannerViewDidDismissScreen(_: GADBannerView) {
            parent.bannerViewDidDismissScreen(parent.gamBannerAdView)
        }

        public func didUpdateRatio(_: UIView, adRatio: TeadsAdRatio) {
            parent.didUpdateRatio(parent.gamBannerAdView, adRatio)
        }
    }

    // MARK: Placement lifecycle

    public func bannerViewDidReceiveAd(_ closure: @escaping (GAMBannerView) -> Void) -> Self {
        bannerViewDidReceiveAd = closure
        return self
    }

    /// Tells the delegate an ad request failed.
    public func bannerView(_ closure: @escaping (GAMBannerView, Error) -> Void) -> Self {
        bannerView = closure
        return self
    }

    /// Tells the delegate that a full-screen view will be presented in response
    /// to the user clicking on an ad.
    public func bannerViewWillPresentScreen(_ closure: @escaping (GAMBannerView) -> Void) -> Self {
        bannerViewWillPresentScreen = closure
        return self
    }

    /// Tells the delegate that the full-screen view will be dismissed.
    public func bannerViewWillDismissScreen(_ closure: @escaping (GAMBannerView) -> Void) -> Self {
        bannerViewWillDismissScreen = closure
        return self
    }

    /// Tells the delegate that the full-screen view has been dismissed.
    public func bannerViewDidDismissScreen(_ closure: @escaping (GAMBannerView) -> Void) -> Self {
        bannerViewDidDismissScreen = closure
        return self
    }

    public func didUpdateRatio(_ closure: @escaping (UIView, TeadsAdRatio) -> Void) -> Self {
        didUpdateRatio = closure
        return self
    }
}
