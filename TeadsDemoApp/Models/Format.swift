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

var inReadDirectProvider = Provider(name: "Direct", integrations: [Integration(name: "scrollView", imageName: "scrollView"),
    Integration(name: "webView", imageName: "webView"),
    Integration(name: "tableView", imageName: "tableView"),
    Integration(name: "collectionView", imageName: "collectionView")
], isSelected: true)

var admobDirectProvider = Provider(name: "Admob", integrations: [Integration(name: "scrollView", imageName: "scrollView"),
    Integration(name: "webView", imageName: "webView"),
    Integration(name: "tableView", imageName: "tableView"),
], isSelected: false)

var mopubDirectProvider = Provider(name: "MoPub", integrations: [Integration(name: "scrollView", imageName: "scrollView"),
    Integration(name: "webView", imageName: "webView"),
    Integration(name: "tableView", imageName: "tableView"),
], isSelected: false)

var inReadFormat = Format(name: "inRead", providers: [inReadDirectProvider, admobDirectProvider, mopubDirectProvider], isSelected: true)

var nativeFormat = Format(name: "native", providers: [], isSelected: false)

