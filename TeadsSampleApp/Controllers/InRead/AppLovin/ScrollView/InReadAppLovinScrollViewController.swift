//
//  InReadAppLovinScrollViewController.swift
//  TeadsSampleApp
//
//  Created by Paul Nicolas on 24/02/2022.
//  Copyright © 2022 Teads. All rights reserved.
//

import Foundation
import TeadsSDK
import UIKit
import AppLovinSDK
import TeadsAppLovinAdapter

class InReadAppLovinScrollViewController: TeadsViewController {
    
    @IBOutlet weak var slotHeight: NSLayoutConstraint!
    var bannerView: MAAdView!
    
    @IBOutlet weak var slotView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ALSdk.shared()?.mediationProvider = ALMediationProviderMAX
        ALSdk.shared()!.settings.isVerboseLogging = true
        ALSdk.shared()!.initializeSdk { [weak self] (configuration: ALSdkConfiguration) in
            self?.loadAd()
        }
    }
    
    func loadAd() {
        // FIXME This ids should be replaced by your own AppLovin AdUnitId
        let APPLOVIN_AD_UNIT_ID = "33d03d37d70196e3" //TODO replace by self.pid
        bannerView = MAAdView(adUnitIdentifier: APPLOVIN_AD_UNIT_ID, adFormat: .mrec)
        bannerView.stopAutoRefresh()
        
        let settings = TeadsAdapterSettings { (settings) in
            settings.enableDebug()
            settings.pageUrl("https://teads.com")
            try? settings.registerAdView(bannerView, delegate: self)
        }
        bannerView.register(teadsAdSettings: settings)
        
        bannerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 250)
        
        // Set background or background color for banners to be fully functional
        bannerView.backgroundColor = .clear
        slotHeight.constant = 100
        
        addConstraints()
        
        // Load banner
        bannerView.delegate = self
        bannerView.loadAd()

    }
    func addConstraints() {
        guard let adView = bannerView else {
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

extension InReadAppLovinScrollViewController: MAAdViewAdDelegate {
    func didExpand(_ ad: MAAd) {
        slotHeight.constant = 50
        // handle specific expand logic
    }
    
    func didCollapse(_ ad: MAAd) {
        // handle specific collapse logic
    }
    
    func didLoad(_ ad: MAAd) {
        // handle specific load logic
    }
    
    func didFailToLoadAd(forAdUnitIdentifier adUnitIdentifier: String, withError error: MAError) {
        // handle specific fail logic
    }
    
    func didDisplay(_ ad: MAAd) {
        // handle specific display logic
    }
    
    func didHide(_ ad: MAAd) {
        // handle specific hide logic
    }
    
    func didClick(_ ad: MAAd) {
        // handle specific click logic
    }
    
    func didFail(toDisplay ad: MAAd, withError error: MAError) {
        // handle specific fail to display logic
    }
}

extension InReadAppLovinScrollViewController: TeadsMediatedAdViewDelegate {
    
    func didUpdateRatio(_ adView: UIView, adRatio: TeadsAdRatio) {
        let width = slotView.frame.width
        slotHeight.constant = adRatio.calculateHeight(for: width)
    }
    
}
