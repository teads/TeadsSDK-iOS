//
//  AdOpportunityTrackerCollectionViewCell.swift
//  TeadsSampleApp
//
//  Created by Paul Nicolas on 17/01/2022.
//  Copyright © 2022 Teads. All rights reserved.
//

import UIKit
import TeadsSDK

/// Implement this cell to track slot
class AdOpportunityTrackerCollectionViewCell: UICollectionViewCell {
    static let identifier = "AdOpportunityTrackerCollectionViewCellIdentifier"
    func setTrackerView(_ trackerView: TeadsAdOpportunityTrackerView) {
        contentView.addSubview(trackerView)
    }
}
