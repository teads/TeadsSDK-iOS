//
//  TeadsPBMPluginRenderer+PrebidMobilePluginRenderer.swift
//  TeadsPBMPluginRenderer
//
//  Created by Leonid Lemesev on 18/06/2025.
//

import PrebidMobile
import TeadsSDK
import UIKit

// MARK: - PrebidMobilePluginRenderer Conformance

extension TeadsPBMPluginRenderer: PrebidMobilePluginRenderer {
    /// Plugin name used by Prebid SDK
    public var name: String { Self.name }

    /// Plugin renderer version (Teads SDK version)
    public var version: String { Teads.sdkVersion }

    /// Data dictionary sent in bid request ext.prebid.sdk.renderers[].data
    public var data: [String: Any]? {
        guard let placement = placement else { return [:] }
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
        pluginEventDelegate: PluginEventDelegate,
        adUnitConfigFingerprint: String
    ) {
        guard let teadsDelegate = pluginEventDelegate as? TeadsPBMEventDelegate else { return }
        pluginEventDelegates[adUnitConfigFingerprint] = teadsDelegate
        lastRegisteredFingerprint = adUnitConfigFingerprint
        updateAdResizingSubscription()
    }

    /// Called by Prebid when it stops sending lifecycle events
    public func unregisterEventDelegate(
        pluginEventDelegate _: PluginEventDelegate,
        adUnitConfigFingerprint: String
    ) {
        pluginEventDelegates.removeValue(forKey: adUnitConfigFingerprint)
        updateAdResizingSubscription()
    }

    /// Create and load a banner view using the winning bid's ADM
    public func createBannerView(
        with frame: CGRect,
        bid: Bid,
        adConfiguration _: AdUnitConfig,
        loadingDelegate: any DisplayViewLoadingDelegate,
        interactionDelegate: any DisplayViewInteractionDelegate
    ) -> (any UIView & PrebidMobileDisplayViewProtocol)? {
        guard let placement = placement else {
            dispatchError(TeadsPBMPluginError.placementInitialization)
            return nil
        }

        // Serialize the winning bid to JSON for the Teads SDK
        guard let adResponse = try? bid.stringify() else {
            dispatchError(TeadsPBMPluginError.jsonSerialization)
            return nil
        }

        let prebidDisplayView = TeadsPBMDisplayView(frame: frame)

        let adViewContainer = TeadsPBMViewContainer(
            adView: prebidDisplayView,
            loadingDelegate: loadingDelegate,
            interactionDelegate: interactionDelegate
        )
        adViewContainer.adUnitConfigFingerprint = lastRegisteredFingerprint

        // Clean up stale containers whose delegates have been deallocated
        adViewContainers
            .filter { $0.value.loadingDelegate == nil || $0.value.interactionDelegate == nil }
            .forEach { adViewContainers.removeValue(forKey: $0.key) }

        // Load the winning bid ADM via Teads SDK
        let loadId = placement.loadAd(
            adResponse: adResponse,
            requestSettings: settings.adRequestSettings
        )
        adViewContainers[loadId.uuidString] = adViewContainer

        return prebidDisplayView
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
