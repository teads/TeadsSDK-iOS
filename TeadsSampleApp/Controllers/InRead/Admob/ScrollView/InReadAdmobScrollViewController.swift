//
//  InReadAdmobScrollViewController.swift
//  TeadsSampleApp
//
//  Copyright © 2018 Teads. All rights reserved.
//

import AdSupport
import AppTrackingTransparency
import GoogleMobileAds
import TeadsAdMobAdapter
import TeadsSDK
import UIKit

func requestPermission() {
    if #available(iOS 14, *) {
        ATTrackingManager.requestTrackingAuthorization { status in
            switch status {
                case .authorized:
                    // Tracking authorization dialog was shown
                    // and we are authorized
                    print("Authorized")

                    // Now that we are authorized we can get the IDFA
                    print(ASIdentifierManager.shared().advertisingIdentifier)
                case .denied:
                    // Tracking authorization dialog was
                    // shown and permission is denied
                    print("Denied")
                case .notDetermined:
                    // Tracking authorization dialog has not been shown
                    print("Not Determined")
                case .restricted:
                    print("Restricted")
                @unknown default:
                    print("Unknown")
            }
        }
    }
}

class InReadAdmobScrollViewController: TeadsViewController {
    var bannerView: AdManagerBannerView!
    @IBOutlet var slotView: UIView!
    @IBOutlet var slotViewHeightConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        requestPermission()
        // 1. Create AdMob view and add it to hierarchy
        bannerView = GAMBannerView(adSize: GADAdSizeFluid)
        slotView.addSubview(bannerView)

        bannerView.translatesAutoresizingMaskIntoConstraints = false
        bannerView.centerXAnchor.constraint(equalTo: slotView.centerXAnchor).isActive = true
        bannerView.centerYAnchor.constraint(equalTo: slotView.centerYAnchor).isActive = true

        // 2. Attach Delegate (will include Teads events)
        bannerView.adUnitID = pid // Replace with your adunit
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

        let request = GADRequest()
        request.register(adSettings)

        bannerView.load(request)
    }

    private func resizeAd(height: CGFloat) {
        slotViewHeightConstraint.constant = height
        bannerView.resize(GADAdSizeFromCGSize(CGSize(width: slotView.frame.width, height: height)))
    }
}

extension InReadAdmobScrollViewController: BannerViewDelegate {
    func bannerViewDidReceiveAd(_: BannerView) {
        // not used
    }

    /// Tells the delegate an ad request failed.
    func bannerView(_: BannerView, didFailToReceiveAdWithError error: Error) {
        resizeAd(height: 0)
        print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }

    /// Tells the delegate that a full-screen view will be presented in response
    /// to the user clicking on an ad.
    func bannerViewWillPresentScreen(_: BannerView) {
        // not used
    }

    /// Tells the delegate that the full-screen view will be dismissed.
    func bannerViewWillDismissScreen(_: BannerView) {
        // not used
    }

    /// Tells the delegate that the full-screen view has been dismissed.
    func bannerViewDidDismissScreen(_: BannerView) {
        // not used
    }
}

extension InReadAdmobScrollViewController: TeadsMediatedAdViewDelegate {
    func didUpdateRatio(_: UIView, adRatio: TeadsAdRatio) {
        resizeAd(height: adRatio.calculateHeight(for: slotView.frame.width))
    }
}
