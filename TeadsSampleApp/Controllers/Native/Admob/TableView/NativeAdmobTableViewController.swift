//
//  NativeAdmobScrollViewController.swift
//  TeadsSampleApp
//
//  Created by Paul Nicolas on 26/07/2021.
//  Copyright © 2021 Teads. All rights reserved.
//

import UIKit
import GoogleMobileAds
import TeadsSDK

class NativeAdmobTableViewController: TeadsViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let headerCell = "TeadsContentCell"
    let teadsAdCellIndentifier = "AdmobNativeAdTableViewCell"
    let fakeArticleCell = "FakeArticleNativeTableViewCell"
    let adRowNumber = 3
    var adHeight: CGFloat?
    var adRatio: TeadsAdRatio?
    var teadsAdIsLoaded = false
    var placement: TeadsNativeAdPlacement?
    var tableViewAdCellWidth: CGFloat!
    
    private var elements = [GADNativeAd?]()
    
    var adLoader: GADAdLoader!
    
    // FIXME This ids should be replaced by your own AdMob application and ad block/unit ids
    let ADMOB_AD_UNIT_ID = "ca-app-pub-3940256099942544/2934735716"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        (0..<8).forEach { _ in
            elements.append(nil)
        }
        
        adLoader = GADAdLoader(adUnitID: pid, rootViewController: self,
                               adTypes: [ .native ], options: nil)
        
        adLoader?.delegate = self

        let request = GADRequest()
        let settings = TeadsAdapterSettings { (settings) in
            settings.enableDebug()
            settings.pageUrl("http://teads.tv")
        }

        let customEventExtras = GADCustomEventExtras()
        if let parameters = try? settings.toDictionary() {
            customEventExtras.setExtras(parameters, forLabel: "Teads")
        }
        request.register(customEventExtras)
        adLoader.load(request)
        

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableViewAdCellWidth = tableView.frame.width - 20
    }

  
    func closeSlot() {
        elements.removeAll { $0 != nil }
    }
}

extension NativeAdmobTableViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return elements.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: headerCell, for: indexPath)
            return cell
        } else if let ad = elements[indexPath.row] {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: teadsAdCellIndentifier, for: indexPath) as? AdmobNativeAdTableViewCell else {
                return UITableViewCell()
            }
            cell.nativeAdView.bind(ad, videoControllerDelegate: nil)
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: fakeArticleCell, for: indexPath) as? FakeArticleNativeTableViewCell else {
                return UITableViewCell()
            }
            cell.mediaView.image = UIImage(named: "social-covers")
            cell.iconImageView.image = UIImage(named: "teads-logo")
            cell.titleLabel.text = "Teads"
            cell.contentLabel.text = "The global media platform"
            cell.callToActionButton.setTitle("Discover Teads", for: .normal)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    
}

extension NativeAdmobTableViewController: GADAdLoaderDelegate {
    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: Error) {
        print("didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
}

extension NativeAdmobTableViewController: GADNativeAdLoaderDelegate {
    func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADNativeAd) {
        elements.insert(nativeAd, at: adRowNumber)
        let indexPaths = [IndexPath(row: adRowNumber, section: 0)]
        tableView.insertRows(at: indexPaths, with: .automatic)
        tableView.reloadData()
        nativeAd.delegate = self
    }
}

extension NativeAdmobTableViewController: GADNativeAdDelegate {
    func nativeAdDidRecordClick(_ nativeAd: GADNativeAd) {
        print("nativeAdDidRecordClick")
    }
    
    func nativeAdDidRecordImpression(_ nativeAd: GADNativeAd) {
        print("nativeAdDidRecordImpression")
    }
}

extension GADNativeAdView {
    func bind(_ ad: GADNativeAd, videoControllerDelegate: GADVideoControllerDelegate? = nil) {
        self.nativeAd = ad
        // Populate the native ad view with the native ad assets.
        // The headline and mediaContent are guaranteed to be present in every native ad.
        (headlineView as? UILabel)?.text = ad.headline
        mediaView?.mediaContent = ad.mediaContent
        mediaView?.isAccessibilityElement = true
        
        // Some native ads will include a video asset, while others do not. Apps can use the
        // GADVideoController's hasVideoContent property to determine if one is present, and adjust their
        // UI accordingly.
        let mediaContent = ad.mediaContent
        if mediaContent.hasVideoContent, let delegate = videoControllerDelegate {
            // By acting as the delegate to the GADVideoController, this ViewController receives messages
            // about events in the video lifecycle.
            mediaContent.videoController.delegate = delegate
        }
    }
}
