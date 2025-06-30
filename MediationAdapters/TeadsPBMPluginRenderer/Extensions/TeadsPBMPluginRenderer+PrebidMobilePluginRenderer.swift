//
//  TeadsPBMPluginRenderer+PrebidMobilePluginRenderer.swift
//  TeadsPBMPluginRenderer
//
//  Created by Leonid Lemesev on 18/06/2025.
//

import PrebidMobile
import TeadsSDK

// MARK: - PrebidMobilePluginRenderer Conformance

extension TeadsPBMPluginRenderer: PrebidMobilePluginRenderer {
    /// Plugin name used by Prebid SDK
    public var name: String { Self.name }

    /// Plugin renderer version (Teads SDK version)
    public var version: String { Teads.sdkVersion }

    /// Data dictionary returned after bidding
    public var data: [String: Any]? {
        do {
            let rawData = try placement.getData(requestSettings: settings.adRequestSettings)
            return Dictionary(uniqueKeysWithValues: rawData.map { (String(describing: $0.key), $0.value) })
        } catch {
            dispatchError(error)
            return [:]
        }
    }

    /// Called by Prebid when it starts sending lifecycle events for an ad unit
    public func registerEventDelegate(
        pluginEventDelegate: TeadsPBMEventDelegate,
        adUnitConfigFingerprint: String
    ) {
        pluginEventDelegates[adUnitConfigFingerprint] = pluginEventDelegate
    }

    /// Called by Prebid when it stops sending lifecycle events
    public func unregisterEventDelegate(
        pluginEventDelegate _: TeadsPBMEventDelegate,
        adUnitConfigFingerprint: String
    ) {
        pluginEventDelegates.removeValue(forKey: adUnitConfigFingerprint)
    }

    /// Create and load a banner view
    public func createBannerView(
        with frame: CGRect,
        bid: Bid,
        adConfiguration _: AdUnitConfig,
        loadingDelegate: any DisplayViewLoadingDelegate,
        interactionDelegate: any DisplayViewInteractionDelegate
    ) -> (any UIView & PrebidMobileDisplayViewProtocol)? {
        let prebidDisplayView = TeadsPBMDisplayView(frame: frame)

        let adViewContainer = TeadsPBMViewContainer(
            adView: prebidDisplayView,
            loadingDelegate: loadingDelegate,
            interactionDelegate: interactionDelegate
        )

        // Clean up previous delegates for this ad unit and put the new one
        adViewContainers
            .filter { $0.value.loadingDelegate != nil && $0.value.interactionDelegate != nil }
            .forEach { adViewContainers.removeValue(forKey: $0.key) }

        // Loading ad
        do {
            let adResponse = try bid.stringify()
            let loadId = placement.loadAd(
                adResponse: adResponse,
                requestSettings: settings.adRequestSettings
            )

            adViewContainers[loadId.uuidString] = adViewContainer
            return prebidDisplayView
        } catch {
            dispatchError(error)
            return nil
        }
    }

    /// Create interstitial controller (unsupported)
    public func createInterstitialController(
        bid _: Bid,
        adConfiguration _: AdUnitConfig,
        loadingDelegate _: any InterstitialControllerLoadingDelegate,
        interactionDelegate _: any InterstitialControllerInteractionDelegate
    ) -> (any PrebidMobileInterstitialControllerProtocol)? {
        return nil
    }
}
