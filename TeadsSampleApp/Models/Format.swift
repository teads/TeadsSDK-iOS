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
    var creativeTypes: [CreativeType]
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
    case inRead, native
    func format() -> Format {
        switch self {
            case .inRead: return inReadFormat
            case .native: return nativeFormat
        }
    }
}

let defaultInReadCreativeTypes = [landscape, vertical, square, carousel, custom]
let appLovinInReadCreativeTypes = [landscape, vertical, square, carousel, appLovinMRECLandscape, appLovinMRECVertical, appLovinMRECSquare, appLovinMRECCarousel, custom]

let inReadFormat = Format(name: .inRead, providers: [inReadDirectProvider, inReadAdmobProvider, inReadAppLovinProvider, inReadSASProvider], isSelected: true, creativeTypes: defaultInReadCreativeTypes)
let nativeFormat = Format(name: .native, providers: [nativeDirectProvider, nativeAdmobProvider, nativeAppLovinProvider], isSelected: false, creativeTypes: [display, custom])

// inRead Providers
let inReadDirectProvider = Provider(name: .direct, integrations: [
    scrollViewIntegration,
    tableViewIntegration,
    collectionViewIntegration,
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

// Native Providers
let nativeDirectProvider = Provider(name: .direct, integrations: [
    tableViewIntegration,
    collectionViewIntegration,
], isSelected: true)
let nativeAdmobProvider = Provider(name: .admob, integrations: [
    tableViewIntegration,
], isSelected: false)
let nativeAppLovinProvider = Provider(name: .appLovin, integrations: [
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
let collectionViewIntegration = Integration(name: "CollectionView", imageName: "CollectionView")
let webViewIntegration = Integration(name: "WebView", imageName: "WebView")

enum PID {
    static let directLandscape = "84242"
    static let directVertical = "127546"
    static let directSquare = "127547"
    static let directCarousel = "128779"
    static var directNativeDisplay = "124859"
    static var custom: String {
        get {
            return (UserDefaults.standard.string(forKey: "PID") ?? PID.directLandscape)
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

    static let appLovinLandscapeMREC = "33d03d37d70196e3"
    static let appLovinVerticalMREC = "66ff5813c2c2698c"
    static let appLovinSquareMREC = "5512c029c9a2ebd9"
    static let appLovinCarouselMREC = "d60fbc370461602d"

    static let appLovinLandscape = "ebe5409dd16b929d"
    static let appLovinVertical = "808eaa38d08ade2d"
    static let appLovinSquare = "f83b5fc30c17954e"
    static let appLovinCarousel = "21c6dc998b472d8d"
    static let appLovinNativeDisplay = "b87480e23dd55a79"
}

enum FormatName: String {
    case inRead
    case native = "Native"
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
