//
//  GADMAdapterTeadsBanner.swift
//  TeadsAdMobAdapter
//
//  Created by Jérémy Grosjean on 07/06/2021.
//

import Foundation
import GoogleMobileAds
import TeadsSDK

@objc(GADMAdapterTeadsBanner)
public final class GADMAdapterTeadsBanner: GADMAdapterTeadsCustomEvent {
    fileprivate var bannerAd: GADMAdapterTeadsBannerAd?

    public func loadBanner(
        for adConfiguration: GADMediationBannerAdConfiguration,
        completionHandler: @escaping GADMediationBannerLoadCompletionHandler
    ) {
        bannerAd = GADMAdapterTeadsBannerAd()
        bannerAd?.loadBanner(for: adConfiguration, completionHandler: completionHandler)
    }
}
