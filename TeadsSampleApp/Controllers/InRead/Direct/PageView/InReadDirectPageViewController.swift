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

    // Each page owns its placement so an ad shows on every page.
    private var placement: TeadsAdPlacementMedia?

    override func viewDidLoad() {
        super.viewDidLoad()
        articleLabel.text = articleLabelText
        loadAd()
    }

    private func loadAd() {
        let config = TeadsAdPlacementMediaConfig(
            pid: Int(pid) ?? 0,
            articleUrl: URL(string: "https://www.teads.com")
        )
        placement = Teads.createPlacement(with: config, delegate: self)
        if let adView = try? placement?.loadAd() {
            setupAdView(adView)
        }
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

extension InReadDirectPageViewController: TeadsAdPlacementEventsDelegate {
    func adPlacement(_: TeadsAdPlacementIdentifiable?, didEmitEvent event: TeadsAdPlacementEventName, data: [String: Any]?) {
        switch event {
            case .heightUpdated:
                if let height = data?["height"] as? CGFloat { updateAdHeight(height) }
            case .failed, .complete:
                closeAd()
            default:
                break
        }
    }
}
