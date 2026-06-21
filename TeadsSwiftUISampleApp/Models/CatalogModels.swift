//
//  CatalogModels.swift
//  TeadsSwiftUISampleApp
//
//  Copyright © 2026 Teads. All rights reserved.
//

import Foundation

// MARK: Format / Provider / Creative / Integration

/// Top-level ad format. Matches the UIKit sample's `Formats`.
enum SampleFormat: String, CaseIterable, Identifiable {
    case inRead
    case native = "Native"
    case interstitial = "Interstitial"

    var id: String { rawValue }
    var displayName: String { rawValue }
}

/// Demand source / SDK provider.
enum SampleProvider: String, CaseIterable, Identifiable {
    case direct = "Direct"
    case admob = "Admob"
    case sas = "Smart"
    case appLovin = "App Lovin"

    var id: String { rawValue }
    var displayName: String { rawValue }
}

/// Creative type. Mirrors the UIKit sample's `CreativeTypeName`.
enum SampleCreative: String, CaseIterable, Identifiable {
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

    var id: String { rawValue }
    var displayName: String { rawValue }
}

/// Container/integration kind. Mirrors the UIKit sample's `Integration` entries.
enum SampleIntegration: String, CaseIterable, Identifiable {
    case scrollView = "ScrollView"
    case tableView = "TableView"
    case tableTagView = "TableView-Tag"
    case collectionView = "CollectionView"
    case pageView = "PageView"
    case webView = "WebView"

    var id: String { rawValue }
    var displayName: String { rawValue }

    /// Asset name of the integration icon (shared with the UIKit catalogue).
    var imageName: String {
        switch self {
            case .scrollView: "ScrollView"
            case .tableView, .tableTagView: "TableView"
            case .collectionView: "CollectionView"
            case .pageView: "PageView"
            case .webView: "WebView"
        }
    }
}

// MARK: Selection rules (mirrors UIKit Format.swift)

enum SampleMatrix {
    /// Default creative list per provider for InRead.
    static let defaultInReadCreatives: [SampleCreative] = [.landscape, .vertical, .square, .carousel, .custom]
    /// AppLovin gets a longer list (banner + MREC variants).
    static let appLovinInReadCreatives: [SampleCreative] = [
        .landscape, .vertical, .square, .carousel,
        .appLovinMRECLandscape, .appLovinMRECVertical, .appLovinMRECSquare, .appLovinMRECCarousel,
        .custom,
    ]
    /// Native uses Display + Custom.
    static let nativeCreatives: [SampleCreative] = [.nativeDisplay, .custom]
    /// Interstitial has no creative pills.
    static let interstitialCreatives: [SampleCreative] = []

    /// Providers offered per format.
    static func providers(for format: SampleFormat) -> [SampleProvider] {
        switch format {
            case .inRead: [.direct, .admob, .sas, .appLovin]
            case .native: [.direct, .admob, .sas, .appLovin]
            case .interstitial: [.admob]
        }
    }

    /// Integration containers offered per (format, provider).
    static func integrations(for format: SampleFormat, provider: SampleProvider) -> [SampleIntegration] {
        switch format {
            case .inRead:
                switch provider {
                    case .direct: [.scrollView, .tableView, .collectionView, .pageView, .webView]
                    case .admob: [.scrollView, .tableView, .webView]
                    case .sas: [.scrollView, .tableView]
                    case .appLovin: [.scrollView]
                }
            case .native:
                switch provider {
                    case .direct: [.tableView, .collectionView, .tableTagView]
                    default: [.tableView]
                }
            case .interstitial:
                [.scrollView]
        }
    }

    /// Creative pills offered per (format, provider).
    static func creatives(for format: SampleFormat, provider: SampleProvider) -> [SampleCreative] {
        switch format {
            case .inRead:
                provider == .appLovin ? appLovinInReadCreatives : defaultInReadCreatives
            case .native: nativeCreatives
            case .interstitial: interstitialCreatives
        }
    }
}

// MARK: Resolved selection (the configuration a sample screen consumes)

/// A fully-resolved selection that downstream sample screens consume.
struct SampleSelection: Equatable {
    var format: SampleFormat = .inRead
    var provider: SampleProvider = .direct
    var creative: SampleCreative = .landscape
    var integration: SampleIntegration = .scrollView

    /// Integer PID for direct/SAS placements.
    var integerPID: Int {
        switch format {
            case .interstitial: return 0
            case .inRead, .native: break
        }
        switch provider {
            case .direct:
                switch creative {
                    case .landscape: return SamplePID.directLandscape
                    case .vertical: return SamplePID.directVertical
                    case .square: return SamplePID.directSquare
                    case .carousel: return SamplePID.directCarousel
                    case .nativeDisplay: return SamplePID.directNativeDisplay
                    case .custom: return SamplePID.custom
                    default: return SamplePID.directLandscape
                }
            case .sas:
                switch creative {
                    case .landscape: return SamplePID.sasLandscape
                    case .vertical: return SamplePID.sasVertical
                    case .square: return SamplePID.sasSquare
                    case .carousel: return SamplePID.sasCarousel
                    case .nativeDisplay: return SamplePID.sasNativeDisplay
                    case .custom: return SamplePID.custom
                    default: return SamplePID.sasLandscape
                }
            default: return SamplePID.directLandscape
        }
    }

    /// String PID for AdMob / AppLovin ad units.
    var stringPID: String {
        switch format {
            case .interstitial: return SamplePID.admobInterstitial
            case .inRead, .native: break
        }
        switch provider {
            case .admob:
                switch creative {
                    case .landscape: return SamplePID.admobLandscape
                    case .vertical: return SamplePID.admobVertical
                    case .square: return SamplePID.admobSquare
                    case .carousel: return SamplePID.admobCarousel
                    case .nativeDisplay: return SamplePID.admobNativeDisplay
                    case .custom: return "\(SamplePID.custom)"
                    default: return SamplePID.admobLandscape
                }
            case .appLovin:
                switch creative {
                    case .landscape: return SamplePID.appLovinLandscape
                    case .vertical: return SamplePID.appLovinVertical
                    case .square: return SamplePID.appLovinSquare
                    case .carousel: return SamplePID.appLovinCarousel
                    case .appLovinMRECLandscape: return SamplePID.appLovinLandscapeMREC
                    case .appLovinMRECVertical: return SamplePID.appLovinVerticalMREC
                    case .appLovinMRECSquare: return SamplePID.appLovinSquareMREC
                    case .appLovinMRECCarousel: return SamplePID.appLovinCarouselMREC
                    case .nativeDisplay: return SamplePID.appLovinNativeDisplay
                    case .custom: return "\(SamplePID.custom)"
                }
            default: return "\(integerPID)"
        }
    }

    /// True when the creative is an MREC variant (AppLovin only).
    var isMREC: Bool {
        switch creative {
            case .appLovinMRECLandscape, .appLovinMRECVertical, .appLovinMRECSquare, .appLovinMRECCarousel:
                true
            default: false
        }
    }
}
