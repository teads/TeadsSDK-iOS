//
//  Format.swift
//  TeadsDemoApp
//
//  Created by Thibaud Saint-Etienne on 09/10/2020.
//  Copyright © 2020 Teads. All rights reserved.
//

import Foundation

struct Format {
    let name: String
    var providers: [Provider]
    var isSelected: Bool
}

struct Provider {
    let name: String
    var integrations: [Integration]
    var isSelected: Bool
}

struct Integration {
    let name: String
    let imageName: String
}

let scrollViewIntegration = Integration(name: "ScrollView", imageName: "ScrollView")
let tableViewIntegration = Integration(name: "TableView", imageName: "TableView")
let collectionViewIntegration = Integration(name: "CollectionView", imageName: "CollectionView")
let webViewIntegration = Integration(name: "WebView", imageName: "WebView")

var inReadDirectProvider = Provider(name: "Direct", integrations: [
    scrollViewIntegration,
    tableViewIntegration,
    collectionViewIntegration,
    webViewIntegration
], isSelected: true)

var admobDirectProvider = Provider(name: "Admob", integrations: [
    scrollViewIntegration,
    tableViewIntegration,
    webViewIntegration
], isSelected: false)

var mopubDirectProvider = Provider(name: "Mopub", integrations: [
    scrollViewIntegration,
    tableViewIntegration
], isSelected: false)

var inReadFormat = Format(name: "inRead", providers: [inReadDirectProvider, admobDirectProvider, mopubDirectProvider], isSelected: true)

var nativeFormat = Format(name: "Native", providers: [], isSelected: false)

