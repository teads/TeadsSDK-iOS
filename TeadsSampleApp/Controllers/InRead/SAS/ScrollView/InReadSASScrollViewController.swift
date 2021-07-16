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
        slotView.addSubview(banner!)
        addConstraintsToAdView(toView: slotView)
    }
    
    func addConstraintsToAdView(toView slotView: UIView) {
        guard let adView = banner else {
            return
        }
        view.addSubview(adView)
        adView.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints([
            NSLayoutConstraint(item: adView,
                attribute: .top,
                relatedBy: .equal,
                toItem: slotView,
                attribute: .top,
                multiplier: 1,
                constant: 0),
            NSLayoutConstraint(item: adView,
                attribute: .leading,
                relatedBy: .equal,
                toItem: slotView,
                attribute: .leading,
                multiplier: 1,
                constant: 0),
            NSLayoutConstraint(item: adView,
                attribute: .trailing,
                relatedBy: .equal,
                toItem: slotView,
                attribute: .trailing,
                multiplier: 1,
                constant: 0),
            NSLayoutConstraint(item: adView,
                attribute: .bottom,
                relatedBy: .equal,
                toItem: slotView,
                attribute: .bottom,
                multiplier: 1,
                constant: 0)
        ])
    }

}

extension InReadSASScrollViewController: TeadsMediatedAdViewDelegate {
    
    func didUpdateRatio(_ adView: UIView, adRatio: TeadsAdRatio) {
        adViewHeightConstraint.constant = adRatio.calculateHeight(for: adView.bounds.width)
    }
    
}
