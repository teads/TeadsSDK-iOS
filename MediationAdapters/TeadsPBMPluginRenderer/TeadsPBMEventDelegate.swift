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

/// Protocol for receiving ad size ratio updates from Teads SDK.
/// Conforming types should adjust view layout based on the provided `TeadsAdRatio`.
public protocol TeadsPBMEventDelegate: PluginEventDelegate {
    func didUpdateRatio(adRatio: TeadsAdRatio)

    func onAdExpandedToFullScreen()

    func onAdCollapsedFromFullScreen()

    func onFailedToLoadAd(reason: String)
}

// MARK: - PluginEventDelegate Implementation

public extension TeadsPBMEventDelegate {
    /// Default implementation returns the registered plugin renderer name.
    func getPluginRendererName() -> String {
        return TeadsPBMPluginRenderer.name
    }
}
