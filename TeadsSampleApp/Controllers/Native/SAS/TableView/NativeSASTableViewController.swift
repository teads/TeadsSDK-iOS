//
//  NativeSASTableViewController.swift
//  TeadsSampleApp
//
//  Created by Paul Nicolas on 26/07/2021.
//  Copyright © 2021 Teads. All rights reserved.
//

import UIKit
import TeadsSDK
import SASDisplayKit
import TeadsSASAdapter

class NativeSASTableViewController: TeadsViewController {
    @IBOutlet weak var tableView: UITableView!
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
        let teadsAdSettings = TeadsAdapterSettings { (settings) in
            settings.enableDebug()
            settings.pageUrl("https://toto.com")
            settings.registerAdView(banner!, delegate: self)
        }
        
        let webSiteId = 385317
        let pageId = 1331331
        let formatId = Int(pid) ?? 96445
        var keywordsTargetting = "yourkw=titi"
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
        if let adRatio = self.adRatio {
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

extension NativeSASTableViewController: UITableViewDelegate, UITableViewDataSource {
    
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == adRowNumber {
            return adHeight ?? 0
        } else {
            return UITableView.automaticDimension
        }
    }
    
}

extension NativeSASTableViewController: TeadsMediatedAdViewDelegate {
    func didUpdateRatio(_ adView: UIView, adRatio: TeadsAdRatio) {
        self.adRatio = adRatio
        resizeTeadsAd(adRatio: adRatio)
    }
}
