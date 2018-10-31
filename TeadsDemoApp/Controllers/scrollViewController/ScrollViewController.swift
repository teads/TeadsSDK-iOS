//
//  ScrollViewController.swift
//  TeadsDemoApp
//
//  Created by Jérémy Grosjean on 28/09/2017.
//  Copyright © 2018 Teads. All rights reserved.
//

import UIKit
import TeadsSDK

class ScrollViewController: UIViewController, TFAAdDelegate {

    @IBOutlet weak var teadsAdView: TFACustomAdView!
    @IBOutlet weak var teadsAdHeightConstraint: NSLayoutConstraint!
    var adRatio: CGFloat?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.teadsAdView.delegate = self
        // the PID has been set in the storyboard
        self.teadsAdView.pid = UserDefaults.standard.integer(forKey: "PID")
        
        let teadsAdSettings = TeadsAdSettings(build: { (settings) in
            settings.enableDebug()
        })
        self.teadsAdView.load(teadsAdSettings: teadsAdSettings)
        
        // We use an observer to know when a rotation happened, to resize the ad
        // You can use whatever way you want to do so
        NotificationCenter.default.addObserver(self, selector: #selector(self.rotationDetected), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func rotationDetected() {
        if self.adRatio != nil {
            self.resizeTeadsAd(adRatio: self.adRatio!)
        }
    }
    
    func resizeTeadsAd(adRatio: CGFloat) {
        let adHeight = self.view.frame.width/adRatio
        self.teadsAdHeightConstraint.constant = adHeight
    }
    
    // MARK: TFAAdDelegate
    
    func didReceiveAd(_ ad: TFACustomAdView, adRatio: CGFloat) {
        self.adRatio = adRatio
        self.resizeTeadsAd(adRatio: adRatio)
    }
    
    func didFailToReceiveAd(_ ad: TFACustomAdView, adFailReason: AdFailReason) {
        self.adRatio = 0
        self.teadsAdHeightConstraint.constant = 0
    }
    
    func adClose(_ ad: TFACustomAdView, userAction: Bool) {
        self.teadsAdHeightConstraint.constant = 0
        //be careful if you want to load another ad in the same page don't remove the observer
        NotificationCenter.default.removeObserver(self)
    }
    
    public func adError(_ ad: TFACustomAdView, errorMessage: String) {
        //be careful if you want to load another ad in the same page don't remove the observer
        NotificationCenter.default.removeObserver(self)
    }
}
