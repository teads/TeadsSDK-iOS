//
//  TeadsAdapterExtras-extension.swift
//  TeadsAdMobAdapter
//
//  Created by Paul Nicolas on 13/05/2020.
//  Copyright © 2020 teads. All rights reserved.
//

import Foundation
import TeadsSDK
import GoogleMobileAds

extension TeadsAdapterSettings: GADAdNetworkExtras {
    @nonobjc internal class func instance(fromAdmobParameters dictionary: [AnyHashable: Any]?) throws -> TeadsAdapterSettings {
        let adSettings = try TeadsAdapterSettings.instance(from: dictionary ?? Dictionary())
        adSettings.addExtras(TeadsAdapterSettings.integrationAdmob, for: TeadsAdapterSettings.integrationTypeKey)
        adSettings.addExtras(GADMobileAds.sharedInstance().sdkVersion, for: TeadsAdapterSettings.integrationVersionKey)
        return adSettings
    }
}

@objc public class GADMAdapterTeads: NSObject {
    @objc public static let defaultLabel = "Teads"

    @objc public class func customEventExtra(with teadsAdSettings: TeadsAdapterSettings, for label: String = defaultLabel) -> GADCustomEventExtras {
        let customEventExtras = GADCustomEventExtras()
        if let parameters = try? teadsAdSettings.toDictionary() {
            customEventExtras.setExtras(parameters, forLabel: label)
        }
        return customEventExtras
    }
}

