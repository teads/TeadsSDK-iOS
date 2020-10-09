//
//  RootButtonIconLabelTableViewCell.swift
//  TeadsDemoApp
//
//  Created by Thibaud Saint-Etienne on 06/10/2020.
//  Copyright © 2020 Teads. All rights reserved.
//

import UIKit

class RootButtonIconLabelTableViewCell: UITableViewCell {

    @IBOutlet weak var firstCard: ImageLabelButtonView!
    @IBOutlet weak var secondCard: ImageLabelButtonView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
