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
    weak var placement: TeadsInReadAdPlacement? // strong reference is maintained by InReadPageViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        articleLabel.text = articleLabelText
        loadAd()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

    func loadAd() {
        placement?.requestAd(requestSettings: TeadsAdRequestSettings { settings in
            settings.pageUrl("https://www.teads.com")
        })
    }

    func resizeTeadsAd(adRatio: TeadsAdRatio) {
        let computedHeight = adRatio.calculateHeight(for: teadsAdView.frame.size.width)
        teadsAdHeightConstraint.constant = computedHeight
    }

    func closeAd() {
        teadsAdHeightConstraint.constant = 0
    }
}

extension InReadDirectPageViewController: TeadsAdDelegate {
    func willPresentModalView(ad _: TeadsAd) -> UIViewController? {
        self
    }
}
