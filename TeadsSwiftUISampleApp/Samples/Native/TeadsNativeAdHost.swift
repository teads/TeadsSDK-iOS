//
//  TeadsNativeAdHost.swift
//  TeadsSwiftUISampleApp
//
//  Copyright © 2026 Teads. All rights reserved.
//

import SwiftUI
import TeadsSDK

/// Hosts a Teads `TeadsNativeAdView` (driven by `TeadsAdPlacementMediaNative`) inside SwiftUI.
///
/// Mirrors the wiring done by the UIKit `NativeDirectTableViewController`: create the placement,
/// call `loadAd()`, and pass the bind closure a `TeadsNativeAdView`.
struct TeadsNativeAdHost: UIViewRepresentable {
    let pid: Int
    let validationMode: Bool

    func makeCoordinator() -> Coordinator { Coordinator() }

    func makeUIView(context: Context) -> UIView {
        let adView = TeadsNativeAdView()
        adView.translatesAutoresizingMaskIntoConstraints = false

        let config = TeadsAdPlacementMediaConfig(
            pid: pid,
            articleUrl: SamplePID.articleURL,
            enableValidationMode: validationMode
        )
        let placement: TeadsAdPlacementMediaNative? = Teads.createPlacement(with: config, delegate: context.coordinator)
        context.coordinator.placement = placement

        if let bindClosure = try? placement?.loadAd() {
            bindClosure(adView)
        }
        return adView
    }

    func updateUIView(_: UIView, context _: Context) {}

    final class Coordinator: NSObject, TeadsAdPlacementEventsDelegate {
        var placement: TeadsAdPlacementMediaNative?

        func adPlacement(
            _: (any TeadsAdPlacementIdentifiable)?,
            didEmitEvent event: TeadsAdPlacementEventName,
            data _: [String: Any]?
        ) {
            switch event {
                case .ready: print("Teads Native ad ready")
                case .viewed: print("Teads Native ad viewed")
                case .clicked: print("Teads Native ad clicked")
                case .failed: print("Teads Native ad failed")
                default: break
            }
        }
    }
}
