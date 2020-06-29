//
//  TeadsNativeAdView.swift
//  TeadsSDK
//
//  Created by Gwendal Madouas on 04/03/2020.
//  Copyright © 2020 Teads. All rights reserved.
//

import Foundation

@IBDesignable public class TeadsNativeAdView: UIView {
    @IBOutlet public weak var titleLabel: UILabel?
    @IBOutlet public weak var contentLabel: UILabel?
    @IBOutlet public weak var mediaView: TeadsMediaView?
    @IBOutlet public weak var iconImageView: UIImageView?
    @IBOutlet public weak var advertiserLabel: UILabel?
    @IBOutlet public weak var callToActionButton: UIButton?
    @IBOutlet public weak var ratingView: UIView?
    @IBOutlet public weak var priceLabel: UILabel?

    @objc public enum Template: Int, Codable {
        case mopub = -2
        case admob = -1
        case feedArticle = 0
    }

    @objc public var nativeAd: TeadsNativeAd? {
        didSet {
            guard let nativeAd = nativeAd else {
                return
            }

            bind(nativeAd)
        }
    }
}
