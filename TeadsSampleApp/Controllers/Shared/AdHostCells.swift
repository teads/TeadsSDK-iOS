//
//  AdHostCells.swift
//  TeadsSampleApp
//
//  Copyright © 2026 Teads. All rights reserved.
//

import UIKit

/// Hosts an ad view; the controller drives the row height.
final class AdHostTableViewCell: UITableViewCell {
    static let reuseId = "AdHostTableViewCell"

    func host(_ adView: UIView) {
        guard adView.superview !== contentView else { return }
        contentView.subviews.forEach { $0.removeFromSuperview() }
        adView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(adView)
        NSLayoutConstraint.activate([
            adView.topAnchor.constraint(equalTo: contentView.topAnchor),
            adView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            adView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            adView.bottomAnchor.constraint(greaterThanOrEqualTo: contentView.bottomAnchor),
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
