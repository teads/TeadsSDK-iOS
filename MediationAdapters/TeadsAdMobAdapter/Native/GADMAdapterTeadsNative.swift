//
//  GADMAdapterTeadsNative.swift
//  TeadsAdMobAdapter
//
//  Created by Jérémy Grosjean on 15/06/2021.
//

import GoogleMobileAds
import TeadsSDK
import UIKit

@objc(GADMAdapterTeadsNative)
public final class GADMAdapterTeadsNative: GADMAdapterTeadsCustomEvent {
    fileprivate var nativeAd: GADMAdapterTeadsNativeAd?

    public func loadNativeAd(
        for adConfiguration: GADMediationNativeAdConfiguration,
        completionHandler: @escaping GADMediationNativeLoadCompletionHandler
    ) {
        nativeAd = GADMAdapterTeadsNativeAd()
        nativeAd?.loadNativeAd(for: adConfiguration, completionHandler: completionHandler)
    }
}
