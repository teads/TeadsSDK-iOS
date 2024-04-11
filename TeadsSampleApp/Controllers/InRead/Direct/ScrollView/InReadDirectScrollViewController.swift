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
    var placement: TeadsPrebidAdPlacement?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Create Prebid placement
        let adPlacementSettings = TeadsAdPlacementSettings { settings in
            settings.enableDebug() // remove in production
        }
        placement = Teads.createPrebidPlacement(settings: adPlacementSettings, delegate: self)
        
        // Get the ad request data
        let adRequestSettings = TeadsAdRequestSettings { settings in
            // Ensure to inform your article url or domain url for brand safety matters
            settings.pageUrl("https://www.your.url.com")

            // Add this extra to enable your standalone integration
            settings.addExtras("1", for: TeadsAdapterSettings.prebidStandaloneKey)
        }
        let teadsBidRequestExtraData = try? placement?.getData(requestSettings: adRequestSettings)

        // Prebid request with the getData
        print(teadsBidRequestExtraData)

        // Load ad
        placement?.loadAd(adResponse: PrebidAdResponse.FAKE_WINNING_BID_RESPONSE, requestSettings: adRequestSettings)
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

extension InReadDirectScrollViewController: TeadsInReadAdPlacementDelegate {
    func adOpportunityTrackerView(trackerView: TeadsAdOpportunityTrackerView) {
        teadsAdView.addSubview(trackerView)
    }

    func didReceiveAd(ad: TeadsInReadAd, adRatio: TeadsAdRatio) {
        teadsAdView.bind(ad)
        ad.delegate = self
        resizeTeadsAd(adRatio: adRatio)
    }

    func didFailToReceiveAd(reason _: AdFailReason) {
        closeAd()
    }

    func didUpdateRatio(ad _: TeadsInReadAd, adRatio: TeadsAdRatio) {
        resizeTeadsAd(adRatio: adRatio)
    }
}

extension InReadDirectScrollViewController: TeadsAdDelegate {
    func willPresentModalView(ad _: TeadsAd) -> UIViewController? {
        return self
    }

    func didCatchError(ad _: TeadsAd, error _: Error) {
        closeAd()
    }

    func didClose(ad _: TeadsAd) {
        closeAd()
    }

    func didRecordImpression(ad _: TeadsAd) {}

    func didRecordClick(ad _: TeadsAd) {}

    func didExpandedToFullscreen(ad _: TeadsAd) {}

    func didCollapsedFromFullscreen(ad _: TeadsAd) {}
}
