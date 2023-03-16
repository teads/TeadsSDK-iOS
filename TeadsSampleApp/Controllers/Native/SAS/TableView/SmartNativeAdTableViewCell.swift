//
//  SmartNativeAdTableViewCell.swift
//  TeadsSampleApp
//
//  Created by Paul NICOLAS on 13/03/2023.
//  Copyright © 2023 Teads. All rights reserved.
//

import SASDisplayKit
import UIKit

class SmartNativeAdTableViewCell: UITableViewCell {
    @IBOutlet public var titleLabel: UILabel?
    @IBOutlet public var contentLabel: UILabel?
    @IBOutlet public var mediaView: UIView!
    @IBOutlet public var iconImageView: UIImageView?
    @IBOutlet public var advertiserLabel: UILabel?
    @IBOutlet public var callToActionButton: UIButton?
    @IBOutlet public var ratingView: UIView?
    @IBOutlet public var priceLabel: UILabel?
}

extension SmartNativeAdTableViewCell {
    func bind(sasNativeAd: SASNativeAd) {
        titleLabel?.text = sasNativeAd.title
        contentLabel?.text = sasNativeAd.subtitle

        if sasNativeAd.hasMedia {
            let sasMediaView = SASNativeAdMediaView()
            sasMediaView.frame = mediaView.bounds
            sasMediaView.registerNativeAd(sasNativeAd)
            mediaView.addSubview(sasMediaView)
        } else {
            sasNativeAd.coverImage?.load { image in
                let imageView = UIImageView(image: image)
                imageView.frame = self.mediaView.bounds
                imageView.contentMode = .scaleAspectFill
                self.mediaView?.addSubview(imageView)
            }
        }

        sasNativeAd.icon?.load { image in
            self.iconImageView?.image = image
            self.iconImageView?.contentMode = .scaleAspectFill
        }

        advertiserLabel?.text = sasNativeAd.sponsored
        callToActionButton?.setTitle(sasNativeAd.callToAction, for: .normal)
        priceLabel?.text = sasNativeAd.price
    }
}

extension SASNativeAdImage {
    func load(success: @escaping (UIImage) -> Void) {
        let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
        let dataTask = defaultSession.dataTask(with: url) { data, _, _ in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    success(image)
                }
            }
        }
        dataTask.resume()
    }
}
