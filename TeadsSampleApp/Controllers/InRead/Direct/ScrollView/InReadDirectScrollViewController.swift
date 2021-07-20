//
//  InReadDirectScrollViewController.swift
//  TeadsSampleApp
//
//  Created by Jérémy Grosjean on 28/09/2017.
//  Copyright © 2018 Teads. All rights reserved.
//

import UIKit
import TeadsSDK

class InReadDirectScrollViewController: TeadsViewController {
    
    @IBOutlet weak var scrollDownImageView: TeadsGradientImageView!
    @IBOutlet weak var teadsAdView: TeadsInReadAdView!
    @IBOutlet weak var teadsAdHeightConstraint: NSLayoutConstraint!
    var adRatio: TeadsAdRatio?
    var placement: TeadsInReadAdPlacement?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let pSettings = TeadsAdPlacementSettings { (settings) in
            settings.enableDebug()
        }
        placement = Teads.createInReadPlacement(pid: Int(pid) ?? 0, settings: pSettings, delegate: self)
        placement?.requestAd(requestSettings: TeadsAdRequestSettings(build: { (settings) in
            settings.pageUrl("https://www.teads.tv")
        }))
        // We use an observer to know when a rotation happened, to resize the ad
        // You can use whatever way you want to do so
        NotificationCenter.default.addObserver(self, selector: #selector(rotationDetected), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func rotationDetected() {
        if let adRatio = self.adRatio {
            resizeTeadsAd(adRatio: adRatio!)
        }
    }
    
    func resizeTeadsAd(adRatio: TeadsAdRatio) {
        teadsAdHeightConstraint.constant = adRatio.calculateHeight(for: view.frame.width)
    }
    
    func closeAd() {
        //be careful if you want to load another ad in the same page don't remove the observer
        NotificationCenter.default.removeObserver(self)
        teadsAdHeightConstraint.constant = 0
    }
    
}

extension InReadDirectScrollViewController: TeadsInReadAdPlacementDelegate {
    func adOpportunityTrackerView(trackerView: TeadsAdOpportunityTrackerView) {
        teadsAdView.addSubview(trackerView)
    }
    
    func didReceiveAd(ad: TeadsInReadAd, adRatio: TeadsAdRatio) {
        teadsAdView.bind(ad)
        ad.delegate = self
        resizeTeadsAd(adRatio: adRatio)
    }
    
    func didFailToReceiveAd(reason: AdFailReason) {
        closeAd()
    }
    
    func didUpdateRatio(ad: TeadsInReadAd, adRatio: TeadsAdRatio) {
        resizeTeadsAd(adRatio: adRatio)
        self.adRatio = adRatio
    }
    
}

extension InReadDirectScrollViewController: TeadsAdDelegate {
    
    func willPresentModalView(ad: TeadsAd) -> UIViewController? {
        return self
    }
    
    func didCatchError(ad: TeadsAd, error: Error) {
        closeAd()
    }
    
    func didCloseAd(ad: TeadsAd) {
        closeAd()
    }

    func didRecordImpression(ad: TeadsAd) {
        
    }
    
    func didRecordClick(ad: TeadsAd) {
    
    }
    
}
