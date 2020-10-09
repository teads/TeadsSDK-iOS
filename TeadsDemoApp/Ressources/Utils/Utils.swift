//
//  Utils.swift
//  TeadsDemoApp
//
//  Created by Jérémy Grosjean on 09/10/2020.
//  Copyright © 2020 Teads. All rights reserved.
//

import Foundation
import UIKit


struct Utils {
    
    static func teadsNavigationBar(navigationBar: UINavigationBar, navigationItem: UINavigationItem) {
        let gradient = CAGradientLayer()
        gradient.frame = navigationBar.bounds
        gradient.colors = [UIColor.teadsPurple.cgColor, UIColor.teadsBlue.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 1)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        navigationBar.setBackgroundImage(Utils.imageFromLayer(layer: gradient), for:  UIBarMetrics.default)
        
        let logo = UIImage(named: "Teads-Demo-App-white")
        let imageView = UIImageView(image:logo)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        navigationItem.titleView = imageView
    }
    
    static func imageFromLayer(layer: CALayer) -> UIImage? {
       UIGraphicsBeginImageContext(layer.frame.size);
       
       layer.render(in: UIGraphicsGetCurrentContext()!)
       let outputImage = UIGraphicsGetImageFromCurrentImageContext();
       
       UIGraphicsEndImageContext();
       
       return outputImage;
   }
}

