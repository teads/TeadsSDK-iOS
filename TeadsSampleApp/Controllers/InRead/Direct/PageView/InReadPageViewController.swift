//
//  InReadPageViewController.swift
//  TeadsSampleApp
//
//  Created by Paul NICOLAS on 29/05/2023.
//  Copyright © 2023 Teads. All rights reserved.
//

import Foundation
import TeadsSDK
import UIKit

class InReadPageViewController: UIPageViewController {
    var pid: String = PID.directLandscape
    var orderedViewControllers: [UIViewController] = []
    var currentViewControlelr: UIViewController?

    // keep a strong reference to placement instance and ad view
    var placement: TeadsAdPlacementMedia?
    var adView: UIView?
    var currentAdHeight: CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self

        loadPlacement()

        for index in 0 ..< 20 {
            if let viewController = storyboard?.instantiateViewController(withIdentifier: "page-view-controller") as? InReadDirectPageViewController {
                viewController.adViewReference = adView
                viewController.articleLabelText = "ARTICLE \(index + 1) of 20"
                orderedViewControllers.append(viewController)
            }
        }
        currentViewControlelr = orderedViewControllers.first
        setViewControllers([currentViewControlelr!], direction: .forward, animated: true)
    }

    func loadPlacement() {
        // Create placement with new API
        let config = TeadsAdPlacementMediaConfig(
            pid: Int(pid) ?? 0,
            articleUrl: URL(string: "https://www.teads.com"),
            enableValidationMode: true
        )

        placement = Teads.createPlacement(with: config, delegate: self)

        // Load ad and store view
        if let view = try? placement?.loadAd() {
            adView = view
        }
    }
}

extension InReadPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let currentIndex = orderedViewControllers.firstIndex(of: viewController),
           currentIndex > 0 {
            currentViewControlelr = orderedViewControllers[currentIndex - 1]
            return currentViewControlelr
        }
        return nil
    }

    func pageViewController(_: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let currentIndex = orderedViewControllers.firstIndex(of: viewController),
           currentIndex < orderedViewControllers.count - 1 {
            currentViewControlelr = orderedViewControllers[currentIndex + 1]
            return currentViewControlelr
        }
        return nil
    }
}

extension InReadPageViewController: TeadsAdPlacementEventsDelegate {
    func adPlacement(
        _: TeadsAdPlacementIdentifiable?,
        didEmitEvent event: TeadsAdPlacementEventName,
        data: [String: Any]?
    ) {
        guard let currentViewController = currentViewControlelr as? InReadDirectPageViewController else {
            return
        }

        switch event {
            case .ready:
                print("Ad ready")
                // Add ad view to current child's container
                if let view = adView {
                    currentViewController.setupAdView(view)
                }

            case .rendered:
                print("Ad rendered")

            case .heightUpdated:
                if let height = data?["height"] as? CGFloat {
                    currentAdHeight = height
                    currentViewController.updateAdHeight(height)
                }

            case .viewed:
                print("Ad viewed (impression)")

            case .clicked:
                print("Ad clicked")

            case .failed:
                print("Ad failed: \(data?["reason"] ?? "Unknown")")
                currentViewController.closeAd()

            case .complete:
                print("Video complete")
                currentViewController.closeAd()

            default:
                break
        }
    }
}
