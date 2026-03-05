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

    /// Adapter settings for Teads requests
    let settings: TeadsAdapterSettings

    /// Prebid placement — handles loading winning bid ADM responses
    var placement: TeadsPrebidAdPlacement?

    /// Mapping of ad unit config fingerprint to event delegates
    var pluginEventDelegates = ThreadSafeDictionary(dict: [String: TeadsPBMEventDelegate]())

    /// Mapping of ad views with loading and interaction delegates
    var adViewContainers = ThreadSafeDictionary(dict: [String: TeadsPBMViewContainer]())

    /// Queue to synchronize access to `lastRegisteredFingerprint`
    private let lastRegisteredFingerprintQueue = DispatchQueue(label: "TeadsPBMPluginRenderer.lastRegisteredFingerprintQueue", attributes: .concurrent)

    /// Backing storage for `lastRegisteredFingerprint`
    private var _lastRegisteredFingerprint: String?

    /// Last fingerprint passed to registerEventDelegate, used to bridge containers
    var lastRegisteredFingerprint: String? {
        get {
            lastRegisteredFingerprintQueue.sync {
                _lastRegisteredFingerprint
            }
        }
        set {
            lastRegisteredFingerprintQueue.sync(flags: .barrier) {
                _lastRegisteredFingerprint = newValue
            }
        }
    }

    // MARK: - Initialization

    /// Initialize with optional custom settings
    /// - Parameter settings: Teads adapter settings (integration type/version auto-set)
    @objc public required init?(settings: TeadsAdapterSettings = .init()) {
        settings.setIntegration(type: .prebid, version: "2.0.0")
        settings.adRequestSettings.addExtras("0", for: TeadsAdapterSettings.prebidStandaloneKey)
        self.settings = settings
        super.init()
        placement = Teads.createPrebidPlacement(settings: settings.adPlacementSettings, delegate: self)
    }

    // MARK: - Error Handling

    /// Log and dispatch errors to Prebid
    /// - Parameter error: Error encountered during rendering
    func dispatchError(_ error: Error) {
        PrebidMobile.Log.error(error)
    }

    /// Safely execute a block on the main thread without risking a deadlock.
    func runOnMain(_ block: @escaping () -> Void) {
        if Thread.isMainThread {
            block()
        } else {
            DispatchQueue.main.async(execute: block)
        }
    }

    // MARK: - Ad Resizing

    /// Syncs the resize subscription flag with ad request settings so the JS engine
    /// returns the correct `resize` value in `getPrebidRequestData`. Mirrors Android's `setAdResizingSubscription()`.
    func updateAdResizingSubscription() {
        let value = pluginEventDelegates.isEmpty ? "0" : "1"
        settings.adRequestSettings.addExtras(value, for: "hasSubscribedToAdResizing")
    }
}
