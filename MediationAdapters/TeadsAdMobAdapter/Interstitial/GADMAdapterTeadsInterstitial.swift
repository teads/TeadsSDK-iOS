//
//  GADMAdapterTeadsInterstitial.swift
//  TeadsAdMobAdapter
//
//  Created by Leonid Lemesev on 28/01/2026.
//

import Foundation
import GoogleMobileAds
import TeadsSDK

@objc(GADMAdapterTeadsInterstitial)
public final class GADMAdapterTeadsInterstitial: GADMAdapterTeadsCustomEvent {
    private var interstitialAd: GADMAdapterTeadsInterstitialAd?

    public func loadInterstitial(
        for adConfiguration: MediationInterstitialAdConfiguration,
        completionHandler: @escaping GADMediationInterstitialLoadCompletionHandler
    ) {
        interstitialAd = GADMAdapterTeadsInterstitialAd()
        interstitialAd?.loadInterstitial(for: adConfiguration, completionHandler: completionHandler)
    }
}
