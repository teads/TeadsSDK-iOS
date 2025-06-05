//
//  NativeAdmobScrollViewController.swift
//  TeadsSampleApp
//
//  Created by Paul Nicolas on 26/07/2021.
//  Copyright © 2021 Teads. All rights reserved.
//

import GoogleMobileAds
import TeadsAdMobAdapter
import TeadsSDK
import UIKit

class NativeAdmobTableViewController: TeadsViewController {
    @IBOutlet var tableView: UITableView!

    let headerCell = "TeadsContentCell"
    let teadsAdCellIndentifier = "AdmobNativeAdTableViewCell"
    let fakeArticleCell = "FakeArticleNativeTableViewCell"
    let adRowNumber = 3

    private var elements = [NativeAd?]()

    var adLoader: AdLoader!

    override func viewDidLoad() {
        super.viewDidLoad()

        (0 ..< 8).forEach { _ in
            elements.append(nil)
        }

        adLoader = GADAdLoader(
            // FIXME: This id below should be replaced by your own AdMob application and ad block/unit ids
            adUnitID: pid,
            rootViewController: self,
            adTypes: [.native],
            options: nil
        )

        adLoader?.delegate = self

        let settings = TeadsAdapterSettings { settings in
            settings.enableDebug()
            settings.pageUrl("http://teads.tv")
        }

        let request = Request()
        request.register(settings)
        adLoader.load(request)
    }

    func closeSlot() {
        elements.removeAll { $0 != nil }
    }
}

extension NativeAdmobTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
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
            cell.setMockValues()
            return cell
        }
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 250
    }
}

extension NativeAdmobTableViewController: AdLoaderDelegate {
    func adLoader(_: AdLoader, didFailToReceiveAdWithError error: Error) {
        print("didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
}

extension NativeAdmobTableViewController: NativeAdLoaderDelegate {
    func adLoader(_: AdLoader, didReceive nativeAd: NativeAd) {
        elements.insert(nativeAd, at: adRowNumber)
        let indexPaths = [IndexPath(row: adRowNumber, section: 0)]
        tableView.insertRows(at: indexPaths, with: .automatic)
        nativeAd.delegate = self
    }
}

extension NativeAdmobTableViewController: NativeAdDelegate {
    func nativeAdDidRecordClick(_: NativeAd) {
        // you may want to use this callback for your own analytics
    }

    func nativeAdDidRecordImpression(_: NativeAd) {
        // you may want to use this callback for your own analytics
    }
}

extension NativeAdView {
    func bind(_ ad: NativeAd, videoControllerDelegate: VideoControllerDelegate? = nil) {
        nativeAd = ad
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
