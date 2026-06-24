//
//  TeadsViewController.swift
//  TeadsSampleApp
//
//  Created by Jérémy Grosjean on 07/10/2020.
//  Copyright © 2020 Teads. All rights reserved.
//

import UIKit

class TeadsViewController: UIViewController {
    var hasTeadsArticleNavigationBar = true
    var pid: String = PID.directLandscape

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        hasTeadsArticleNavigationBar ? applyTeadsArticleNavigationBar() : applyDefaultNavigationBar()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        hasTeadsArticleNavigationBar ? applyTeadsArticleNavigationBar() : applyDefaultNavigationBar()
    }

    fileprivate func imageFromLayer(layer: CALayer) -> UIImage? {
        UIGraphicsBeginImageContext(layer.frame.size)

        layer.render(in: UIGraphicsGetCurrentContext()!)
        let outputImage = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()

        return outputImage
    }

    fileprivate func applyTeadsArticleNavigationBar() {
        guard let navigationBar = navigationController?.navigationBar else {
            return
        }
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = navigationBar.bounds
        gradientLayer.colors = [UIColor.teadsPurple.cgColor, UIColor.teadsBlue.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 1)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        let backgroundImage = imageFromLayer(layer: gradientLayer)
        navigationBar.setBackgroundImage(backgroundImage, for: .default)

        navigationItem.titleView = TeadsLogoUIView(dark: true)

        navigationBar.tintColor = .white

        if #available(iOS 15, *) {
            navigationBar.barStyle = .black

            let appearance = navigationBar.standardAppearance
            appearance.backgroundImage = backgroundImage
            navigationBar.standardAppearance = appearance
            navigationBar.scrollEdgeAppearance = appearance
            navigationBar.compactAppearance = appearance
        }
    }

    fileprivate func applyDefaultNavigationBar() {
        guard let navigationBar = navigationController?.navigationBar else {
            return
        }
        navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationBar.shadowImage = UIImage()
        navigationItem.titleView = TeadsLogoUIView(dark: false)
        if #available(iOS 15, *) {
            let appearance = navigationBar.standardAppearance
            appearance.backgroundImage = UIImage()
            appearance.shadowImage = UIImage()
            navigationBar.standardAppearance = appearance
            navigationBar.scrollEdgeAppearance = appearance
            navigationBar.compactAppearance = appearance
        }
    }
}
