//
//  Helper.swift
//  Pods
//
//  Created by Thibaud Saint-Etienne on 21/07/2021.
//

import UIKit
import TeadsSDK

struct Helper {
    static func bannerSize(for width: CGFloat) -> CGSize {
        return CGSize(width: width > 0 ? width : 300, height: width/(16/9))
    }
}

@available(*, deprecated, renamed: "TeadsAdapterSettings", message: "Only relevant when using TeadsAdMobAdapter, TeadsMopubAdapter, TeadsSmartAdapter")
public typealias TeadsAdSettings = TeadsAdapterSettings

extension TeadsAdapterSettings {
    func setIntegation(_ integration: String, version: String) {
        addExtras(integration, for: TeadsAdapterSettings.integrationTypeKey)
        addExtras(version, for: TeadsAdapterSettings.integrationVersionKey)
    }
}
