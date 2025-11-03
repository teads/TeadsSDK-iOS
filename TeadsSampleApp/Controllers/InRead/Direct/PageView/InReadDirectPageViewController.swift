//
//  InReadDirectPageViewController.swift
//  TeadsSampleApp
//
//  Created by Paul NICOLAS on 29/05/2023.
//  Copyright © 2023 Teads. All rights reserved.
//

import TeadsSDK
import UIKit

class InReadDirectPageViewController: TeadsViewController {
    @IBOutlet var teadsAdView: TeadsInReadAdView!
    @IBOutlet var teadsAdHeightConstraint: NSLayoutConstraint!
    @IBOutlet private var articleLabel: UILabel!
    var articleLabelText: String?
    weak var placement: TeadsAdPlacementMedia? // strong reference is maintained by InReadPageViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        articleLabel.text = articleLabelText
        loadAd()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

    func loadAd() {
        do {
            if let adView = try placement?.loadAd() {
                teadsAdView.addSubview(adView)
                adView.translatesAutoresizingMaskIntoConstraints = false
                adView.topAnchor.constraint(equalTo: teadsAdView.topAnchor).isActive = true
                adView.leadingAnchor.constraint(equalTo: teadsAdView.leadingAnchor).isActive = true
                adView.trailingAnchor.constraint(equalTo: teadsAdView.trailingAnchor).isActive = true
                adView.bottomAnchor.constraint(equalTo: teadsAdView.bottomAnchor).isActive = true
            }
        } catch {
            print("Failed to load ad: \(error)")
        }
    }

    func resizeTeadsAd(adRatio: TeadsAdRatio) {
        let computedHeight = adRatio.calculateHeight(for: teadsAdView.frame.size.width)
        teadsAdHeightConstraint.constant = computedHeight
    }

    func closeAd() {
        teadsAdHeightConstraint.constant = 0
    }
}

// TeadsAdDelegate is handled through unified events system
