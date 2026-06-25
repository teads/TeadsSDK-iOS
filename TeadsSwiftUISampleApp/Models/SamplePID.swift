//
//  SamplePID.swift
//  TeadsSwiftUISampleApp
//
//  Copyright © 2026 Teads. All rights reserved.
//

import Foundation

/// Public demo PIDs. Replace with your own placement identifiers in production.
enum SamplePID {
    // MARK: Direct

    static let directLandscape = 84242
    static let directVertical = 127_546
    static let directSquare = 127_547
    static let directCarousel = 128_779
    static let directNativeDisplay = 124_859

    // MARK: AdMob

    static let admobLandscape = "ca-app-pub-3068786746829754/3486435166"
    static let admobVertical = "ca-app-pub-3068786746829754/1731249109"
    static let admobSquare = "ca-app-pub-3068786746829754/5867288248"
    static let admobCarousel = "ca-app-pub-3068786746829754/1761017118"
    static let admobNativeDisplay = "ca-app-pub-3068786746829754/9820813147"
    static let admobInterstitial = "ca-app-pub-3068786746829754/1230437446"
    static let admobInterstitialTest = "ca-app-pub-3940256099942544/1033173712"

    // MARK: Smart AdServer (SAS)

    static let sasLandscape = 96445
    static let sasVertical = 96469
    static let sasSquare = 96468
    static let sasCarousel = 96470
    static let sasNativeDisplay = 102_803
    static let sasSiteId = 385_317
    static let sasPageId = 1_399_206
    static let sasNativePageName = "1399205"

    // MARK: AppLovin (banner)

    static let appLovinLandscape = "3359d5bcb0cf612b"
    static let appLovinVertical = "74481c0cee5c73b1"
    static let appLovinSquare = "accecf03a9e0a672"
    static let appLovinCarousel = "d1fb90cd8eeb350e"
    static let appLovinNativeDisplay = "a416d5d67e65ddcd"

    // MARK: AppLovin (MREC)

    static let appLovinLandscapeMREC = "3359d5bcb0cf612b"
    static let appLovinVerticalMREC = "74481c0cee5c73b1"
    static let appLovinSquareMREC = "accecf03a9e0a672"
    static let appLovinCarouselMREC = "d1fb90cd8eeb350e"

    // MARK: Outbrain widget placements (Direct Feed / Recommendations / Banner / Interstitial)

    static let outbrainArticleURL = URL(string: "https://mobile-demo.outbrain.com/")!
    static let outbrainInstallationKey = "NANOWDGT01"
    static let feedWidgetId = "MB_1"
    static let recommendationsWidgetId = "SDK_1"
    static let bannerWidgetId = "MB_10"

    static let interstitialDirectArticleURL = URL(string: "https://example.com/article")!
    static let interstitialDirectWidgetId = "INT_MW_1"

    // MARK: AdMob (banner)

    static let admobBanner = "ca-app-pub-3068786746829754/5448863490"

    static let articleURL = URL(string: "https://www.teads.com")

    static var custom: Int {
        get { UserDefaults.standard.integer(forKey: "PID") }
        set { UserDefaults.standard.set(newValue, forKey: "PID") }
    }
}
