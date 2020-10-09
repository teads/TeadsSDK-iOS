//
//  ScrollViewController.swift
//  TeadsDemoApp
//
//  Created by Jérémy Grosjean on 28/09/2017.
//  Copyright © 2018 Teads. All rights reserved.
//

import UIKit
import TeadsSDK

class ScrollViewController: TeadsArticleViewController, TFAAdDelegate {

    @IBOutlet weak var scrollDownImageView: TeadsGradientImageView!
    @IBOutlet weak var teadsAdView: TFAInReadAdView!
    @IBOutlet weak var teadsAdHeightConstraint: NSLayoutConstraint!
    var adRatio: CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        teadsAdView.delegate = self
        // the PID has been set in the storyboard
        teadsAdView.pid = UserDefaults.standard.integer(forKey: "PID")
        
        let teadsAdSettings = TeadsAdSettings(build: { (settings) in
            settings.enableDebug()
        })
        
        teadsAdView.load(teadsAdSettings: teadsAdSettings)
        
        // We use an observer to know when a rotation happened, to resize the ad
        // You can use whatever way you want to do so
        NotificationCenter.default.addObserver(self, selector: #selector(rotationDetected), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func rotationDetected() {
        if adRatio != nil {
            resizeTeadsAd(adRatio: adRatio!)
        }
    }
    
    func resizeTeadsAd(adRatio: CGFloat) {
        let adHeight = view.frame.width/adRatio
        teadsAdHeightConstraint.constant = adHeight
    }
    
    // MARK: TFAAdDelegate
    
    func didReceiveAd(_ ad: TFAAdView, adRatio: CGFloat) {
        self.adRatio = adRatio
        resizeTeadsAd(adRatio: adRatio)
    }
    
    func didFailToReceiveAd(_ ad: TFAAdView, adFailReason: AdFailReason) {
        adRatio = 0
        teadsAdHeightConstraint.constant = 0
    }
    
    func adClose(_ ad: TFAAdView, userAction: Bool) {
        self.teadsAdHeightConstraint.constant = 0
        //be careful if you want to load another ad in the same page don't remove the observer
        NotificationCenter.default.removeObserver(self)
    }
    
    public func adError(_ ad: TFAAdView, errorMessage: String) {
        //be careful if you want to load another ad in the same page don't remove the observer
        NotificationCenter.default.removeObserver(self)
    }
    
    public func didUpdateRatio(_ ad: TFAAdView, ratio: CGFloat) {
        adRatio = ratio
        resizeTeadsAd(adRatio: ratio)
    }
    
    public func adBrowserWillOpen(_ ad: TFAAdView) -> UIViewController? {
        return self
    }
}
