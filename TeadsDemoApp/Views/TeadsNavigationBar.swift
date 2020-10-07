//
//  TeadsNavigationBar.swift
//  TeadsDemoApp
//
//  Created by Jérémy Grosjean on 07/10/2020.
//  Copyright © 2020 Teads. All rights reserved.
//

import UIKit

class TeadsNavigationBar: UINavigationBar {

    override func awakeFromNib() {
        super.awakeFromNib()
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = [UIColor.teadsPurple.cgColor, UIColor.teadsBlue.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 1)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        setBackgroundImage(imageFromLayer(layer: gradient), for:  UIBarMetrics.default)
        
        let logo = UIImage(named: "logoTeads.png")
        let imageView = UIImageView(image:logo)
        topItem?.titleView = imageView
    }

    
    
    func imageFromLayer(layer: CALayer) -> UIImage? {
        UIGraphicsBeginImageContext(layer.frame.size);

        layer.render(in: UIGraphicsGetCurrentContext()!)
        let outputImage = UIGraphicsGetImageFromCurrentImageContext();

        UIGraphicsEndImageContext();

        return outputImage;
    }
}
