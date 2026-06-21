//
//  CatalogViewModel.swift
//  TeadsSwiftUISampleApp
//
//  Copyright © 2026 Teads. All rights reserved.
//

import Combine
import Foundation
import SwiftUI

/// Drives the root catalogue selection (Format → Provider → Creative → Integration).
///
/// Mirrors the UIKit `RootViewController`'s `AdSelection` state machine, plus the validation toggle
/// and the custom-PID dialog, all persisted in `UserDefaults` for parity with the UIKit sample.
@MainActor
final class CatalogViewModel: ObservableObject {
    // MARK: Selection state

    @Published var format: SampleFormat = .inRead {
        didSet { onFormatChanged() }
    }

    @Published var provider: SampleProvider = .direct {
        didSet { onProviderChanged() }
    }

    @Published var creative: SampleCreative = .landscape

    @Published var validationModeEnabled: Bool {
        didSet { defaults.set(validationModeEnabled, forKey: Self.validationModeKey) }
    }

    /// Drives presentation of the "Custom PID" alert.
    @Published var isCustomPIDAlertPresented = false

    /// Drives presentation of the "Coming soon" alert.
    @Published var comingSoonMessage: String?

    // MARK: Derived options

    var availableProviders: [SampleProvider] {
        SampleMatrix.providers(for: format)
    }

    var availableCreatives: [SampleCreative] {
        SampleMatrix.creatives(for: format, provider: provider)
    }

    var availableIntegrations: [SampleIntegration] {
        SampleMatrix.integrations(for: format, provider: provider)
    }

    /// Format/Provider currently support Interstitial without creative pills.
    var showsCreatives: Bool { !availableCreatives.isEmpty }

    // MARK: Init

    private let defaults: UserDefaults
    private static let validationModeKey = "TeadsValidationModeEnabled"

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        validationModeEnabled = defaults.object(forKey: Self.validationModeKey) as? Bool ?? true
    }

    // MARK: Selection transitions

    private func onFormatChanged() {
        // Reset provider and creative to a valid default for the new format.
        if let firstProvider = SampleMatrix.providers(for: format).first {
            provider = firstProvider // triggers onProviderChanged
        }
    }

    private func onProviderChanged() {
        // Reset creative to the first valid one for the new provider.
        if let firstCreative = SampleMatrix.creatives(for: format, provider: provider).first {
            creative = firstCreative
        }
    }

    func selectFormat(_ newFormat: SampleFormat) {
        format = newFormat
        if SampleMatrix.providers(for: newFormat).isEmpty {
            comingSoonMessage = "This format is not available yet."
        }
    }

    func selectProvider(_ newProvider: SampleProvider) {
        provider = newProvider
    }

    func selectCreative(_ newCreative: SampleCreative) {
        creative = newCreative
        if newCreative == .custom {
            isCustomPIDAlertPresented = true
        }
    }

    // MARK: Resolved selection for downstream samples

    func selection(for integration: SampleIntegration) -> SampleSelection {
        SampleSelection(format: format, provider: provider, creative: creative, integration: integration)
    }
}
