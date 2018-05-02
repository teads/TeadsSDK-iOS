//
//  InReadTopViewController.swift
//  TeadsDemoApp
//
//  Created by Jérémy Grosjean on 04/10/2017.
//  Copyright © 2017 Jérémy Grosjean. All rights reserved.
//

import UIKit
import TeadsSDK

class InReadTopViewController: UIViewController, TFAAdDelegate {

    @IBOutlet weak var teadsAdView: TFACustomAdView!
    @IBOutlet weak var teadsAdHeightConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.teadsAdView.delegate = self
        // PID can also be defined on storyboard/xib on TFACustomAdView in `User defined attributes` with following:
        // Key Path: pid
        // Type: String
        // Value: 84242 (<- to be replaced by your production PID)
        self.teadsAdView.pid = UserDefaults.standard.string(forKey: "PID")
        self.teadsAdView.load()
    }
    
    func resizeTeadsAd(adRatio: CGFloat) {
        let adHeight = self.view.frame.width/adRatio
        self.teadsAdHeightConstraint.constant = adHeight
        
        // Optional expand animation
        UIView.animate(withDuration: 0.25,
                       animations: {() -> Void in
                        self.view.layoutIfNeeded()
        })
    }

    // MARK: - Navigation TFAAdDelegate
    
    func didReceiveAd(_ ad: TFACustomAdView, adRatio: CGFloat) {
        self.resizeTeadsAd(adRatio: CGFloat(adRatio))
    }
    
    func didFailToReceiveAd(_ ad: TFACustomAdView, adFailReason: AdFailReason) {
        
    }
    
    func adClose(_ ad: TFACustomAdView, userAction: Bool) {
        self.teadsAdHeightConstraint.constant = 0
    }
    
    public func adError(_ ad: TFACustomAdView, errorMessage: String) {
    }

}
