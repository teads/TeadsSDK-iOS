//
//  SASInReadScrollViewController.swift
//  TeadsSampleApp
//
//  Created by Jérémy Grosjean on 18/11/2020.
//  Copyright © 2020 Teads. All rights reserved.
//

import UIKit
import SASDisplayKit
import TeadsSDK
import TeadsSASAdapter

class InReadSASScrollViewController: TeadsViewController {
    
    @IBOutlet weak var slotView: UIView!
    
    @IBOutlet weak var adViewHeightConstraint: NSLayoutConstraint!
    
    var banner: SASBannerView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        banner = SASBannerView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 200), loader: .activityIndicatorStyleWhite)
        banner?.modalParentViewController = self
        let teadsAdSettings = TeadsAdapterSettings { (settings) in
            settings.enableDebug()
            settings.pageUrl("https://teads.tv")
            try? settings.registerAdView(banner!, delegate: self)
        }
        
        let webSiteId = 385317
        let pageId = 1331331
        let formatId = Int(pid) ?? 96445
        var keywordsTargetting = "yourkw=something"
        keywordsTargetting = TeadsSASAdapterHelper.concatAdSettingsToKeywords(keywordsStrings: keywordsTargetting, adSettings: teadsAdSettings)
        
        // Create a placement
        let adPlacement = SASAdPlacement(siteId: webSiteId, pageId: pageId, formatId: formatId, keywordTargeting: keywordsTargetting)
                   
        banner?.load(with: adPlacement)
        slotView.addSubview(banner!)
        addConstraintsToAdView(toView: slotView)
    }
    
    func addConstraintsToAdView(toView slotView: UIView) {
        guard let adView = banner else {
            return
        }
        slotView.addSubview(adView)
        adView.translatesAutoresizingMaskIntoConstraints = false
        let margins = slotView.layoutMarginsGuide
        adView.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 0).isActive = true
        adView.topAnchor.constraint(equalTo: margins.topAnchor, constant: 0).isActive = true
        adView.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: 0).isActive = true
        adView.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: 0).isActive = true
    }

}

extension InReadSASScrollViewController: TeadsMediatedAdViewDelegate {
    
    func didUpdateRatio(_ adView: UIView, adRatio: TeadsAdRatio) {
        adViewHeightConstraint.constant = adRatio.calculateHeight(for: slotView.bounds.width)
    }
    
}
