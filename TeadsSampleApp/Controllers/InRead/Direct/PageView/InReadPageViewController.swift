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

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self

        for index in 0 ..< 20 {
            if let viewController = storyboard?.instantiateViewController(withIdentifier: "page-view-controller") as? InReadDirectPageViewController {
                viewController.pid = pid
                viewController.articleLabelText = "ARTICLE \(index + 1) of 20"
                orderedViewControllers.append(viewController)
            }
        }
        currentViewControlelr = orderedViewControllers.first
        setViewControllers([currentViewControlelr!], direction: .forward, animated: true)
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
