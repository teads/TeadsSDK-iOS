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
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var stackView: UIStackView! // Stack view to manage dynamic content

    var adHeightConstraints: [NSLayoutConstraint] = []
    var adRatios: [TeadsAdRatio?] = []
    var placement: TeadsInReadAdPlacement?

    // Array to keep a strong reference to the ads
    private var ads: [TeadsInReadAd] = []

    private var adViews: [TeadsInReadAdView] = []

    // Track if a placeholder has already been bound to an ad
    var adBoundFlags: [Bool] = []

    // Number of ads to request
    var maxAds = 5

    override func viewDidLoad() {
        super.viewDidLoad()

        let pSettings = TeadsAdPlacementSettings { settings in
            settings.enableDebug()
        }

        // Create placement, keeping a strong reference
        placement = Teads.createInReadPlacement(pid: Int(pid) ?? 0, settings: pSettings, delegate: self)

        // Request multiple ads
        for _ in 0 ..< maxAds {
            placement?.requestAd(requestSettings: TeadsAdRequestSettings { settings in
                settings.pageUrl("https://www.teads.com")
            })
        }

        // Dynamically add fake articles and placeholders for ads
        for i in 0 ..< 10 {
            // Add fake article view
            let fakeArticleView = createFakeArticleView(text: "Article \(i + 1)\nLorem ipsum dolor sit amet, consectetur adipiscing elit. Donec ornare hendrerit nulla, vitae ornare ipsum placerat vitae. Praesent mi massa, pretium sed gravida eget, maximus vitae lectus. Phasellus ornare mattis arcu, quis aliquet ligula maximus ac. Vestibulum pellentesque aliquet tortor, vel tincidunt ligula placerat vel. Maecenas mauris arcu, sagittis vitae vestibulum eu, dignissim a nunc. Nunc pharetra turpis ut faucibus porttitor. Morbi a lorem a tortor tincidunt scelerisque id non felis. In hac habitasse platea dictumst. Quisque sem est, facilisis gravida massa in, posuere tempus nunc. Morbi fringilla risus in consequat tincidunt.")
            stackView.addArrangedSubview(fakeArticleView)

            // Insert ads between articles (for example, every 2 articles)
            if i % 2 == 0 {
                let adPlaceholderView = createAdPlaceholderView()
                adViews.append(adPlaceholderView)
                stackView.addArrangedSubview(adPlaceholderView)
                adBoundFlags.append(false) // Add a flag to track this placeholder
            }
        }

        // Observer to detect orientation changes for resizing the ad
        NotificationCenter.default.addObserver(self, selector: #selector(rotationDetected), name: UIDevice.orientationDidChangeNotification, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc func rotationDetected() {
        // Resize each ad upon orientation change
        for (index, adRatio) in adRatios.enumerated() {
            if let adRatio = adRatio {
                resizeTeadsAd(at: index, adRatio: adRatio)
            }
        }
    }

    // Function to create fake article views
    func createFakeArticleView(text: String) -> UIView {
        let label = UILabel()
        label.text = text
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        let containerView = UIView()
        containerView.addSubview(label)

        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            label.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            label.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8),
        ])

        return containerView
    }

    // Function to create placeholder views for ads
    func createAdPlaceholderView() -> TeadsInReadAdView {
        let adPlaceholderView = TeadsInReadAdView()

        // Set initial placeholder height
        let initialHeightConstraint = adPlaceholderView.heightAnchor.constraint(equalToConstant: 250)
        initialHeightConstraint.isActive = true

        // Store the initial height constraint so we can deactivate it later
        adHeightConstraints.append(initialHeightConstraint)

        return adPlaceholderView
    }

    // Function to resize a specific ad
    func resizeTeadsAd(at index: Int, adRatio: TeadsAdRatio) {
        guard index < adViews.count else { return } // Ensure index is within bounds

        let adView = adViews[index]

        // Calculate the new height based on the width of the adView
        let newHeight = adRatio.calculateHeight(for: adView.frame.width)

        print("Resizing ad at index \(index) to height \(newHeight) based on width \(adView.frame.width)")

        // Check if there is a previous height constraint at this index
        if index < adHeightConstraints.count {
            // Deactivate the existing height constraint
            adHeightConstraints[index].isActive = false
        }

        // Create and activate a new height constraint
        let newHeightConstraint = adView.heightAnchor.constraint(equalToConstant: newHeight)
        newHeightConstraint.isActive = true

        // If the index exists, update it; if not, append the new constraint
        if index < adHeightConstraints.count {
            adHeightConstraints[index] = newHeightConstraint
        } else {
            adHeightConstraints.append(newHeightConstraint)
        }

        // Trigger layout updates
        stackView.layoutIfNeeded()
        scrollView.layoutIfNeeded()
    }

    // Close a specific ad
    func closeAd(at index: Int) {
        adViews[index].removeFromSuperview() // Remove the ad view
        adHeightConstraints[index].constant = 0 // Set the height to 0
    }
}

