//
//  GADMAdapterTeadsBannerAd.swift
//  TeadsAdMobAdapter
//
//  Created by Thibaud Saint-Etienne on 27/10/2022.
//

import Foundation
import GoogleMobileAds
@_spi(Adapters) import TeadsSDK

@objc(GADMAdapterTeadsBannerAd)
public final class GADMAdapterTeadsBannerAd: NSObject, MediationBannerAd {
    // MARK: InRead path

    /// The Teads Ad network InRead AdView
    private var bannerAd: TeadsInReadAdView?
    private var placement: TeadsInReadAdPlacement?
    private var adSettings: TeadsAdapterSettings?

    // MARK: Banner path

    private var bannerPlacement: TeadsAdPlacementBanner?
    private var bannerWrapperView: UIView?

    // MARK: Shared

    var delegate: MediationAdEventDelegate?

    var resolveLoad: ((Result<Void, Error>) -> Void)?

    private var adConfiguration: MediationBannerAdConfiguration?

    public var view: UIView {
        bannerWrapperView ?? bannerAd ?? UIView()
    }

    // MARK: - Load

    public func loadBanner(
        for adConfiguration: MediationBannerAdConfiguration,
        completionHandler: @escaping GADMediationBannerLoadCompletionHandler
    ) {
        if let appIdError = TeadsAdMobErrorMapper.appIdentifierError() {
            delegate = completionHandler(nil, appIdError)
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

        if let params = parseBannerParameters(from: adConfiguration) {
            loadBannerPlacement(adConfiguration: adConfiguration, params: params)
        } else {
            loadInReadBanner(from: adConfiguration)
        }
    }

    private func loadBannerPlacement(
        adConfiguration: MediationBannerAdConfiguration,
        params: BannerParameters
    ) {
        let config = BannerConfigBuilder.make(
            params: params,
            credentialsJSON: adConfiguration.credentials.settings["parameter"] as? String
        )
        let placement = TeadsAdPlacementBanner(config, delegate: self)
        bannerPlacement = placement
        bannerWrapperView = makeBannerWrapperView(adView: placement.getAdView(), adSize: adConfiguration.adSize.size)
    }

    private func loadInReadBanner(from adConfiguration: MediationBannerAdConfiguration) {
        guard let rawPid = adConfiguration.credentials.settings["parameter"] as? String,
              let pid = Int(rawPid) else {
            if let resolveLoad {
                self.resolveLoad = nil
                resolveLoad(.failure(TeadsAdMobErrorMapper.error(preRequest: .placementIdentifierMissing)))
            }
            return
        }

        let adSettings = (adConfiguration.extras as? TeadsAdapterSettings) ?? TeadsAdapterSettings()
        adSettings.setIntegration(type: .adMob, version: AdMobHelper.getGMAVersionNumber())
        self.adSettings = adSettings

        let adSize = adConfiguration.adSize.size
        bannerAd = TeadsInReadAdView(frame: CGRect(origin: .zero, size: adSize))
        placement = Teads.createInReadPlacement(pid: pid, settings: adSettings.adPlacementSettings, delegate: self)
        placement?.requestAd(requestSettings: adSettings.adRequestSettings)
    }

    // MARK: - Parameter Parsing

    private func parseBannerParameters(from adConfiguration: MediationBannerAdConfiguration) -> BannerParameters? {
        if let settings = adConfiguration.extras as? TeadsAdapterSettings,
           let dict = try? settings.toDictionary() as? [String: Any] {
            return AdMobParameterParser.parse(fromSettingsDict: dict)
        }
        if let rawParameter = adConfiguration.credentials.settings["parameter"] as? String {
            return AdMobParameterParser.parse(fromCredentialJSON: rawParameter)
        }
        return nil
    }

    // MARK: - Banner view bridging

    // GMA positions MediationBannerAd.view by frame, but getAdView() uses Auto Layout and
    // needs constraints — wrap it so neither side collapses to 0×0.
    private func makeBannerWrapperView(adView: UIView, adSize: CGSize) -> UIView {
        let wrapper = UIView(frame: CGRect(origin: .zero, size: adSize))
        wrapper.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        adView.translatesAutoresizingMaskIntoConstraints = false
        wrapper.addSubview(adView)
        NSLayoutConstraint.activate([
            adView.leadingAnchor.constraint(equalTo: wrapper.leadingAnchor),
            adView.trailingAnchor.constraint(equalTo: wrapper.trailingAnchor),
            adView.topAnchor.constraint(equalTo: wrapper.topAnchor),
            adView.bottomAnchor.constraint(equalTo: wrapper.bottomAnchor),
        ])
        return wrapper
    }
}

// MARK: - TeadsInReadAdPlacementDelegate (InRead path)

extension GADMAdapterTeadsBannerAd: TeadsInReadAdPlacementDelegate {
    public func didReceiveAd(ad: TeadsInReadAd, adRatio: TeadsAdRatio) {
        ad.delegate = self
        bannerAd?.bind(ad)
        if adSettings?.hasSubscribedToAdResizing ?? false {
            bannerAd?.updateHeight(with: adRatio)
        }
        guard let resolveLoad else { return }
        self.resolveLoad = nil
        resolveLoad(.success(()))
    }

    public func didFailToReceiveAd(reason: AdFailReason) {
        guard let resolveLoad else { return }
        self.resolveLoad = nil
        resolveLoad(.failure(TeadsAdMobErrorMapper.error(from: reason)))
    }

    public func adOpportunityTrackerView(trackerView _: TeadsAdOpportunityTrackerView) {
        // adOpportunityTrackerView is handled by TeadsSDK
    }

    public func didUpdateRatio(ad _: TeadsInReadAd, adRatio: TeadsAdRatio) {
        if adSettings?.hasSubscribedToAdResizing ?? false {
            bannerAd?.updateHeight(with: adRatio)
        }
    }
}

// MARK: - TeadsAdDelegate (InRead path)

extension GADMAdapterTeadsBannerAd: TeadsAdDelegate {
    public func didRecordImpression(ad _: TeadsAd) {
        delegate?.reportImpression()
    }

    public func didRecordClick(ad _: TeadsAd) {
        delegate?.reportClick()
    }

    public func willPresentModalView(ad _: TeadsAd) -> UIViewController? {
        delegate?.willPresentFullScreenView()
        return adConfiguration?.topViewController
    }

    public func didCatchError(ad _: TeadsAd, error: Error) {
        delegate?.didFailToPresentWithError(error)
    }

    public func didExpandedToFullscreen(ad _: TeadsAd) {
        delegate?.willPresentFullScreenView()
    }

    public func didCollapsedFromFullscreen(ad _: TeadsAd) {
        delegate?.didDismissFullScreenView()
    }
}

// MARK: - TeadsAdPlacementEventsDelegate (Banner path)

extension GADMAdapterTeadsBannerAd: TeadsAdPlacementEventsDelegate {
    public func adPlacement(
        _: TeadsAdPlacementIdentifiable?,
        didEmitEvent event: TeadsAdPlacementEventName,
        data: [String: Any]?
    ) {
        AdapterEventBridge.handle(event: event, data: data, delegate: delegate, resolveLoad: &resolveLoad)
    }
}

@_spi(Adapters)
extension GADMAdapterTeadsBannerAd: AdapterIntegrationProviding {
    public var adapterIntegrationType: TeadsAdapterIntegrationType {
        .adMob
    }
}
