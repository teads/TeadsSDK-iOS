//
//  BannerConfigBuilder.swift
//  TeadsAdMobAdapter
//

import Foundation
import TeadsSDK

/// Builds the banner-path placement config for the AdMob banner adapter from the parsed
/// banner parameters and the raw GAM dashboard credentials JSON.
///
/// Pure — no side effects, no platform dependencies — so it can be unit-tested in
/// isolation without subclassing `MediationBannerAdConfiguration`.
enum BannerConfigBuilder {
    static func make(
        params: BannerParameters,
        credentialsJSON: String?
    ) -> TeadsAdPlacementBannerConfig {
        TeadsAdPlacementBannerConfig(
            articleUrl: params.articleUrl,
            widgetId: params.widgetId,
            installationKey: params.installationKey,
            widgetIndex: params.widgetIndex ?? 0,
            userId: params.userId,
            darkMode: params.darkMode ?? false,
            extId: params.extId,
            extSecondaryId: params.extSecondaryId,
            obPubImp: params.obPubImp,
            floorPrice: ServerFloorPriceParser.floorPrice(fromJSON: credentialsJSON)
        )
    }
}
