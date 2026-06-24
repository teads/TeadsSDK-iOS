//
//  SampleArticleViews.swift
//  TeadsSampleApp
//
//  Copyright © 2026 Teads. All rights reserved.
//

import UIKit

/// Reusable fake-article building blocks shared by the programmatic sample controllers.
enum SampleArticleViews {
    static let paragraph = """
    Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt \
    ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco \
    laboris nisi ut aliquip ex ea commodo consequat.
    """

    static func headerImageView(height: CGFloat = 200) -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemBlue
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: height).isActive = true
        return imageView
    }

    static func titleLabel(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.numberOfLines = 0
        return label
    }

    static func paragraphLabel() -> UILabel {
        let label = UILabel()
        label.text = paragraph
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.textColor = .label
        return label
    }
}
