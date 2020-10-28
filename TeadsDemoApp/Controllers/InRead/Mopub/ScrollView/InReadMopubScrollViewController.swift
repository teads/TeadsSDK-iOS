//
//  InReadMopubScrollViewController.swift
//  TeadsDemoApp
//
//  Copyright © 2020 Teads. All rights reserved.
//

import TeadsSDK
import UIKit
import MoPub
import TeadsMoPubAdapter

class InReadMopubScrollViewController: TeadsViewController {
    
    @IBOutlet weak var slotHeight: NSLayoutConstraint!
    var bannerView: MPAdView!
    
    @IBOutlet weak var slotView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // FIXME This ids should be replaced by your own MoPub id
        let MOPUB_AD_UNIT_ID = pid
        
        let config = MPMoPubConfiguration(adUnitIdForAppInitialization: MOPUB_AD_UNIT_ID)
        bannerView = MPAdView(adUnitId: MOPUB_AD_UNIT_ID)
        bannerView.delegate = self
        
        if MoPub.sharedInstance().isSdkInitialized {
            loadAd()
        }
        
        MoPub.sharedInstance().initializeSdk(with: config) { [weak self] in
            
            guard let weakSelf = self else {
                return
            }
            DispatchQueue.main.async {
                weakSelf.loadAd()
            }
        }
    }
    
    func loadAd() {
        let settings = TeadsAdSettings { (settings) in
            settings.enableDebug()
            try? settings.subscribeAdResizeDelegate(self, forAdView: bannerView)
        }
        bannerView.register(teadsAdSettings: settings)
        bannerView.loadAd(withMaxAdSize: kMPPresetMaxAdSizeMatchFrame)
        addConstraints()

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

extension InReadMopubScrollViewController: MPAdViewDelegate {
    func viewControllerForPresentingModalView() -> UIViewController! {
        return self
    }
}

extension InReadMopubScrollViewController: TFAMediatedAdViewDelegate {
    
    func didUpdateRatio(_ adView: UIView, ratio: CGFloat) {
        let width = slotView.frame.width
        slotHeight.constant = width / ratio
    }
    
}
