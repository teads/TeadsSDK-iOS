//
//  InReadTopViewController.swift
//  TeadsDemoApp
//
//  Created by Jérémy Grosjean on 04/10/2017.
//  Copyright © 2018 Teads. All rights reserved.
//

import UIKit
import TeadsSDK

class InReadTopViewController: UIViewController, TFAAdDelegate {

    @IBOutlet weak var teadsAdView: TFAInReadAdView!
    @IBOutlet weak var teadsAdHeightConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.teadsAdView.delegate = self
        // PID can also be defined on storyboard/xib on TFAAdView in `User defined attributes` with following:
        // Key Path: pid
        // Type: String
        // Value: 84242 (<- to be replaced by your production PID)
        self.teadsAdView.pid = UserDefaults.standard.integer(forKey: "PID")
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
    
    func didReceiveAd(_ ad: TFAAdView, adRatio: CGFloat) {
        self.resizeTeadsAd(adRatio: CGFloat(adRatio))
    }
    
    func didFailToReceiveAd(_ ad: TFAAdView, adFailReason: AdFailReason) {
        
    }
    
    func adClose(_ ad: TFAAdView, userAction: Bool) {
        self.teadsAdHeightConstraint.constant = 0
    }
    
    public func adError(_ ad: TFAAdView, errorMessage: String) {
    }

}
