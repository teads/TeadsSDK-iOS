//
//  Format.swift
//  TeadsDemoApp
//
//  Created by Thibaud Saint-Etienne on 09/10/2020.
//  Copyright © 2020 Teads. All rights reserved.
//

import Foundation

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
var inReadFormat = Format(name: .inRead, providers: [inReadDirectProvider, admobDirectProvider, mopubDirectProvider], isSelected: true)
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

// CreativeType
var landscape = CreativeType(name: .landscape, isSelected: true)
var vertical = CreativeType(name: .vertical, isSelected: false)
var square = CreativeType(name: .square, isSelected: false)
var carousel = CreativeType(name: .carousel, isSelected: false)

// Integration
let scrollViewIntegration = Integration(name: "ScrollView", imageName: "ScrollView")
let tableViewIntegration = Integration(name: "TableView", imageName: "TableView")
let collectionViewIntegration = Integration(name: "CollectionView", imageName: "CollectionView")
let webViewIntegration = Integration(name: "WebView", imageName: "WebView")

enum PID: String {
    case directLandscape = "84242"
    case directVertical = "127546"
    case directSquare = "127547"
    case directCarousel = "128779"

    case admobLandscape = "ca-app-pub-3068786746829754/2411019030"
    case admobVertical = "ca-app-pub-3068786746829754/5776283742"
    case admobSquare = "ca-app-pub-3068786746829754/1034598116"
    case admobCarousel = "ca-app-pub-3068786746829754/5832124062"

    case mopubLandscape = "1d055042d1fc4d5d8240e4dec026f910"
    case mopubVertical = "ffb910cb8192456f99ae362430a5aa84"
    case mopubSquare = "d017b5f3e0284a3f8be15e78df49a005"
    case mopubCarousel = "639e0c172c944f82a61599d8b7a6de4f"
}

enum FormatName: String {
    case inRead = "inRead"
    case native = "Native"
}

enum ProviderName: String {
    case direct = "Direct"
    case admob = "Admob"
    case mopub = "Mopub"
}

enum CreativeTypeName: String {
    case landscape = "Landscape"
    case vertical = "Vertical"
    case square = "Square"
    case carousel = "Carousel"
}



