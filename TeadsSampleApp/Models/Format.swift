//
//  Format.swift
//  TeadsSampleApp
//
//  Created by Thibaud Saint-Etienne on 09/10/2020.
//  Copyright © 2020 Teads. All rights reserved.
//

import Foundation

struct AdSelection {
    var format: Format
    var provider: Provider
    var creation: CreativeType

    init() {
        format = Formats.inRead.format()
        provider = inReadDirectProvider
        creation = landscape
    }
}

struct Format {
    let name: FormatName
    var providers: [Provider]
    var isSelected: Bool
}

struct Provider {
    let name: ProviderName
    let integrations: [Integration]
    var isSelected: Bool
}

extension Provider: Equatable {
    static func ==(lhs: Provider, rhs: Provider) -> Bool {
        return lhs.name == rhs.name
    }
}

struct CreativeType {
    let name: CreativeTypeName
    var isSelected: Bool
}

struct Integration {
    let name: String
    let imageName: String
}

// Formats
enum Formats {
    case inRead, native, feed, recommendations, banner, interstitial
    func format() -> Format {
        switch self {
            case .inRead: return inReadFormat
            case .native: return nativeFormat
            case .feed: return feedFormat
            case .recommendations: return recommendationsFormat
            case .banner: return bannerFormat
            case .interstitial: return interstitialFormat
        }
    }
}

let defaultInReadCreativeTypes = [landscape, vertical, square, carousel, custom]
let appLovinInReadCreativeTypes = [landscape, vertical, square, carousel, appLovinMRECLandscape, appLovinMRECVertical, appLovinMRECSquare, appLovinMRECCarousel, custom]
let sasInReadCreativeTypes = [landscape]
let nativeCreativeTypes = [display, custom]

func creativeTypes(for format: FormatName, provider: ProviderName) -> [CreativeType] {
    switch format {
        case .inRead:
            switch provider {
                case .appLovin: return appLovinInReadCreativeTypes
                case .sas: return sasInReadCreativeTypes
                default: return defaultInReadCreativeTypes
            }
        case .native: return nativeCreativeTypes
        case .feed, .recommendations, .banner, .interstitial: return []
    }
}

let inReadFormat = Format(name: .inRead, providers: [inReadDirectProvider, inReadAdmobProvider, inReadAppLovinProvider, inReadSASProvider], isSelected: true)
let nativeFormat = Format(name: .native, providers: [nativeDirectProvider, nativeAdmobProvider, nativeAppLovinProvider, nativeSASProvider], isSelected: false)
let feedFormat = Format(name: .feed, providers: [feedDirectProvider], isSelected: false)
let recommendationsFormat = Format(name: .recommendations, providers: [recommendationsDirectProvider], isSelected: false)
let bannerFormat = Format(name: .banner, providers: [bannerDirectProvider, bannerAdmobProvider], isSelected: false)
let interstitialFormat = Format(name: .interstitial, providers: [interstitialDirectProvider, interstitialAdmobProvider], isSelected: false)

// inRead Providers
let inReadDirectProvider = Provider(name: .direct, integrations: [
    scrollViewIntegration,
    tableViewIntegration,
    collectionViewIntegration,
    pageViewIntegration,
    webViewIntegration,
], isSelected: true)
let inReadAdmobProvider = Provider(name: .admob, integrations: [
    scrollViewIntegration,
    tableViewIntegration,
    webViewIntegration,
], isSelected: false)
let inReadSASProvider = Provider(name: .sas, integrations: [
    scrollViewIntegration,
    tableViewIntegration,
], isSelected: false)
let inReadAppLovinProvider = Provider(name: .appLovin, integrations: [
    scrollViewIntegration,
], isSelected: false)

// Feed Providers
let feedDirectProvider = Provider(name: .direct, integrations: [
    tableViewIntegration,
    collectionViewIntegration,
], isSelected: true)

// Recommendations Providers
let recommendationsDirectProvider = Provider(name: .direct, integrations: [
    tableViewIntegration,
    scrollViewIntegration,
], isSelected: true)

// Banner Providers
let bannerDirectProvider = Provider(name: .direct, integrations: [scrollViewIntegration], isSelected: true)
let bannerAdmobProvider = Provider(name: .admob, integrations: [collectionViewIntegration], isSelected: false)

// Interstitial Providers
let interstitialDirectProvider = Provider(name: .direct, integrations: [scrollViewIntegration], isSelected: true)
let interstitialAdmobProvider = Provider(name: .admob, integrations: [scrollViewIntegration], isSelected: false)

// Native Providers
let nativeDirectProvider = Provider(name: .direct, integrations: [
    tableViewIntegration,
    collectionViewIntegration,
    tableTagViewIntegration,
], isSelected: true)
let nativeAdmobProvider = Provider(name: .admob, integrations: [
    tableViewIntegration,
], isSelected: false)
let nativeAppLovinProvider = Provider(name: .appLovin, integrations: [
    tableViewIntegration,
], isSelected: false)
let nativeSASProvider = Provider(name: .sas, integrations: [
    tableViewIntegration,
], isSelected: false)

