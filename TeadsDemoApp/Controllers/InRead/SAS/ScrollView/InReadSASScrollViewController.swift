//
//  SASInReadScrollViewController.swift
//  TeadsDemoApp
//
//  Created by Jérémy Grosjean on 18/11/2020.
//  Copyright © 2020 Teads. All rights reserved.
//

import UIKit
import SASDisplayKit
import TeadsSDK
import TeadsSASAdapter

class InReadSASScrollViewController: TeadsViewController, TFAMediatedAdViewDelegate {
    
    @IBOutlet weak var slotView: UIView!
    
    @IBOutlet weak var adViewHeightConstraint: NSLayoutConstraint!
    
    var banner: SASBannerView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        banner = SASBannerView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 200), loader: .activityIndicatorStyleWhite)
        banner?.modalParentViewController = self
        let teadsAdSettings = TeadsAdSettings { (settings) in
            settings.enableDebug()
            settings.pageUrl("https://toto.com")
            try? settings.subscribeAdResizeDelegate(self, forAdView: banner!)
        }
        let webSiteId = 383302
        let pageId = 1318382
        let formatId = 69325
        var keywordsTargetting = "lemondekw=titi"
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

    func didUpdateRatio(_ adView: UIView, ratio: CGFloat) {
        adViewHeightConstraint.constant =  adView.bounds.width / ratio
    }
    
}
