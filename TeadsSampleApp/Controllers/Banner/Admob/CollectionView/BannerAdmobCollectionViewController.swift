//
//  BannerAdmobCollectionViewController.swift
//  TeadsSampleApp
//
//  Copyright © 2026 Teads. All rights reserved.
//

import GoogleMobileAds
import TeadsAdMobAdapter
import TeadsSDK
import UIKit

/// AdMob banner (Teads adapter) inserted as an item inside a UICollectionView article.
class BannerAdmobCollectionViewController: TeadsViewController {
    private enum Item: Equatable {
        case article
        case ad
    }

    private var collectionView: UICollectionView!
    private let items: [Item] = [.article, .article, .ad, .article, .article]

    private var bannerView: AdManagerBannerView!
    private var adHeight: CGFloat = 250

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Banner — AdMob"
        view.backgroundColor = .systemBackground
        setupCollection()
        setupBanner()
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

    private func setupBanner() {
        bannerView = AdManagerBannerView(adSize: AdSizeFluid)
        // Declare the fluid request so Ad Manager can resolve the request type.
        bannerView.validAdSizes = [nsValue(for: AdSizeFluid)]
        bannerView.adUnitID = pid
        bannerView.rootViewController = self
        bannerView.delegate = self

        let adSettings = TeadsAdapterSettings { settings in
            settings.enableDebug()
            settings.registerAdView(bannerView, delegate: self)
        }
        let request = Request()
        request.register(adSettings)
        bannerView.load(request)
        reloadAdItem()
    }

    private func reloadAdItem() {
        guard let index = items.firstIndex(of: .ad) else { return }
        collectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
    }
}

extension BannerAdmobCollectionViewController: UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int { items.count }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch items[indexPath.item] {
            case .article:
                return collectionView.dequeueReusableCell(withReuseIdentifier: ArticleTextCollectionViewCell.reuseId, for: indexPath)
            case .ad:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AdHostCollectionViewCell.reuseId, for: indexPath) as! AdHostCollectionViewCell
                cell.host(bannerView, height: adHeight)
                return cell
        }
    }
}

extension BannerAdmobCollectionViewController: BannerViewDelegate {
    func bannerViewDidReceiveAd(_: BannerView) {}
    func bannerView(_: BannerView, didFailToReceiveAdWithError error: Error) {
        print("AdMob banner failed to load: \(error.localizedDescription)")
    }
}

extension BannerAdmobCollectionViewController: TeadsMediatedAdViewDelegate {
    func didUpdateRatio(_: UIView, adRatio: TeadsAdRatio) {
        let width = collectionView.bounds.width - 32
        adHeight = adRatio.calculateHeight(for: width)
        bannerView.resize(adSizeFor(cgSize: CGSize(width: width, height: adHeight)))
        reloadAdItem()
    }
}
