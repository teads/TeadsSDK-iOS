//
//  TeadsGradienImageView.swift
//  TeadsDemoApp
//
//  Created by Jérémy Grosjean on 08/10/2020.
//  Copyright © 2020 Teads. All rights reserved.
//

import UIKit

@IBDesignable class TeadsGradientImageView: UIImageView {
    
    private lazy var gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [CGColor(red: UIColor.teadsPurple.getRedValue(), green: UIColor.teadsPurple.getGreenValue(), blue: UIColor.teadsPurple.getBlueValue(), alpha: 0.65), CGColor(red: UIColor.teadsBlue.getRedValue(), green: UIColor.teadsBlue.getGreenValue(), blue: UIColor.teadsBlue.getBlueValue(), alpha: 0.65)]
        gradientLayer.startPoint = CGPoint(x: 0, y: 1)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        return gradientLayer
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addGradient()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addGradient()
    }
    
    override func layoutSubviews() {
        addGradient()
    }
    
    func addGradient() {
        gradientLayer.frame = bounds
        if !(layer.sublayers?.contains(gradientLayer) ?? false) {
            layer.addSublayer(gradientLayer)
        }
    }
    
}
