//
//  FeedDirectCollectionViewController.swift
//  TeadsSampleApp
//
//  Copyright © 2026 Teads. All rights reserved.
//

import TeadsSDK
import UIKit

/// Direct Feed placement anchored as the last (bottom) item of a UICollectionView article.
class FeedDirectCollectionViewController: TeadsViewController {
    private enum Item: Equatable {
        case article
        case ad
    }

    private var collectionView: UICollectionView!
    private let items: [Item] = [.article, .article, .article, .article, .ad]

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
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        collectionView.isPrefetchingEnabled = false
        collectionView.dataSource = self
        collectionView.delegate = self
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

    private func articleHeight(forWidth width: CGFloat) -> CGFloat {
        let text = SampleArticleViews.paragraph as NSString
        let rect = text.boundingRect(
            with: CGSize(width: width - 32, height: .greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: [.font: UIFont.systemFont(ofSize: 16)],
            context: nil
        )
        return ceil(rect.height) + 24
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
                if let adView { cell.host(adView) }
                return cell
        }
    }
}

extension FeedDirectCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        switch items[indexPath.item] {
            case .ad:
                return CGSize(width: width, height: adHeight)
            case .article:
                return CGSize(width: width, height: articleHeight(forWidth: width))
        }
    }
}

extension FeedDirectCollectionViewController: TeadsAdPlacementEventsDelegate {
    func adPlacement(_: TeadsAdPlacementIdentifiable?, didEmitEvent event: TeadsAdPlacementEventName, data: [String: Any]?) {
        if event == .heightUpdated, let height = data?["height"] as? CGFloat {
            adHeight = height
            // Re-apply sizes without rebuilding the ad cell.
            collectionView.performBatchUpdates(nil, completion: nil)
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
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
        ])
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) { fatalError("init(coder:) is not supported") }
}

/// Hosts the feed ad view, top-anchored so a tall ad isn't clipped.
final class AdHostCollectionViewCell: UICollectionViewCell {
    static let reuseId = "AdHostCollectionViewCell"

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
