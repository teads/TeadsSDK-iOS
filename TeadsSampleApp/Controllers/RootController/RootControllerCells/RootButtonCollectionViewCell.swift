//
//  RootButtonCollectionViewCell.swift
//  TeadsSampleApp
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
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected != oldValue {
                label.backgroundColor = .primary
                label.textColor = .white
                layer.borderColor = UIColor.primary.cgColor
            } else {
                label.backgroundColor = .appBackground
                label.textColor = .cellBorder
                layer.borderColor = UIColor.cellBorder.cgColor
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
