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

    @IBOutlet weak var topArticleText: UILabel!
    @IBOutlet weak var scrollDownImageView: UIImageView!
    @IBOutlet weak var scrollDownLabelView: UILabel!
    @IBOutlet weak var teadsAdView: TFAInReadAdView!
    @IBOutlet weak var teadsAdHeightConstraint: NSLayoutConstraint!
    var adRatio: CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        teadsDesign()
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


extension ScrollViewController {
    
    func teadsDesign() {
        let image = UIImage(named: "coffeeDesk")
        scrollDownImageView.image = image
        scrollDownImageView.contentMode = .scaleAspectFill
        let gradient = CAGradientLayer()
        gradient.frame = scrollDownImageView.bounds

        gradient.colors = [CGColor(red: UIColor.teadsPurple.getRedValue(), green: UIColor.teadsPurple.getGreenValue(), blue: UIColor.teadsPurple.getBlueValue(), alpha: 0.65), CGColor(red: UIColor.teadsBlue.getRedValue(), green: UIColor.teadsBlue.getGreenValue(), blue: UIColor.teadsBlue.getBlueValue(), alpha: 0.65)]
        gradient.startPoint = CGPoint(x: 0, y: 1)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        
        scrollDownImageView.layer.addSublayer(gradient)
        
       
        let httmlString =
        """
<html>
             "  <head>"
             "    <style type='text/css'>"
             "      body { font: 16pt 'Gill Sans'; color: #1a004b; }"
             "      i { color: #822; }"
             "    </style>"
             "  </head>"
             "  <body><h2>Creative that cuts through the noise…but respects the user.</h2>
        
        <p class="desc">
                        Holding attention in a mobile driven world is no easy challenge. At Teads, we embrace the swipes, the
                        scrolls, the pinches and the taps to build ad experiences that delight the user and deliver business
                        results for brands.
                    </p></body>"
             "</html>";
"""
        topArticleText.attributedText = httmlString.htmlAttributedString()
    }
    
}
