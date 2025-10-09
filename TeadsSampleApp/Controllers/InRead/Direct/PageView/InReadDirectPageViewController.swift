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
    @IBOutlet var teadsAdContainerView: UIView!
    @IBOutlet var teadsAdHeightConstraint: NSLayoutConstraint!
    @IBOutlet private var articleLabel: UILabel!
    var articleLabelText: String?
    weak var adViewReference: UIView? // strong reference is maintained by InReadPageViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        articleLabel.text = articleLabelText
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

    func setupAdView(_ adView: UIView) {
        // Remove from previous parent if any
        adView.removeFromSuperview()
        teadsAdContainerView.addSubview(adView)

        // Pin adView to container edges
        adView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            adView.topAnchor.constraint(equalTo: teadsAdContainerView.topAnchor),
            adView.leadingAnchor.constraint(equalTo: teadsAdContainerView.leadingAnchor),
            adView.trailingAnchor.constraint(equalTo: teadsAdContainerView.trailingAnchor),
            adView.bottomAnchor.constraint(equalTo: teadsAdContainerView.bottomAnchor),
        ])
    }

    func updateAdHeight(_ height: CGFloat) {
        teadsAdHeightConstraint.constant = height
        view.layoutIfNeeded()
    }

    func closeAd() {
        teadsAdHeightConstraint.constant = 0
    }
}
