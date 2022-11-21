//
//  TeadsMediationAdapterExtension.swift
//  TeadsAppLovinAdapter
//
//  Created by Paul Nicolas on 15/02/2022.
//

import AppLovinSDK
import TeadsSDK
#if canImport(TeadsAdapterCommon)
import TeadsAdapterCommon
#endif

@objc public extension MANativeAdLoader {
    func register(teadsAdSettings: TeadsAdapterSettings) {
        teadsAdSettings.register(into: self)
    }
}

@objc public extension MAAdView {
    func register(teadsAdSettings: TeadsAdapterSettings) {
        teadsAdSettings.register(into: self)
    }
}

extension TeadsAdapterSettings {
    @nonobjc class func instance(fromAppLovinParameters dictionary: [AnyHashable: Any]?) throws -> TeadsAdapterSettings {
        let adapterVersion = ALSdk.version()
        let adSettings = try TeadsAdapterSettings.instance(from: dictionary ?? Dictionary())
        adSettings.setIntegation(TeadsAdapterSettings.integrationApplovin, version: adapterVersion)
        return adSettings
    }
}

public extension TeadsAdapterSettings {
    func register(into adView: MAAdView) {
        guard let extra = try? toDictionary() else {
            return
        }
        for (hashableKey, value) in extra {
            guard let key = hashableKey as? String else {
                return
            }
            adView.setLocalExtraParameterForKey(key, value: value)
        }
    }

    func register(into adLoader: MANativeAdLoader) {
        guard let extra = try? toDictionary() else {
            return
        }
        for (hashableKey, value) in extra {
            guard let key = hashableKey as? String else {
                return
            }
            adLoader.setLocalExtraParameterForKey(key, value: value)
        }
    }
}
