//
//  NativeMopubTableViewController.swift
//  TeadsSampleApp
//
//  Created by Paul Nicolas on 26/07/2021.
//  Copyright © 2021 Teads. All rights reserved.
//

import UIKit
#if canImport(MoPubSDK)
import MoPubSDK
#else
import MoPub
#endif
import TeadsMoPubAdapter
import TeadsSDK

class NativeMopubTableViewController: TeadsViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let headerCell = "TeadsContentCell"
    let teadsAdCellIndentifier = "MoPubNativeTableViewCell"
    let fakeArticleCell = "FakeArticleNativeTableViewCell"
    let adRowNumber = 3
    var placement: TeadsNativeAdPlacement?

    
    private var elements = [MPNativeAd?]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        (0..<8).forEach { _ in
            elements.append(nil)
        }
        
        let mpConfig = MPMoPubConfiguration(adUnitIdForAppInitialization: pid)
        mpConfig.loggingLevel = .debug
        MoPub.sharedInstance().initializeSdk(with: mpConfig) {
            self.loadAd()
        }
    }
    
    func loadAd() {
        let settings = MPAdapterTeadsNativeAdRendererSettings()

        settings.renderingViewClass = MoPubNativeAdView.self
        
        let config: MPNativeAdRendererConfiguration =
            MPAdapterTeadsNativeAdRenderer.rendererConfiguration(with: settings)
        
        let adRequest: MPNativeAdRequest = MPNativeAdRequest(adUnitIdentifier: pid, rendererConfigurations: [config])
        
        let targeting: MPNativeAdRequestTargeting = MPNativeAdRequestTargeting()
        targeting.desiredAssets = [kAdTitleKey, kAdTextKey, kAdCTATextKey, kAdIconImageKey, kAdMainImageKey, kAdStarRatingKey, kAdSponsoredByCompanyKey]
        
        let adSettings = TeadsAdapterSettings { (settings) in
            settings.enableDebug()
            settings.pageUrl("http://teads.tv")
        }
        targeting.register(teadsAdSettings: adSettings)
        adRequest.targeting = targeting
        
        adRequest.start { [weak self] (request, response, error) in
            guard let self = self else {
                return
            }
            if let error = error {
                print("Error: \(error.localizedDescription)")
            } else {
                response?.delegate = self
                self.elements.insert(response, at: self.adRowNumber)
                let indexPaths = [IndexPath(row: self.adRowNumber, section: 0)]
                self.tableView.insertRows(at: indexPaths, with: .automatic)
                self.tableView.reloadData()
            }
        }

    }
  
    func closeSlot(ad: TeadsAd) {
        elements.removeAll { $0 == ad }
        tableView.reloadData()
    }

}

extension NativeMopubTableViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return elements.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: headerCell, for: indexPath)
            return cell
        } else if let ad = elements[indexPath.row] {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: teadsAdCellIndentifier, for: indexPath) as? MoPubNativeTableViewCell else {
                return UITableViewCell()
            }
            
            if let av = try? ad.retrieveAdView() {
                av.frame = cell.nativeAdView.bounds
                av.autoresizingMask = [.flexibleHeight, .flexibleWidth]
                cell.nativeAdView.addSubview(av)
            }
            
            cell.nativeAdView.isHidden = false
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
        if elements[indexPath.row] != nil {
            return 400
        }
        return 250
    }
    
}

extension NativeMopubTableViewController: MPNativeAdDelegate {
    func viewControllerForPresentingModalView() -> UIViewController! {
        return self
    }
    
    
}
