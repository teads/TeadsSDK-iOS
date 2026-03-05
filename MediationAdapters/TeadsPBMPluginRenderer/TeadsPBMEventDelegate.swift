//
//  TeadsPBMEventDelegate.swift
//  TeadsPBMPluginRenderer
//
//  Refactored by Richard Dépierre on 18/06/2025.
//

import Foundation
import PrebidMobile
import TeadsSDK

// MARK: - Plugin Event Delegate

/// Protocol for receiving ad lifecycle updates from the Teads Prebid plugin renderer.
/// Conforming types should respond to ratio updates and other lifecycle events
/// (such as full-screen expansion/collapse and load failures) by updating layout
/// and UI state as appropriate (e.g. adjusting view layout based on `TeadsAdRatio`).
public protocol TeadsPBMEventDelegate: PluginEventDelegate {
    func didUpdateRatio(adRatio: TeadsAdRatio)

    func onAdExpandedToFullScreen()

    func onAdCollapsedFromFullScreen()

    func onFailedToLoadAd(reason: String)
}

// MARK: - PluginEventDelegate Implementation

public extension TeadsPBMEventDelegate {
    /// Default implementation returns the registered plugin renderer name.
    func getPluginName() -> String {
        return TeadsPBMPluginRenderer.name
    }
}