extension InReadDirectScrollViewController: TeadsInReadAdPlacementDelegate {
    func adOpportunityTrackerView(trackerView: TeadsAdOpportunityTrackerView) {
        // Add the tracker view to the stackView (if needed)
        stackView.addArrangedSubview(trackerView)

        // Disable automatic constraints handling for the tracker view
        trackerView.translatesAutoresizingMaskIntoConstraints = false

        // Set constraints for the tracker view (leading, trailing, top, bottom)
        NSLayoutConstraint.activate([
            trackerView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 16),
            trackerView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -16),
        ])
    }

    // Ad has been received
    func didReceiveAd(ad: TeadsInReadAd, adRatio: TeadsAdRatio) {
        print("Ad received successfully")

        // Keep a strong reference to the ad
        ads.append(ad)

        // Find the next available (unbound) ad placeholder
        if let index = adBoundFlags.firstIndex(of: false) {
            print("Found unbound ad placeholder at index \(index)")
            // Get the corresponding TeadsInReadAdView at that index
            let adPlaceholderView = adViews[index] as TeadsInReadAdView // Assuming ads are placed after every 2 articles

            // Bind the ad to the placeholder view
            adPlaceholderView.bind(ad)
            ad.delegate = self

            // Mark the placeholder as bound
            adBoundFlags[index] = true

            // Setup layout for the ad view
            adPlaceholderView.translatesAutoresizingMaskIntoConstraints = false
            let heightConstraint = adPlaceholderView.heightAnchor.constraint(equalToConstant: adRatio.calculateHeight(for: adPlaceholderView.frame.width))
            heightConstraint.isActive = true
            adHeightConstraints.append(heightConstraint)
            adRatios.append(adRatio)

            // Resize the ad if needed
            resizeTeadsAd(at: ads.count - 1, adRatio: adRatio)
        }
    }

    // Failed to receive the ad
    func didFailToReceiveAd(reason _: AdFailReason) {
        // Handle failure
        print("Failed to receive ad")
    }

    // Update the ratio when it changes
    func didUpdateRatio(ad: TeadsInReadAd, adRatio: TeadsAdRatio) {
        if let index = ads.firstIndex(of: ad) {
            resizeTeadsAd(at: index, adRatio: adRatio)
        }
    }
}

extension InReadDirectScrollViewController: TeadsAdDelegate {
    func willPresentModalView(ad _: TeadsAd) -> UIViewController? {
        return self
    }

    func didCatchError(ad: TeadsAd, error _: Error) {
        if let index = ads.firstIndex(of: ad as! TeadsInReadAd) {
            closeAd(at: index)
        }
    }

    func didClose(ad: TeadsAd) {
        if let index = ads.firstIndex(of: ad as! TeadsInReadAd) {
            closeAd(at: index)
        }
    }

    func didRecordImpression(ad _: TeadsAd) {}

    func didRecordClick(ad _: TeadsAd) {}

    func didExpandedToFullscreen(ad _: TeadsAd) {}

    func didCollapsedFromFullscreen(ad _: TeadsAd) {}
}
