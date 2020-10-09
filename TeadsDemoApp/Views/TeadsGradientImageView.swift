//
//  TeadsGradienImageView.swift
//  TeadsDemoApp
//
//  Created by Jérémy Grosjean on 08/10/2020.
//  Copyright © 2020 Teads. All rights reserved.
//

import UIKit

class TeadsGradientImageView: UIImageView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        addGradient()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addGradient()
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addGradient()
    }
    
    
    func addGradient() {
        let gradient = CAGradientLayer()
        gradient.frame = bounds

        gradient.colors = [CGColor(red: UIColor.teadsPurple.getRedValue(), green: UIColor.teadsPurple.getGreenValue(), blue: UIColor.teadsPurple.getBlueValue(), alpha: 0.65), CGColor(red: UIColor.teadsBlue.getRedValue(), green: UIColor.teadsBlue.getGreenValue(), blue: UIColor.teadsBlue.getBlueValue(), alpha: 0.65)]
        gradient.startPoint = CGPoint(x: 0, y: 1)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        layer.addSublayer(gradient)
    }
    
}
