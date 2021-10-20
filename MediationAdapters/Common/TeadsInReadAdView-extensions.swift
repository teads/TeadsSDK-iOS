//
//  TeadsInReadAdView-extensions.swift
//  TeadsAdMobAdapter
//
//  Created by Thibaud Saint-Etienne on 15/07/2021.
//

import TeadsSDK
import UIKit
extension TeadsInReadAdView {

    func updateHeight(with adRatio: TeadsAdRatio) {
        if let width = superview?.frame.width.positive ?? frame.width.positive {
            frame = CGRect(origin: CGPoint.zero, size: CGSize(width: width, height: adRatio.calculateHeight(for: width)))
            layoutIfNeeded()
        }
    }
}
