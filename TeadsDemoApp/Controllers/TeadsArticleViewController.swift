//
//  TeadsArticleViewController.swift
//  TeadsDemoApp
//
//  Created by Jérémy Grosjean on 07/10/2020.
//  Copyright © 2020 Teads. All rights reserved.
//

import UIKit

class TeadsArticleViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let gradient = CAGradientLayer()
        gradient.frame = navigationController?.navigationBar.bounds ?? CGRect.zero
        gradient.colors = [UIColor.teadsPurple.cgColor, UIColor.teadsBlue.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 1)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        navigationController?.navigationBar.setBackgroundImage(imageFromLayer(layer: gradient), for:  UIBarMetrics.default)
        
        let logo = UIImage(named: "Teads-Demo-App-white")
        let imageView = UIImageView(image:logo)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        self.navigationItem.titleView = imageView

        
    }
    
    func imageFromLayer(layer: CALayer) -> UIImage? {
        UIGraphicsBeginImageContext(layer.frame.size);
        
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let outputImage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        return outputImage;
    }
    
}
