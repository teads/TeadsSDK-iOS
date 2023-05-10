//
//  InReadAdmobScrollViewController.swift
//  TeadsSampleApp
//
//  Copyright © 2018 Teads. All rights reserved.
//

import GoogleMobileAds
import TeadsAdMobAdapter
import TeadsSDK
import UIKit

class InReadAdmobScrollViewController: TeadsViewController {
    var bannerView: GAMBannerView!
    @IBOutlet var slotView: UIView!
    @IBOutlet var slotViewHeightConstraint: NSLayoutConstraint!
    @IBAction func callResize(_: UIButton) {
        let height = CGFloat.random(in: 200 ..< 400)
        print("random height", height)
        resizeAd(height: height)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // 1. Create AdMob view and add it to hierarchy
        bannerView = GAMBannerView(adSize: GADAdSizeFluid)
        slotView.addSubview(bannerView)

        bannerView.translatesAutoresizingMaskIntoConstraints = false
        bannerView.centerXAnchor.constraint(equalTo: slotView.centerXAnchor).isActive = true
        bannerView.centerYAnchor.constraint(equalTo: slotView.centerYAnchor).isActive = true

        // 2. Attach Delegate (will include Teads events)
        bannerView.adUnitID = "ca-app-pub-3068786746829754/1034598116" // Replace with your adunit
        bannerView.rootViewController = self
        bannerView.delegate = self

        // 3. Load a new ad (this will call AdMob and Teads afterward)
        let adSettings = TeadsAdapterSettings { settings in
            settings.enableDebug()
            try? settings.registerAdView(bannerView, delegate: self)
            // Needed by european regulation
            // See https://mobile.teads.tv/sdk/documentation/ios/gdpr-consent
            // settings.userConsent(subjectToGDPR: "1", consent: "0001100101010101")

            // The article url if you are a news publisher
            // settings.pageUrl("http://page.com/article1")
        }

        let request = GAMRequest()
        request.publisherProvidedID = "0ead6fa8215c272fd1d85bcb1c67e181"
        request.customTargeting = [
            "darkmode": "false",
            "language": "de",
            "fr": "false",
            "iosbuild": "",
            "userloggedin": "false",
            "pagetype": "story",
            "gpsenabled": "false",
            "gb_beagle_id": "0ead6fa8215c272fd1d85bcb1c67e181",
            "storyId": "688874247994",
        ]
        request.register(adSettings)

        bannerView.load(request)
    }

    private func resizeAd(height: CGFloat) {
        slotViewHeightConstraint.constant = height
        bannerView.resize(GADAdSizeFromCGSize(CGSize(width: slotView.frame.width, height: height)))
    }
}

extension InReadAdmobScrollViewController: GADBannerViewDelegate {
    func bannerViewDidReceiveAd(_: GADBannerView) {
        // not used
    }

    /// Tells the delegate an ad request failed.
    func bannerView(_: GADBannerView, didFailToReceiveAdWithError error: Error) {
        resizeAd(height: 0)
        print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }

    /// Tells the delegate that a full-screen view will be presented in response
    /// to the user clicking on an ad.
    func bannerViewWillPresentScreen(_: GADBannerView) {
        // not used
    }

    /// Tells the delegate that the full-screen view will be dismissed.
    func bannerViewWillDismissScreen(_: GADBannerView) {
        // not used
    }

    /// Tells the delegate that the full-screen view has been dismissed.
    func bannerViewDidDismissScreen(_: GADBannerView) {
        // not used
    }
}

extension InReadAdmobScrollViewController: TeadsMediatedAdViewDelegate {
    func didUpdateRatio(_: UIView, adRatio: TeadsAdRatio) {
        resizeAd(height: adRatio.calculateHeight(for: slotView.frame.width))
    }
}
