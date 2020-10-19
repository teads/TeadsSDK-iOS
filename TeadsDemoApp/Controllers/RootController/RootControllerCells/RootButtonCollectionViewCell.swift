//
//  RootButtonCollectionViewCell.swift
//  TeadsDemoApp
//
//  Created by Thibaud Saint-Etienne on 16/10/2020.
//  Copyright © 2020 Teads. All rights reserved.
//

import UIKit

class RootButtonCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 12
        layer.borderWidth = 1
        layer.borderColor = UIColor.primary.cgColor
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                label.backgroundColor = .primary
                label.textColor = .white
            } else {
                label.backgroundColor = .appBackground
                label.textColor = .primary
            }
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.1) {
                if self.isHighlighted && !self.isSelected {
                    self.alpha = 0.5
                } else {
                    self.alpha = 1
                }
            }
        }
    }

}