// CreativeType
var landscape = CreativeType(name: .landscape, isSelected: true)
var vertical = CreativeType(name: .vertical, isSelected: false)
var square = CreativeType(name: .square, isSelected: false)
var carousel = CreativeType(name: .carousel, isSelected: false)
var custom = CreativeType(name: .custom, isSelected: false)
// Specific for AppLovin due to MREC vs Banner
var appLovinMRECLandscape = CreativeType(name: .appLovinMRECLandscape, isSelected: false)
var appLovinMRECVertical = CreativeType(name: .appLovinMRECVertical, isSelected: false)
var appLovinMRECSquare = CreativeType(name: .appLovinMRECSquare, isSelected: false)
var appLovinMRECCarousel = CreativeType(name: .appLovinMRECCarousel, isSelected: false)

var display = CreativeType(name: .nativeDisplay, isSelected: true)

// Integration
let scrollViewIntegration = Integration(name: "ScrollView", imageName: "ScrollView")
let tableViewIntegration = Integration(name: "TableView", imageName: "TableView")
let tableTagViewIntegration = Integration(name: "TableView-Tag", imageName: "TableView")
let collectionViewIntegration = Integration(name: "CollectionView", imageName: "CollectionView")
let pageViewIntegration = Integration(name: "PageView", imageName: "PageView")
let webViewIntegration = Integration(name: "WebView", imageName: "WebView")

enum PID {
    static let directLandscape = "84242"
    static let directVertical = "127546"
    static let directSquare = "127547"
    static let directCarousel = "128779"
    static var directNativeDisplay = "124859"
    static var custom: String {
        get {
            return UserDefaults.standard.string(forKey: "PID") ?? PID.directLandscape
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "PID")
        }
    }

    static let admobLandscape = "ca-app-pub-3068786746829754/2411019030"
    static let admobVertical = "ca-app-pub-3068786746829754/5776283742"
    static let admobSquare = "ca-app-pub-3068786746829754/1034598116"
    static let admobCarousel = "ca-app-pub-3068786746829754/5832124062"
    static let admobNativeDisplay = "ca-app-pub-3068786746829754/6007333247"

    static let sasLandscape = "96445"
    static let sasVertical = "96469"
    static let sasSquare = "96468"
    static let sasCarousel = "96470"
    static let sasNativeDisplay = 102_803

    static let appLovinLandscapeMREC = "ddfc48cc6bd71d73"
    static let appLovinVerticalMREC = "a4f5eb2342e7febb"
    static let appLovinSquareMREC = "512f790c9cf57ccd"
    static let appLovinCarouselMREC = "9b2445c1ac3d55d6"

    static let appLovinLandscape = "eff7e1e4d3096392"
    static let appLovinVertical = "42b9f89963b23101"
    static let appLovinSquare = "4df06edb6937371e"
    static let appLovinCarousel = "373d7d2b25d2d8cc"
    static let appLovinNativeDisplay = "5738024757e4ef72"

    static let admobInterstitial = "ca-app-pub-3068786746829754/9358977978"
    static let admobInterstitialTest = "ca-app-pub-3940256099942544/4411468910"

    // Outbrain widget placements (Direct Feed / Recommendations / Banner / Interstitial)
    static let outbrainArticleUrl = "https://mobile-demo.outbrain.com/"
    static let outbrainInstallationKey = "NANOWDGT01"
    static let feedWidgetId = "MB_1"
    static let recommendationsWidgetId = "SDK_1"
    static let bannerWidgetId = "MB_10"

    static let interstitialDirectArticleUrl = "https://example.com/article"
    static let interstitialDirectWidgetId = "INT_MW_1"

    static let admobBanner = "ca-app-pub-3068786746829754/5448863490"
}

enum FormatName: String {
    case inRead = "Media"
    case native = "Media Native"
    case feed = "Feed"
    case recommendations = "Recommendations"
    case banner = "Anchored Banner"
    case interstitial = "Interstitial"
}

enum ProviderName: String {
    case direct = "Direct"
    case admob = "Admob"
    case sas = "Smart"
    case appLovin = "App Lovin"
}

enum CreativeTypeName: String {
    case landscape = "Landscape"
    case vertical = "Vertical"
    case square = "Square"
    case carousel = "Carousel"
    case custom = "Custom"
    case nativeDisplay = "Display"

    case appLovinMRECLandscape = "Landscape MREC"
    case appLovinMRECVertical = "Vertical MREC"
    case appLovinMRECSquare = "Square MREC"
    case appLovinMRECCarousel = "Carousel MREC"
}
