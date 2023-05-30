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
    var placement: TeadsInReadAdPlacement?

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
        placement = Teads.createInReadPlacement(pid: Int(pid) ?? 0, settings: placementSettings, delegate: self)
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

extension InReadPageViewController: TeadsInReadAdPlacementDelegate {
    func didReceiveAd(ad: TeadsInReadAd, adRatio: TeadsAdRatio) {
        guard let currentViewController = currentViewControlelr as? InReadDirectPageViewController else {
            return
        }

        ad.delegate = currentViewController
        currentViewController.resizeTeadsAd(adRatio: adRatio)
        currentViewController.teadsAdView.bind(ad)
    }

    func didUpdateRatio(ad _: TeadsInReadAd, adRatio: TeadsAdRatio) {
        guard let currentViewController = currentViewControlelr as? InReadDirectPageViewController else {
            return
        }
        currentViewController.resizeTeadsAd(adRatio: adRatio)
    }

    func didFailToReceiveAd(reason _: AdFailReason) {
        print(#function)
    }

    func adOpportunityTrackerView(trackerView _: TeadsAdOpportunityTrackerView) {
        print(#function)
    }
}
