//
//  GADMAdapterTeadsInterstitialAd.swift
//  TeadsAdMobAdapter
//
//  Created by Leonid Lemesev on 28/01/2026.
//

import Foundation
import GoogleMobileAds
import TeadsSDK

// MARK: - Interstitial Parameters

/// Typed parameters required to create an interstitial placement.
private struct InterstitialParameters: Decodable {
    let articleUrl: URL
    let widgetId: String
    let installationKey: String
}

/// Wrapper for decoding interstitial params from TeadsAdapterSettings serialized dict.
private struct AdapterSettingsWrapper: Decodable {
    let adRequestSettings: RequestSettings

    struct RequestSettings: Decodable {
        let extras: InterstitialParameters
    }
}

// MARK: - GADMAdapterTeadsInterstitialAd

@objc(GADMAdapterTeadsInterstitialAd)
public final class GADMAdapterTeadsInterstitialAd: NSObject, MediationInterstitialAd {
    /// The ad event delegate to forward ad rendering events to the Google Mobile Ads SDK.
    var delegate: MediationInterstitialAdEventDelegate?

    /// Completion handler called after ad load
    var completionHandler: GADMediationInterstitialLoadCompletionHandler?

    var placement: TeadsAdPlacementInterstitial?
    private var adConfiguration: MediationInterstitialAdConfiguration?

    public func loadInterstitial(
        for adConfiguration: MediationInterstitialAdConfiguration,
        completionHandler: @escaping GADMediationInterstitialLoadCompletionHandler
    ) {
        guard let params = parseParameters(from: adConfiguration) else {
            delegate = completionHandler(nil, TeadsAdapterErrorCode.serverParameterError)
            return
        }

        self.completionHandler = completionHandler
        self.adConfiguration = adConfiguration

        let config = TeadsAdPlacementInterstitialConfig(
            articleUrl: params.articleUrl,
            widgetId: params.widgetId,
            installationKey: params.installationKey
        )

        placement = TeadsAdPlacementInterstitial(config, delegate: self)
        placement?.loadAd()
    }

    private func parseParameters(from adConfiguration: MediationInterstitialAdConfiguration) -> InterstitialParameters? {
        // Accept TeadsAdapterSettings (registered via networkExtrasClass)
        if let settings = adConfiguration.extras as? TeadsAdapterSettings,
           let dict = try? settings.toDictionary(),
           let data = try? JSONSerialization.data(withJSONObject: dict),
           let wrapper = try? JSONDecoder().decode(AdapterSettingsWrapper.self, from: data) {
            return wrapper.adRequestSettings.extras
        }

        // Fall back to credentials from server (production)
        if let rawParameter = adConfiguration.credentials.settings["parameter"] as? String,
           let data = rawParameter.data(using: .utf8),
           let params = try? JSONDecoder().decode(InterstitialParameters.self, from: data) {
            return params
        }

        return nil
    }

    public func present(from viewController: UIViewController) {
        placement?.show(from: viewController)
    }
}

// MARK: - TeadsAdPlacementEventsDelegate

extension GADMAdapterTeadsInterstitialAd: TeadsAdPlacementEventsDelegate {
    public func adPlacement(
        _: TeadsAdPlacementIdentifiable?,
        didEmitEvent event: TeadsAdPlacementEventName,
        data: [String: Any]?
    ) {
        switch event {
            case .ready:
                if let completionHandler {
                    delegate = completionHandler(self, nil)
                    self.completionHandler = nil
                }

            case .failed:
                let reason = data?["reason"] as? String ?? "Unknown error"
                let error = NSError(
                    domain: TeadsAdapterErrorCode.errorDomain,
                    code: TeadsAdapterErrorCode.loadError.rawValue,
                    userInfo: [NSLocalizedDescriptionKey: reason]
                )
                if let completionHandler {
                    delegate = completionHandler(nil, error)
                    self.completionHandler = nil
                } else {
                    delegate?.didFailToPresentWithError(error)
                }

            case .clicked:
                delegate?.reportClick()

            case .viewed:
                delegate?.reportImpression()

            default:
                break
        }
    }
}

// MARK: - TeadsFullScreenEventsDelegate

extension GADMAdapterTeadsInterstitialAd: TeadsFullScreenEventsDelegate {
    public func fullScreenPlacement(
        _: TeadsAdPlacementIdentifiable?,
        didEmitEvent event: TeadsFullScreenEventName,
        data _: [String: Any]?
    ) {
        switch event {
            case .willPresent:
                delegate?.willPresentFullScreenView()
            case .presented:
                break // GMA SDK has no corresponding callback for "presented"
            case .willDismiss:
                delegate?.willDismissFullScreenView()
            case .dismissed:
                delegate?.didDismissFullScreenView()
            @unknown default:
                break
        }
    }
}
