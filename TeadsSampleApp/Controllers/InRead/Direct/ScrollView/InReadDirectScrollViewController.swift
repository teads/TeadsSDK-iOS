//
//  InReadDirectScrollViewController.swift
//  TeadsSampleApp
//
//  Created by Jérémy Grosjean on 28/09/2017.
//  Copyright © 2018 Teads. All rights reserved.
//

import TeadsSDK
import UIKit

class InReadDirectScrollViewController: TeadsViewController {
    @IBOutlet var scrollDownImageView: TeadsGradientImageView!
    @IBOutlet var teadsAdView: TeadsInReadAdView!
    @IBOutlet var teadsAdHeightConstraint: NSLayoutConstraint!
    var adRatio: TeadsAdRatio?
    var placement: TeadsAdPlacementMedia?

    override func viewDidLoad() {
        super.viewDidLoad()
        let pSettings = TeadsAdPlacementSettings { settings in
            settings.enableDebug()
        }

        // Create placement with unified API
        let config = TeadsAdPlacementMediaConfig(
            pid: Int(pid) ?? 0,
            articleUrl: URL(string: "https://www.teads.com")
        )
        placement = TeadsAdPlacementMedia(config, delegate: self)

        // Load ad with unified API
        do {
            if let adView = try placement?.loadAd() {
                teadsAdView.addSubview(adView)
                adView.translatesAutoresizingMaskIntoConstraints = false
                adView.topAnchor.constraint(equalTo: teadsAdView.topAnchor).isActive = true
                adView.leadingAnchor.constraint(equalTo: teadsAdView.leadingAnchor).isActive = true
                adView.trailingAnchor.constraint(equalTo: teadsAdView.trailingAnchor).isActive = true
                adView.bottomAnchor.constraint(equalTo: teadsAdView.bottomAnchor).isActive = true
            }
        } catch {
            print("Failed to load ad: \(error)")
            closeAd()
        }
        // We use an observer to know when a rotation happened, to resize the ad
        // You can use whatever way you want to do so
        NotificationCenter.default.addObserver(self, selector: #selector(rotationDetected), name: UIDevice.orientationDidChangeNotification, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc func rotationDetected() {
        if let adRatio = adRatio {
            resizeTeadsAd(adRatio: adRatio)
        }
    }

    func resizeTeadsAd(adRatio: TeadsAdRatio) {
        self.adRatio = adRatio
        teadsAdHeightConstraint.constant = adRatio.calculateHeight(for: teadsAdView.frame.width)
    }

    func closeAd() {
        // be careful if you want to load another ad in the same page don't remove the observer
        NotificationCenter.default.removeObserver(self)
        teadsAdHeightConstraint.constant = 0
    }
}

extension InReadDirectScrollViewController: TeadsAdPlacementEventsDelegate {
    func adPlacement(
        _: TeadsAdPlacementIdentifiable?,
        didEmitEvent event: TeadsAdPlacementEventName,
        data: [String: Any]?
    ) {
        switch event {
            case .ready:
                if let adRatioValue = data?["adRatio"] as? TeadsAdRatio {
                    resizeTeadsAd(adRatio: adRatioValue)
                }
            case .heightUpdated:
                if let height = data?["height"] as? CGFloat {
                    teadsAdHeightConstraint.constant = height
                } else if let adRatioValue = data?["adRatio"] as? TeadsAdRatio {
                    resizeTeadsAd(adRatio: adRatioValue)
                }
            case .failed:
                closeAd()
            case .complete:
                closeAd()
            default:
                break
        }
    }
}

// TeadsAdDelegate is handled through unified events system
