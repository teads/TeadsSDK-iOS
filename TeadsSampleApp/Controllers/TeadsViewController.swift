//
//  TeadsViewController.swift
//  TeadsSampleApp
//
//  Created by Jérémy Grosjean on 07/10/2020.
//  Copyright © 2020 Teads. All rights reserved.
//

import UIKit

class TeadsViewController: UIViewController {
    
    var hasTeadsArticleNavigationBar: Bool = true
    var pid: String = PID.directLandscape
    fileprivate let teadsLogo = UIImage(named: "Teads-Sample-App")
    fileprivate let teadsLogoWhite = UIImage(named: "Teads-Sample-App-White")
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        hasTeadsArticleNavigationBar ? applyTeadsArticleNavigationBar() : applyDefaultNavigationBar()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        hasTeadsArticleNavigationBar ? applyTeadsArticleNavigationBar() : applyDefaultNavigationBar()
    }
    
    fileprivate func imageFromLayer(layer: CALayer) -> UIImage? {
        UIGraphicsBeginImageContext(layer.frame.size);
        
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let outputImage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        return outputImage;
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
        
        let imageView = UIImageView(image: teadsLogoWhite)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        navigationItem.titleView = imageView
        
        navigationBar.tintColor = .white
    }
    
    fileprivate func applyDefaultNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        let imageView = UIImageView(image: teadsLogo)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        navigationItem.titleView = imageView
    }
    
}
