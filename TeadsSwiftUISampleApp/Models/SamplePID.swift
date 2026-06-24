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

    static let admobLandscape = "ca-app-pub-3068786746829754/2411019030"
    static let admobVertical = "ca-app-pub-3068786746829754/5776283742"
    static let admobSquare = "ca-app-pub-3068786746829754/1034598116"
    static let admobCarousel = "ca-app-pub-3068786746829754/5832124062"
    static let admobNativeDisplay = "ca-app-pub-3068786746829754/6007333247"
    static let admobInterstitial = "ca-app-pub-3068786746829754/9358977978"
    static let admobInterstitialTest = "ca-app-pub-3940256099942544/4411468910"

    // MARK: Smart AdServer (SAS)

    static let sasLandscape = 96445
    static let sasVertical = 96469
    static let sasSquare = 96468
    static let sasCarousel = 96470
    static let sasNativeDisplay = 102_803
    static let sasSiteId = 385_317
    static let sasPageId = 1_399_206

    // MARK: AppLovin (banner)

    static let appLovinLandscape = "eff7e1e4d3096392"
    static let appLovinVertical = "42b9f89963b23101"
    static let appLovinSquare = "4df06edb6937371e"
    static let appLovinCarousel = "373d7d2b25d2d8cc"
    static let appLovinNativeDisplay = "5738024757e4ef72"

    // MARK: AppLovin (MREC)

    static let appLovinLandscapeMREC = "ddfc48cc6bd71d73"
    static let appLovinVerticalMREC = "a4f5eb2342e7febb"
    static let appLovinSquareMREC = "512f790c9cf57ccd"
    static let appLovinCarouselMREC = "9b2445c1ac3d55d6"

    // MARK: Outbrain widget placements (Direct Feed / Recommendations / Banner / Interstitial)

    static let outbrainArticleURL = URL(string: "https://mobile-demo.outbrain.com/")!
    static let outbrainInstallationKey = "NANOWDGT01"
    static let feedWidgetId = "MB_1"
    static let recommendationsWidgetId = "SDK_1"
    static let bannerWidgetId = "MB_10"

    static let interstitialDirectArticleURL = URL(string: "https://example.com/article")!
    static let interstitialDirectWidgetId = "INT_MW_1"

    // MARK: AdMob (banner)

    static let admobBanner = "ca-app-pub-3068786746829754/2411019030"

    static let articleURL = URL(string: "https://www.teads.com")

    static var custom: Int {
        get { UserDefaults.standard.integer(forKey: "PID") }
        set { UserDefaults.standard.set(newValue, forKey: "PID") }
    }
}
