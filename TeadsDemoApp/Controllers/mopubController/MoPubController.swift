//
//  MoPubController.swift
//  TeadsDemoApp
//
//  Copyright © 2020 Teads. All rights reserved.
//

import TeadsSDK
import UIKit
import MoPub
import TeadsMoPubAdapter

class MoPubController: UIViewController {
    
    // FIXME This ids should be replaced by your own MoPub id
    let MOPUB_AD_UNIT_ID = "1d055042d1fc4d5d8240e4dec026f910"
    
    @IBOutlet weak var slotHeight: NSLayoutConstraint!
    var bannerView: MPAdView!
    
    @IBOutlet weak var slotView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let config = MPMoPubConfiguration(adUnitIdForAppInitialization: MOPUB_AD_UNIT_ID)
        bannerView = MPAdView(adUnitId: MOPUB_AD_UNIT_ID)
        config.loggingLevel = .debug
        
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

extension MoPubController: TFAMediatedAdViewDelegate {
    
    func didUpdateRatio(_ adView: UIView, ratio: CGFloat) {
        let width = slotView.frame.width
        slotHeight.constant = width / ratio
    }
    
}
