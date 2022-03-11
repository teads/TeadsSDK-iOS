//
//  InReadAdmobTableViewController.swift
//  TeadsSampleApp
//
//  Created by Thibaud Saint-Etienne on 15/10/2020.
//  Copyright © 2020 Teads. All rights reserved.
//

import UIKit
import GoogleMobileAds
import TeadsSDK
import TeadsAdMobAdapter

class InReadAdmobTableViewController: TeadsViewController {

    @IBOutlet weak var tableView: UITableView!
    
    // FIXME This ids should be replaced by your own AdMob application and ad block/unit ids
    let ADMOB_AD_UNIT_ID = "ca-app-pub-3940256099942544/2934735716"
    
    let contentCell = "TeadsContentCell"
    let teadsAdCellIndentifier = "TeadsAdCell"
    let fakeArticleCell = "fakeArticleCell"
    let adRowNumber = 2
    var adHeight: CGFloat?
    var adRatio: TeadsAdRatio?
    var teadsAdIsLoaded = false
    var admobAdView: GAMBannerView?
    var tableViewAdCellWidth: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Be sure to use DFPBannerView instead of GADBannerView
        admobAdView = GAMBannerView(adSize: GADAdSizeMediumRectangle)
        
        // 2. Attach Delegate (will include Teads events)
        admobAdView?.adUnitID = pid // Replace with your adunit
        admobAdView?.rootViewController = self
        admobAdView?.delegate = self

        // 3. Load a new ad (this will call AdMob and Teads afterward)
        let adSettings = TeadsAdapterSettings { (settings) in
            settings.enableDebug()
            if let admobAdView = admobAdView {
                try? settings.registerAdView(admobAdView, delegate: self)
            }
            // Needed by european regulation
            // See https://mobile.teads.tv/sdk/documentation/ios/gdpr-consent
            //settings.userConsent(subjectToGDPR: "1", consent: "0001100101010101")
            
            // The article url if you are a news publisher
            //settings.pageUrl("http://page.com/article1")
        }
        
        let customEventExtras = GADMAdapterTeads.customEventExtra(with: adSettings)
        
        let request = GADRequest()
        request.register(customEventExtras)
        
        admobAdView?.load(request)
        
        // We use an observer to know when a rotation happened, to resize the ad
        // You can use whatever way you want to do so
        NotificationCenter.default.addObserver(self, selector: #selector(rotationDetected), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableViewAdCellWidth = tableView.frame.width - 20
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc func rotationDetected() {
        if let adRatio = self.adRatio {
            resizeTeadsAd(adRatio: adRatio)
        }
    }
    
    func resizeTeadsAd(adRatio: TeadsAdRatio) {
        resizeAd(height: adRatio.calculateHeight(for: tableViewAdCellWidth))
    }
    
    func resizeAd(height: CGFloat) {
        adHeight = height
        updateAdCellHeight()
    }
  
    func closeSlot() {
        adHeight = 0
        updateAdCellHeight()
    }
    
    func updateAdCellHeight() {
        tableView.reloadRows(at: [IndexPath(row: adRowNumber, section: 0)], with: .automatic)
    }

}

extension InReadAdmobTableViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: contentCell, for: indexPath)
            return cell
        case adRowNumber:
            //need to create a cell and just add a teadsAd to it, so we have only one teads ad
            let cellAd = tableView.dequeueReusableCell(withIdentifier: teadsAdCellIndentifier, for: indexPath)
            if let admobAdView = admobAdView {
                cellAd.addSubview(admobAdView)
                admobAdView.frame.origin = CGPoint(x: 10, y: 0)
                // Be sure to call the DFPBannerView resize method to prevent admob from reloading a new ad experience
                admobAdView.resize(GADAdSizeFromCGSize(CGSize(width: tableViewAdCellWidth, height: adHeight ?? 250)))
            }
            return cellAd
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: fakeArticleCell, for: indexPath)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == adRowNumber {
            return adHeight ?? 0
        } else {
            return UITableView.automaticDimension
        }
    }
    
}

extension InReadAdmobTableViewController: GADBannerViewDelegate {
    
    /// Tells the delegate an ad request loaded an ad.
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        // not used
    }
    
    /// Tells the delegate an ad request failed.
    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
        resizeAd(height: 0)
        print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    
    /// Tells the delegate that a full-screen view will be presented in response
    /// to the user clicking on an ad.
    func bannerViewWillPresentScreen(_ bannerView: GADBannerView) {
        // not used
    }
    
    /// Tells the delegate that the full-screen view will be dismissed.
    func bannerViewWillDismissScreen(_ bannerView: GADBannerView) {
        // not used
    }
    
    /// Tells the delegate that the full-screen view has been dismissed.
    func bannerViewDidDismissScreen(_ bannerView: GADBannerView) {
        // not used
    }

}

extension InReadAdmobTableViewController: TeadsMediatedAdViewDelegate {
    
    func didUpdateRatio(_ adView: UIView, adRatio: TeadsAdRatio) {
        self.adRatio = adRatio
        resizeTeadsAd(adRatio: adRatio)
    }
    
}
