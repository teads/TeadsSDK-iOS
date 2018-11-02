//
//  ProgrammaticScrollViewController.swift
//  TeadsDemoApp
//
//  Created by Jérémy Grosjean on 06/08/2018.
//  Copyright © 2018 Jérémy Grosjean. All rights reserved.
//

import UIKit
import TeadsSDK

class ProgrammaticScrollViewController: UIViewController, TFAAdDelegate {

    var teadsAdView: TFACustomAdView!
    @IBOutlet weak var slotView: UIView!
    @IBOutlet weak var slotHeightConstraint: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.teadsAdView = TFACustomAdView(withPid: UserDefaults.standard.integer(forKey: "PID"), andDelegate: self)
        //Load the ad
        self.teadsAdView.load()
        //It creates constraint so the ad takes all the slot
        self.teadsAdView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func resizeTeadsAd(adRatio: CGFloat) {
        //prevent the ad from being bigger than the screen
        let adHeight = self.view.frame.width/adRatio < UIScreen.main.bounds.height ? self.view.frame.width/adRatio : UIScreen.main.bounds.height
        self.slotHeightConstraint.constant = adHeight
    }
    
    // MARK: TFAAdDelegate
    
    func didReceiveAd(_ ad: TFACustomAdView, adRatio: CGFloat) {
        self.teadsAdView.frame = self.slotView.bounds
        self.slotView.addSubview(self.teadsAdView)
        self.resizeTeadsAd(adRatio: adRatio)
    }
    
    func didFailToReceiveAd(_ ad: TFACustomAdView, adFailReason: AdFailReason) {
        self.slotHeightConstraint.constant = 0
        self.teadsAdView.removeFromSuperview()
    }
    
    func adClose(_ ad: TFACustomAdView, userAction: Bool) {
        self.slotHeightConstraint.constant = 0
        self.teadsAdView.removeFromSuperview()
    }
    
    func adError(_ ad: TFACustomAdView, errorMessage: String) {
        self.slotHeightConstraint.constant = 0
        self.teadsAdView.removeFromSuperview()
    }
    
}
