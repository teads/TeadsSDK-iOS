//
//  InReadDirectScrollViewController.swift
//  TeadsSampleApp
//
//  Created by Jérémy Grosjean on 28/09/2017.
//  Copyright © 2018 Teads. All rights reserved.
//

import TeadsSDK
import UIKit

class InReadDirectScrollViewController: TeadsViewController {
    @IBOutlet var scrollDownImageView: TeadsGradientImageView!
    @IBOutlet var teadsAdContainerView: UIView!
    @IBOutlet var teadsAdHeightConstraint: NSLayoutConstraint!
    var placement: TeadsAdPlacementMedia?

    override var pid: String {
        didSet {
            guard oldValue != pid, isViewLoaded else { return }
            setupPlacement()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupPlacement()
    }

    private func setupPlacement() {
        // Clean up existing placement and views
        placement = nil
        teadsAdContainerView.subviews.forEach { $0.removeFromSuperview() }
        teadsAdHeightConstraint.constant = 0

        // Create placement with new API
        let config = TeadsAdPlacementMediaConfig(
            pid: Int(pid) ?? 0,
            articleUrl: URL(string: "https://www.teads.com"),
            enableValidationMode: validationModeEnabled
        )

        placement = Teads.createPlacement(with: config, delegate: self)

        // Load ad and add content view to container
        if let adView = try? placement?.loadAd() {
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
    }

    func updateAdHeight(_ height: CGFloat) {
        teadsAdHeightConstraint.constant = height
        view.layoutIfNeeded()
    }

    func closeAd() {
        teadsAdHeightConstraint.constant = 0
    }
}

extension InReadDirectScrollViewController: TeadsAdPlacementEventsDelegate {
    func adPlacement(
        _: TeadsAdPlacementIdentifiable?,
        didEmitEvent event: TeadsAdPlacementEventName,
        data: [String: Any]?
    ) {
        switch event {
            case .ready:
                print("Ad ready")

            case .rendered:
                print("Ad rendered")

            case .heightUpdated:
                if let height = data?["height"] as? CGFloat {
                    updateAdHeight(height)
                }

            case .viewed:
                print("Ad viewed (impression)")

            case .clicked:
                print("Ad clicked")

            case .failed:
                print("Ad failed: \(data?["reason"] ?? "Unknown")")
                closeAd()

            case .play:
                print("Video play")

            case .pause:
                print("Video pause")

            case .complete:
                print("Video complete")
                closeAd()

            default:
                break
        }
    }
}
