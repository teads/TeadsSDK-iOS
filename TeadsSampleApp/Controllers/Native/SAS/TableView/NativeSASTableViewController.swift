//
//  NativeSASTableViewController.swift
//  TeadsSampleApp
//
//  Created by Paul NICOLAS on 13/03/2023.
//  Copyright © 2023 Teads. All rights reserved.
//

import SASDisplayKit
import TeadsSASAdapter
import TeadsSDK
import UIKit

class NativeSASTableViewController: TeadsViewController {
    @IBOutlet var tableView: UITableView!

    let headerCell = "TeadsContentCell"
    let teadsAdCellIndentifier = "NativeTableViewCell"
    let fakeArticleCell = "FakeArticleNativeTableViewCell"
    let adRowNumber = 3

    private var elements = [SASNativeAd?]()
    private var nativeAdManager: SASNativeAdManager?

    override func viewDidLoad() {
        super.viewDidLoad()

        (0 ..< 8).forEach { _ in
            elements.append(nil)
        }

        let teadsAdSettings = TeadsAdapterSettings { settings in
            settings.pageUrl("https://example.com/article1")
        }

        let webSiteId = 385_317
        let pageId = 1_399_205
        let formatId = PID.sasNativeDisplay
        var keywordsTargetting = "yourkw=something"
        keywordsTargetting = TeadsSASAdapterHelper.concatAdSettingsToKeywords(keywordsStrings: keywordsTargetting, adSettings: teadsAdSettings)

        // Create a placement
        let adPlacement = SASAdPlacement(siteId: webSiteId, pageId: pageId, formatId: formatId, keywordTargeting: keywordsTargetting)
        nativeAdManager = SASNativeAdManager(placement: adPlacement)

        nativeAdManager?.requestAd { (ad: SASNativeAd?, error: Error?) in
            if let nativeAd = ad {
                self.elements.insert(nativeAd, at: self.adRowNumber)
                self.tableView.reloadData()
            } else if let error = error {
                print("Unable to load ad: \(error.localizedDescription)")
            } else {
                print("Unknown error")
            }
        }
    }

    func closeSlot(ad: TeadsAd) {
        elements.removeAll { $0 == ad }
        tableView.reloadData()
    }
}

extension NativeSASTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return elements.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: headerCell, for: indexPath)
            return cell
        } else if let nativeAd = elements[indexPath.row] {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: teadsAdCellIndentifier, for: indexPath) as? SmartNativeAdTableViewCell else {
                return UITableViewCell()
            }
            nativeAd.delegate = self
            cell.bind(sasNativeAd: nativeAd)
            return cell
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: fakeArticleCell, for: indexPath) as? FakeArticleNativeTableViewCell else {
            return UITableViewCell()
        }
        cell.setMockValues()
        return cell
    }

    func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 250
        }
        return 400
    }
}

extension NativeSASTableViewController: SASNativeAdDelegate {
    func nativeAd(_: SASNativeAd, didClickWith URL: URL) {
        print("click event has been fired", URL.absoluteURL)
    }

    func nativeAdWillPresentModalView(_: SASNativeAd) {
        print("a modal view will appear to display the ad's landing page")
    }

    func nativeAdWillDismissModalView(_: SASNativeAd) {
        print("a modal view will dismiss the ad's landing page")
    }
}
