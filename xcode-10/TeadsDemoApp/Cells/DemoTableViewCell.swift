//
//  DemoTableViewCell.swift
//  TeadsDemoApp
//
//  Created by Jérémy Grosjean on 28/09/2017.
//  Copyright © 2017 Jérémy Grosjean. All rights reserved.
//

import UIKit

class DemoTableViewCell: UITableViewCell {

    @IBOutlet weak var demoLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
