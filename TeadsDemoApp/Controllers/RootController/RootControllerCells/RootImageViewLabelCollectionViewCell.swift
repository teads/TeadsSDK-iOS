//
//  RootImageViewLabelCollectionViewCell.swift
//  TeadsDemoApp
//
//  Created by Thibaud Saint-Etienne on 16/10/2020.
//  Copyright © 2020 Teads. All rights reserved.
//

import UIKit

class RootImageViewLabelCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 12
        layer.borderWidth = 1
        layer.borderColor = UIColor.teadsGray.cgColor
        
        label.textColor = .teadsGray
    }
    
    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.1) {
                if self.isHighlighted {
                    self.alpha = 0.5
                } else {
                    self.alpha = 1
                }
            }
        }
    }

}
