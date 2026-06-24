//
//  FeedDirectCollectionViewController.swift
//  TeadsSampleApp
//
//  Copyright © 2026 Teads. All rights reserved.
//

import TeadsSDK
import UIKit

/// Direct Feed placement inserted as an item inside a UICollectionView article.
class FeedDirectCollectionViewController: TeadsViewController {
    private enum Item: Equatable {
        case article
        case ad
    }

    private var collectionView: UICollectionView!
    private let items: [Item] = [.article, .article, .ad, .article, .article]

    private var placement: TeadsAdPlacementFeed?
    private var adView: UIView?
    private var adHeight: CGFloat = 250

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Feed — Direct"
        view.backgroundColor = .systemBackground
        setupCollection()
        loadFeed()
    }

    private func setupCollection() {
        let layout = UICollectionViewCompositionalLayout { _, _ in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(120))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let group = NSCollectionLayoutGroup.vertical(layoutSize: itemSize, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)
            section.interGroupSpacing = 12
            return section
        }
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        collectionView.dataSource = self
        collectionView.register(ArticleTextCollectionViewCell.self, forCellWithReuseIdentifier: ArticleTextCollectionViewCell.reuseId)
        collectionView.register(AdHostCollectionViewCell.self, forCellWithReuseIdentifier: AdHostCollectionViewCell.reuseId)
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    private func loadFeed() {
        let config = TeadsAdPlacementFeedConfig(
            articleUrl: URL(string: PID.outbrainArticleUrl)!,
            widgetId: PID.feedWidgetId,
            installationKey: PID.outbrainInstallationKey,
            widgetIndex: 0
        )
        placement = Teads.createPlacement(with: config, delegate: self)
        adView = try? placement?.loadAd()
        reloadAdItem()
    }

    private func reloadAdItem() {
        guard let index = items.firstIndex(of: .ad) else { return }
        collectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
    }
}

extension FeedDirectCollectionViewController: UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int { items.count }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch items[indexPath.item] {
            case .article:
                return collectionView.dequeueReusableCell(withReuseIdentifier: ArticleTextCollectionViewCell.reuseId, for: indexPath)
            case .ad:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AdHostCollectionViewCell.reuseId, for: indexPath) as! AdHostCollectionViewCell
                if let adView { cell.host(adView, height: adHeight) }
                return cell
        }
    }
}

extension FeedDirectCollectionViewController: TeadsAdPlacementEventsDelegate {
    func adPlacement(_: TeadsAdPlacementIdentifiable?, didEmitEvent event: TeadsAdPlacementEventName, data: [String: Any]?) {
        if event == .heightUpdated, let height = data?["height"] as? CGFloat {
            adHeight = height
            reloadAdItem()
        }
    }
}

/// Article-text collection cell.
final class ArticleTextCollectionViewCell: UICollectionViewCell {
    static let reuseId = "ArticleTextCollectionViewCell"
    override init(frame: CGRect) {
        super.init(frame: frame)
        let label = SampleArticleViews.paragraphLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: contentView.topAnchor),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) { fatalError("init(coder:) is not supported") }
}

/// Collection cell that hosts an ad view with an adjustable height.
final class AdHostCollectionViewCell: UICollectionViewCell {
    static let reuseId = "AdHostCollectionViewCell"
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
            adView.topAnchor.constraint(equalTo: contentView.topAnchor),
            adView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            adView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            adView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            heightConstraint,
        ])
    }
}
