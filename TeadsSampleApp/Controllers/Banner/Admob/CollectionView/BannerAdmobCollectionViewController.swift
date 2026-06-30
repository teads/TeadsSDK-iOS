//
//  BannerAdmobCollectionViewController.swift
//  TeadsSampleApp
//
//  Copyright © 2026 Teads. All rights reserved.
//

import GoogleMobileAds
import UIKit

/// AdMob banner (Teads adapter) anchored to the bottom of the screen over a
/// scrolling collection-view article. Uses a fixed 320×50 banner; mediation is
/// resolved server-side from the ad unit.
class BannerAdmobCollectionViewController: TeadsViewController {
    private var collectionView: UICollectionView!
    private let itemCount = 8
    private var bannerView: BannerView!

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
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    private func setupBanner() {
        bannerView = BannerView(adSize: AdSizeBanner)
        bannerView.adUnitID = pid
        bannerView.rootViewController = self
        bannerView.delegate = self
        bannerView.isAutoloadEnabled = false
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        NSLayoutConstraint.activate([
            bannerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bannerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

        // Reserve room so the last content clears the anchored banner.
        collectionView.contentInset.bottom = AdSizeBanner.size.height
        collectionView.verticalScrollIndicatorInsets.bottom = AdSizeBanner.size.height

        bannerView.load(Request())
    }
}

extension BannerAdmobCollectionViewController: UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int { itemCount }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.dequeueReusableCell(withReuseIdentifier: ArticleTextCollectionViewCell.reuseId, for: indexPath)
    }
}

extension BannerAdmobCollectionViewController: BannerViewDelegate {
    func bannerViewDidReceiveAd(_: BannerView) {}
    func bannerView(_: BannerView, didFailToReceiveAdWithError error: Error) {
        print("AdMob banner failed to load: \(error.localizedDescription)")
    }
}
