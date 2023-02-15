//
//  CGFloat-extensions.swift
//  TeadsAdMobAdapter
//
//  Created by Thibaud Saint-Etienne on 15/07/2021.
//

import UIKit

extension CGFloat {
    var positive: CGFloat? {
        self > 0 ? self : nil
    }
}
