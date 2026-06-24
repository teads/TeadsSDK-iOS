//
//  AdHostCells.swift
//  TeadsSampleApp
//
//  Copyright © 2026 Teads. All rights reserved.
//

import UIKit

/// Table cell that hosts an ad view pinned to its content, with an adjustable height.
final class AdHostTableViewCell: UITableViewCell {
    static let reuseId = "AdHostTableViewCell"
    private var heightConstraint: NSLayoutConstraint?

    func host(_ adView: UIView, height: CGFloat) {
        guard adView.superview !== contentView else {
            heightConstraint?.constant = height
            return
        }
        contentView.subviews.forEach { $0.removeFromSuperview() }
        adView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(adView)
        let heightConstraint = adView.heightAnchor.constraint(equalToConstant: height)
        heightConstraint.priority = .defaultHigh
        self.heightConstraint = heightConstraint
        NSLayoutConstraint.activate([
            adView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            adView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            adView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            adView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            heightConstraint,
        ])
    }
}

/// Plain article-text table cell.
final class ArticleTextTableViewCell: UITableViewCell {
    static let reuseId = "ArticleTextTableViewCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        textLabel?.numberOfLines = 0
        textLabel?.font = .systemFont(ofSize: 16)
        textLabel?.text = SampleArticleViews.paragraph
        selectionStyle = .none
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) { fatalError("init(coder:) is not supported") }
}
