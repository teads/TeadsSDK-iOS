//
//  CatalogViewModel.swift
//  TeadsSwiftUISampleApp
//
//  Copyright © 2026 Teads. All rights reserved.
//

import Combine
import Foundation
import SwiftUI

/// Drives the catalogue selection.
@MainActor
final class CatalogViewModel: ObservableObject {
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

    @Published var isCustomPIDAlertPresented = false

    @Published var comingSoonMessage: String?

    var availableProviders: [SampleProvider] {
        SampleMatrix.providers(for: format)
    }

    var availableCreatives: [SampleCreative] {
        SampleMatrix.creatives(for: format, provider: provider)
    }

    var availableIntegrations: [SampleIntegration] {
        SampleMatrix.integrations(for: format, provider: provider)
    }

    var showsCreatives: Bool { !availableCreatives.isEmpty }

    private let defaults: UserDefaults
    private static let validationModeKey = "TeadsValidationModeEnabled"

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        validationModeEnabled = defaults.object(forKey: Self.validationModeKey) as? Bool ?? true
    }

    private func onFormatChanged() {
        if let firstProvider = SampleMatrix.providers(for: format).first {
            provider = firstProvider
        }
    }

    private func onProviderChanged() {
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

    func selection(for integration: SampleIntegration) -> SampleSelection {
        SampleSelection(format: format, provider: provider, creative: creative, integration: integration)
    }
}
