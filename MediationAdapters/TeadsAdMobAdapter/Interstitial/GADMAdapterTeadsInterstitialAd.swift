//
//  GADMAdapterTeadsInterstitialAd.swift
//  TeadsAdMobAdapter
//
//  Created by Leonid Lemesev on 28/01/2026.
//

import Foundation
import GoogleMobileAds
@_spi(Adapters) import TeadsSDK

// MARK: - GADMAdapterTeadsInterstitialAd

@objc(GADMAdapterTeadsInterstitialAd)
public final class GADMAdapterTeadsInterstitialAd: NSObject, MediationInterstitialAd {
    var delegate: MediationAdEventDelegate?

    var resolveLoad: ((Result<Void, Error>) -> Void)?

    var placement: TeadsAdPlacementInterstitial?
    private var adConfiguration: MediationInterstitialAdConfiguration?

    // MARK: - Load

    public func loadInterstitial(
        for adConfiguration: MediationInterstitialAdConfiguration,
        completionHandler: @escaping GADMediationInterstitialLoadCompletionHandler
    ) {
        if let appIdError = TeadsAdMobErrorMapper.appIdentifierError() {
            delegate = completionHandler(nil, appIdError)
            return
        }
        guard let params = parseParameters(from: adConfiguration) else {
            delegate = completionHandler(nil, TeadsAdMobErrorMapper.error(preRequest: .serverParameters))
            return
        }

        self.adConfiguration = adConfiguration
        resolveLoad = { [weak self] result in
            guard let self else { return }
            switch result {
                case .success:
                    self.delegate = completionHandler(self, nil)
                case let .failure(error):
                    self.delegate = completionHandler(nil, error)
            }
        }

        let publisherFloorPrice = (adConfiguration.extras as? TeadsAdapterSettings)?.floorPrice
        let serverFloorPrice = ServerFloorPriceParser.floorPrice(fromJSON: adConfiguration.credentials.settings["parameter"] as? String)
        let floorPrice = publisherFloorPrice ?? serverFloorPrice

        let config = TeadsAdPlacementInterstitialConfig(
            articleUrl: params.articleUrl,
            widgetId: params.widgetId,
            installationKey: params.installationKey,
            floorPrice: floorPrice
        )

        placement = TeadsAdPlacementInterstitial(config, delegate: self)
        placement?.loadAd()
    }

    // MARK: - Parameter Parsing

    private func parseParameters(from adConfiguration: MediationInterstitialAdConfiguration) -> InterstitialParameters? {
        if let settings = adConfiguration.extras as? TeadsAdapterSettings,
           let dict = try? settings.toDictionary() as? [String: Any] {
            return AdMobParameterParser.parse(fromSettingsDict: dict)
        }
        if let rawParameter = adConfiguration.credentials.settings["parameter"] as? String {
            return AdMobParameterParser.parse(fromCredentialJSON: rawParameter)
        }
        return nil
    }

    // MARK: - Present

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
        AdapterEventBridge.handle(event: event, data: data, delegate: delegate, resolveLoad: &resolveLoad)
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

@_spi(Adapters)
extension GADMAdapterTeadsInterstitialAd: AdapterIntegrationProviding {
    public var adapterIntegrationType: TeadsAdapterIntegrationType {
        .adMob
    }
}
