//
//  InReadMopubTableViewController.swift
//  TeadsSampleApp
//
//  Created by Thibaud Saint-Etienne on 19/10/2020.
//  Copyright © 2020 Teads. All rights reserved.
//

import UIKit
#if canImport(MoPubSDK)
import MoPubSDK
#else
import MoPub
#endif
import TeadsSDK

class InReadMopubTableViewController: TeadsViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let contentCell = "TeadsContentCell"
    let teadsAdCellIndentifier = "TeadsAdCell"
    let fakeArticleCell = "fakeArticleCell"
    let adRowNumber = 2
    var adHeight: CGFloat?
    var adRatio: TeadsAdRatio?
    var teadsAdIsLoaded = false
    var mopubAdView: MPAdView?
    var tableViewAdCellWidth: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // FIXME This ids should be replaced by your own MoPub id
        let MOPUB_AD_UNIT_ID = pid
        
        let config = MPMoPubConfiguration(adUnitIdForAppInitialization: MOPUB_AD_UNIT_ID)
        mopubAdView = MPAdView(adUnitId: MOPUB_AD_UNIT_ID)
        mopubAdView?.delegate = self
        mopubAdView?.frame = view.bounds
        
        if MoPub.sharedInstance().isSdkInitialized {
            loadAd()
        }
        
        MoPub.sharedInstance().initializeSdk(with: config) { [weak self] in
            DispatchQueue.main.async {
                self?.loadAd()
            }
        }
    }
    
    func loadAd() {
        guard let mopubAdView = mopubAdView else {
            return
        }
        let settings = TeadsAdapterSettings { (settings) in
            settings.enableDebug()
            settings.registerAdView(mopubAdView, delegate: self)
        }
        mopubAdView.register(teadsAdSettings: settings)
        mopubAdView.stopAutomaticallyRefreshingContents() //usefull to perform validationTool https://support.teads.tv/support/solutions/articles/36000209100-validation-tool
        mopubAdView.loadAd(withMaxAdSize: kMPPresetMaxAdSizeMatchFrame)

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

extension InReadMopubTableViewController: UITableViewDelegate, UITableViewDataSource {

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
            if let mopubAdView = mopubAdView {
                cellAd.addSubview(mopubAdView)
                mopubAdView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                mopubAdView.frame = CGRect(x: 10, y: 0, width: tableViewAdCellWidth, height: adHeight ?? 250)
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

extension InReadMopubTableViewController: MPAdViewDelegate {
    func adViewDidLoadAd(_ view: MPAdView!, adSize: CGSize) {
        resizeAd(height: adSize.height)
    }
    func viewControllerForPresentingModalView() -> UIViewController! {
        return self
    }
}

extension InReadMopubTableViewController: TeadsMediatedAdViewDelegate {
    func didUpdateRatio(_ adView: UIView, adRatio: TeadsAdRatio) {
        self.adRatio = adRatio
        resizeTeadsAd(adRatio: adRatio)
    }
}

