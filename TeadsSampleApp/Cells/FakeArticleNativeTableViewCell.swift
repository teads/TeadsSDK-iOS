//
//  FakeArticleNativeTableViewCell.swift
//  TeadsSDKIntegrationTestsApp
//
//  Created by Thibaud Saint-Etienne on 02/12/2020.
//

import UIKit

@objc protocol FakeNativeCell {
    var mediaView: UIImageView! { get }
    var iconImageView: UIImageView! { get }
    var titleLabel: UILabel! { get }
    var contentLabel: UILabel! { get }
    var callToActionButton: UIButton! { get }
    func openTeadsWebsite()
}

extension FakeNativeCell {
    func setMockValues() {
        mediaView.image = UIImage(named: "social-covers")
        iconImageView.image = UIImage(named: "teads-logo")
        titleLabel.text = "Teads"
        contentLabel.text = "The global media platform"
        callToActionButton.setTitle("Discover", for: .normal)
        callToActionButton.addTarget(self, action: #selector(openTeadsWebsite), for: .touchUpInside)
    }
}

class FakeArticleNativeTableViewCell: UITableViewCell, FakeNativeCell {
    @IBOutlet var mediaView: UIImageView!
    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var contentLabel: UILabel!
    @IBOutlet var callToActionButton: UIButton!

    @objc func openTeadsWebsite() {
        if let url = URL(string: "https://teads.com") {
            UIApplication.shared.open(url)
        }
    }
}

class FakeArticleNativeCollectionViewCell: UICollectionViewCell, FakeNativeCell {
    @IBOutlet var mediaView: UIImageView!
    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var contentLabel: UILabel!
    @IBOutlet var callToActionButton: UIButton!

    @objc func openTeadsWebsite() {
        if let url = URL(string: "https://teads.com") {
            UIApplication.shared.open(url)
        }
    }
}
