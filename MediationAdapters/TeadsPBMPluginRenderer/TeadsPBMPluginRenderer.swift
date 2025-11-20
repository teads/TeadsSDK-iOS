//
//  TeadsPBMPluginRenderer.swift
//  TeadsPBMPluginRenderer
//
//  Refactored by Richard Dépierre on 18/06/2025.
//

import Foundation
import PrebidMobile
import TeadsSDK

@objc public final class TeadsPBMPluginRenderer: NSObject {
    /// Plugin renderer name, used for registration
    public static let name = "teads"

    // MARK: - Internal Properties

    /// Underlying Prebid placement for Teads
    let placement: TeadsPrebidAdPlacement

    /// Adapter settings for Teads requests
    let settings: TeadsAdapterSettings

    /// Mapping of ad unit config fingerprint to event delegates
    var pluginEventDelegates = ThreadSafeDictionary(dict: [String: TeadsPBMEventDelegate]())

    /// Mapping of ad views with loading and interaction delegates
    var adViewContainers = ThreadSafeDictionary(dict: [String: TeadsPBMViewContainer]())

    // MARK: - Initialization

    /// Initialize with optional custom settings
    /// - Parameter settings: Teads adapter settings (integration type/version auto-set)
    @objc public required init?(settings: TeadsAdapterSettings = .init()) {
        // Configure Prebid integration on settings
        settings.setIntegration(type: .prebid, version: "2.0.0")
        settings.adRequestSettings.addExtras("0", for: TeadsAdapterSettings.prebidStandaloneKey)

        self.settings = settings

        // If the placement can not be created there is no point to proceed.
        guard let placement = Teads.createPrebidPlacement(settings: settings.adPlacementSettings) else {
            return nil
        }

        self.placement = placement

        super.init()
        placement.delegate = self
    }

    // MARK: - Error Handling

    /// Log and dispatch errors to Prebid
    /// - Parameter error: Error encountered during rendering
    func dispatchError(_ error: Error) {
        PrebidMobile.Log.error(error)
    }
}
