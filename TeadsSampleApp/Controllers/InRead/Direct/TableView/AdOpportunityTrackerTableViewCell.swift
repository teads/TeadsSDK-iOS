//
//  AdOpportunityTrackerTableViewCell.swift
//  TeadsSampleApp
//
//  Created by Paul Nicolas on 17/01/2022.
//  Copyright © 2022 Teads. All rights reserved.
//

import TeadsSDK
import UIKit

/// Implement this cell to track slot
class AdOpportunityTrackerTableViewCell: UITableViewCell {
    static let identifier = "AdOpportunityTrackerTableViewCellIndentifier"
    func setTrackerView(_ trackerView: TeadsAdOpportunityTrackerView) {
        contentView.addSubview(trackerView)
    }
}
