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
    var integration: Integration
    
    init() {
        format = Formats.inRead.format()
        provider = inReadDirectProvider
        creation = landscape
        integration = scrollViewIntegration
    }
    
}

struct Format {
    let name: FormatName
    var providers: [Provider]
    var isSelected: Bool
}

struct Provider {
    let name: ProviderName
    var integrations: [Integration]
    var isSelected: Bool
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

var inReadFormat = Format(name: .inRead, providers: [inReadDirectProvider, admobDirectProvider, mopubDirectProvider, sasDirectProvider], isSelected: true)
var nativeFormat = Format(name: .native, providers: [], isSelected: false)

// Providers
var inReadDirectProvider = Provider(name: .direct, integrations: [
    scrollViewIntegration,
    tableViewIntegration,
    collectionViewIntegration,
    webViewIntegration
], isSelected: true)
var admobDirectProvider = Provider(name: .admob, integrations: [
    scrollViewIntegration,
    tableViewIntegration,
    webViewIntegration
], isSelected: false)
var mopubDirectProvider = Provider(name: .mopub, integrations: [
    scrollViewIntegration,
    tableViewIntegration
], isSelected: false) 

var sasDirectProvider = Provider(name: .sas, integrations: [
    scrollViewIntegration,
    tableViewIntegration
], isSelected: false)

// CreativeType
var landscape = CreativeType(name: .landscape, isSelected: true)
var vertical = CreativeType(name: .vertical, isSelected: false)
var square = CreativeType(name: .square, isSelected: false)
var carousel = CreativeType(name: .carousel, isSelected: false)
var custom = CreativeType(name: .custom, isSelected: false)

// Integration
let scrollViewIntegration = Integration(name: "ScrollView", imageName: "ScrollView")
let tableViewIntegration = Integration(name: "TableView", imageName: "TableView")
let collectionViewIntegration = Integration(name: "CollectionView", imageName: "CollectionView")
let webViewIntegration = Integration(name: "WebView", imageName: "WebView")

struct PID {
    
    static let directLandscape = "84242"
    static let directVertical = "127546"
    static let directSquare = "127547"
    static let directCarousel = "128779"
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

    static let mopubLandscape = "1d055042d1fc4d5d8240e4dec026f910"
    static let mopubVertical = "ffb910cb8192456f99ae362430a5aa84"
    static let mopubSquare = "d017b5f3e0284a3f8be15e78df49a005"
    static let mopubCarousel = "639e0c172c944f82a61599d8b7a6de4f"
    
    static let sasLandscape = "96445"
    static let sasVertical = "96469"
    static let sasSquare = "96468"
    static let sasCarousel = "96470"
}

enum FormatName: String {
    case inRead = "inRead"
    case native = "Native"
}

enum ProviderName: String {
    case direct = "Direct"
    case admob = "Admob"
    case mopub = "Mopub"
    case sas = "Smart"
}

enum CreativeTypeName: String {
    case landscape = "Landscape"
    case vertical = "Vertical"
    case square = "Square"
    case carousel = "Carousel"
    case custom = "Custom"
}



