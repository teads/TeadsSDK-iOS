//
//  InReadSASTableViewController.swift
//  TeadsSampleApp
//
//  Created by Jérémy Grosjean on 19/11/2020.
//  Copyright © 2020 Teads. All rights reserved.
//

import SASDisplayKit
import TeadsSASAdapter
import TeadsSDK
import UIKit

class InReadSASTableViewController: TeadsViewController {
    @IBOutlet var tableView: UITableView!
    var banner: SASBannerView?

    let contentCell = "TeadsContentCell"
    let teadsAdCellIndentifier = "TeadsAdCell"
    let fakeArticleCell = "fakeArticleCell"
    let adRowNumber = 2
    var adHeight: CGFloat?
    var adRatio: TeadsAdRatio?
    var teadsAdIsLoaded = false
    var tableViewAdCellWidth: CGFloat!

    override func viewDidLoad() {
        super.viewDidLoad()
        banner = SASBannerView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 200), loader: .activityIndicatorStyleWhite)
        banner?.modalParentViewController = self
        let teadsAdSettings = TeadsAdapterSettings { settings in
            settings.enableDebug()
            settings.pageUrl("https://teads.tv")
            settings.registerAdView(banner!, delegate: self)
        }

        let webSiteId = 385_317
        let pageId = 1_399_206
        let formatId = Int(pid) ?? 96445
        var keywordsTargetting = "yourkw=something"
        keywordsTargetting = TeadsSASAdapterHelper.concatAdSettingsToKeywords(keywordsStrings: keywordsTargetting, adSettings: teadsAdSettings)

        // Create a placement
        let adPlacement = SASAdPlacement(siteId: webSiteId, pageId: pageId, formatId: formatId, keywordTargeting: keywordsTargetting)

        banner?.load(with: adPlacement)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableViewAdCellWidth = tableView.frame.width - 20
    }

    @objc func rotationDetected() {
        if let adRatio = adRatio {
            resizeTeadsAd(adRatio: adRatio)
        }
    }

    func resizeTeadsAd(adRatio: TeadsAdRatio) {
        adHeight = adRatio.calculateHeight(for: tableViewAdCellWidth)
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

extension InReadSASTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return 4
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: contentCell, for: indexPath)
                return cell
            case adRowNumber:
                // need to create a cell and just add a teadsAd to it, so we have only one teads ad
                let cellAd = tableView.dequeueReusableCell(withIdentifier: teadsAdCellIndentifier, for: indexPath)
                if let banner = banner {
                    cellAd.addSubview(banner)
                    banner.frame = CGRect(x: 10, y: 0, width: tableViewAdCellWidth, height: adHeight ?? 250)
                }
                return cellAd
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: fakeArticleCell, for: indexPath)
                return cell
        }
    }

    func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == adRowNumber {
            return adHeight ?? 0
        } else {
            return UITableView.automaticDimension
        }
    }
}

extension InReadSASTableViewController: TeadsMediatedAdViewDelegate {
    func didUpdateRatio(_: UIView, adRatio: TeadsAdRatio) {
        self.adRatio = adRatio
        resizeTeadsAd(adRatio: adRatio)
    }
}
