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

    // keep a strong reference to placement instance
    var placement: TeadsAdPlacementMedia?

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self

        loadPlacement()

        for index in 0 ..< 20 {
            if let viewController = storyboard?.instantiateViewController(withIdentifier: "page-view-controller") as? InReadDirectPageViewController {
                viewController.placement = placement
                viewController.articleLabelText = "ARTICLE \(index + 1) of 20"
                orderedViewControllers.append(viewController)
            }
        }
        currentViewControlelr = orderedViewControllers.first
        setViewControllers([currentViewControlelr!], direction: .forward, animated: true)
    }

    func loadPlacement() {
        let placementSettings = TeadsAdPlacementSettings { settings in
            settings.enableDebug()
        }
        let config = TeadsAdPlacementMediaConfig(
            pid: Int(pid) ?? 0,
            articleUrl: URL(string: "https://www.teads.com")
        )
        placement = TeadsAdPlacementMedia(config, delegate: self)
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
                if let adRatio = data?["adRatio"] as? TeadsAdRatio {
                    currentViewController.resizeTeadsAd(adRatio: adRatio)
                    // Ad view should be handled by the child view controller
                }
            case .heightUpdated:
                if let adRatio = data?["adRatio"] as? TeadsAdRatio {
                    currentViewController.resizeTeadsAd(adRatio: adRatio)
                }
            case .failed:
                print("didFailToReceiveAd")
            default:
                break
        }
    }
}
