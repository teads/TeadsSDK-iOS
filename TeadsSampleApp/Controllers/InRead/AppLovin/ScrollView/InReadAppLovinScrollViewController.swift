//
//  InReadAppLovinScrollViewController.swift
//  TeadsSampleApp
//
//  Created by Paul Nicolas on 24/02/2022.
//  Copyright © 2022 Teads. All rights reserved.
//

import AppLovinSDK
import Foundation
import TeadsAppLovinAdapter
import TeadsSDK
import UIKit

class InReadAppLovinScrollViewController: AppLovinViewController {
    @IBOutlet var slotHeight: NSLayoutConstraint!
    var bannerView: MAAdView!

    @IBOutlet var slotView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        ALSdk.shared()?.mediationProvider = ALMediationProviderMAX
        ALSdk.shared()?.settings.isVerboseLoggingEnabled = true
        ALSdk.shared()?.initializeSdk { [weak self] _ in
            self?.loadAd()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        #if targetEnvironment(simulator)
        let alert = UIAlertController(title: "Warning", message: "Teads AppLovin adapter does not work on simulator ", preferredStyle: .alert)
        alert.addAction(.init(title: "OK", style: .default))
        present(alert, animated: true, completion: nil)
        #endif
    }

    func loadAd() {
        let adFormat: MAAdFormat = isMREC ? .mrec : .banner
        bannerView = MAAdView(adUnitIdentifier: pid, adFormat: adFormat)
        print("AppLoving loading adUnit \(pid) on adFormat \(adFormat)")
        bannerView.isHidden = false

        let settings = TeadsAdapterSettings { settings in
            settings.enableDebug()
            settings.pageUrl("https://teads.com")
            try? settings.registerAdView(bannerView, delegate: self)
        }
        bannerView.register(teadsAdSettings: settings)

        // Set background or background color for banners to be fully functional
        bannerView.backgroundColor = .clear
        slotHeight.constant = 0

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
    func didExpand(_: MAAd) {
        // handle specific expand logic
    }

    func didCollapse(_: MAAd) {
        // handle specific collapse logic
    }

    func didLoad(_: MAAd) {
        // handle specific load logic
    }

    func didFailToLoadAd(forAdUnitIdentifier _: String, withError _: MAError) {
        // handle specific fail logic
    }

    func didDisplay(_: MAAd) {
        // handle specific display logic
    }

    func didHide(_: MAAd) {
        // handle specific hide logic
    }

    func didClick(_: MAAd) {
        // handle specific click logic
    }

    func didFail(toDisplay _: MAAd, withError _: MAError) {
        // handle specific fail to display logic
    }
}

extension InReadAppLovinScrollViewController: TeadsMediatedAdViewDelegate {
    func didUpdateRatio(_: UIView, adRatio: TeadsAdRatio) {
        let width = slotView.frame.width
        let height = adRatio.calculateHeight(for: width)
        slotHeight.constant = height
    }
}
