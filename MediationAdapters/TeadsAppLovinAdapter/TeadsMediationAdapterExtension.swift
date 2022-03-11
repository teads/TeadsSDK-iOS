//
//  MAAdapterTeadsExtension.swift
//  TeadsAppLovinAdapter
//
//  Created by Paul Nicolas on 15/02/2022.
//

import TeadsSDK
import AppLovinSDK

@objc public extension MANativeAdLoader {
    func register(teadsAdSettings: TeadsAdapterSettings) {
        guard let extra = try? teadsAdSettings.toDictionary() else {
            return
        }
        for (hashableKey, value) in extra {
            guard let key = hashableKey as? String else {
                return
            }
            setLocalExtraParameterForKey(key, value: value)
        }
    }
}

@objc public extension MAAdView {
    func register(teadsAdSettings: TeadsAdapterSettings) {
        guard let extra = try? teadsAdSettings.toDictionary() else {
            return
        }
        for (hashableKey, value) in extra {
            guard let key = hashableKey as? String else {
                return
            }
            setLocalExtraParameterForKey(key, value: value)
        }
    }
}

extension TeadsAdapterSettings {
    @nonobjc internal class func instance(fromAppLovinParameters dictionary: [AnyHashable: Any]?) throws -> TeadsAdapterSettings {
        let adapterVersion = ALSdk.version()
        let adSettings = try TeadsAdapterSettings.instance(from: dictionary ?? Dictionary())

        adSettings.addExtras(TeadsAdapterSettings.integrationMopub, for: TeadsAdapterSettings.integrationTypeKey)
        adSettings.addExtras(adapterVersion, for: TeadsAdapterSettings.integrationVersionKey)
        adSettings.setIntegation(TeadsAdapterSettings.integrationMopub, version: adapterVersion)
        return adSettings
    }
}
