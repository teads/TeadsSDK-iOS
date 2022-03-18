//
//  InReadDirectCollectionViewController.swift
//  TeadsSampleApp
//
//  Created by Thibaud Saint-Etienne on 12/10/2020.
//  Copyright © 2020 Teads. All rights reserved.
//

import TeadsSDK
import UIKit

class InReadDirectCollectionViewController: TeadsViewController {
    enum TeadsElement: Equatable {
        case article
        case ad(_ ad: TeadsInReadAd)
        case trackerView(_ trackerView: TeadsAdOpportunityTrackerView)
    }

    @IBOutlet var collectionView: UICollectionView!

    let contentCell = "TeadsContentCell"
    let teadsAdCellIndentifier = "TeadsAdCell"
    let fakeArticleCell = "fakeArticleCell"
    let trackerViewItemNumber = 2 // tracker view needs to be placed above the slot view
    var adItemNumber: Int {
        return trackerViewItemNumber + 1
    }

    var placement: TeadsInReadAdPlacement?

    private var elements = [TeadsElement]()

    override func viewDidLoad() {
        super.viewDidLoad()

        (0 ..< 8).forEach { _ in
            elements.append(.article)
        }

        let placementSettings = TeadsAdPlacementSettings { settings in
            settings.enableDebug()
        }
        placement = Teads.createInReadPlacement(pid: Int(pid) ?? 0, settings: placementSettings, delegate: self)

        placement?.requestAd(requestSettings: TeadsAdRequestSettings { settings in
            settings.pageUrl("https://www.teads.tv")
        })

        collectionView.register(AdOpportunityTrackerCollectionViewCell.self, forCellWithReuseIdentifier: AdOpportunityTrackerCollectionViewCell.identifier)
    }

    @objc func rotationDetected() {
        var indexPaths = [IndexPath]()
        for index in 0 ..< elements.count {
            indexPaths.append(IndexPath(row: index, section: 0))
        }
        collectionView.reloadItems(at: indexPaths)
        collectionView.collectionViewLayout.invalidateLayout()
    }

    func closeSlot(ad: TeadsAd) {
        guard let inReadAd = ad as? TeadsInReadAd else {
            return
        }
        elements.removeAll { $0 == .ad(inReadAd) }
        collectionView.reloadData()
    }

    func updateAdSize(ad: TeadsInReadAd) {
        if let row = elements.firstIndex(of: .ad(ad)) {
            collectionView.reloadItems(at: [IndexPath(row: row, section: 0)])
            collectionView.collectionViewLayout.invalidateLayout()
        }
    }
}

extension InReadDirectCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return elements.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            return collectionView.dequeueReusableCell(withReuseIdentifier: contentCell, for: indexPath)
        } else if case let .ad(ad) = elements[indexPath.row] {
            let cellAd = collectionView.dequeueReusableCell(withReuseIdentifier: teadsAdCellIndentifier, for: indexPath)
            let teadsAdView = TeadsInReadAdView(bind: ad)
            cellAd.contentView.addSubview(teadsAdView)
            teadsAdView.setupConstraintsToFitSuperView(horizontalMargin: 10)
            return cellAd
        } else if case let .trackerView(trackerView) = elements[indexPath.row],
                  let cellAd = collectionView.dequeueReusableCell(withReuseIdentifier: AdOpportunityTrackerCollectionViewCell.identifier, for: indexPath) as? AdOpportunityTrackerCollectionViewCell
        {
            cellAd.setTrackerView(trackerView)
            return cellAd
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: fakeArticleCell, for: indexPath)
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == 0 {
            let cell = collectionView.cellForItem(at: indexPath)
            guard let bounds = cell?.bounds else {
                return CGSize.zero
            }
            return CGSize(width: collectionView.bounds.width, height: bounds.height)
        } else if case let .ad(ad) = elements[indexPath.row] {
            let width = collectionView.frame.width - 20
            let height = ad.adRatio.calculateHeight(for: width)
            return .init(width: width, height: height)
        } else if case .trackerView = elements[indexPath.row] {
            return .init(width: 1, height: 0)
        } else {
            return CGSize(width: collectionView.bounds.width, height: 300)
        }
    }
}

extension InReadDirectCollectionViewController: TeadsAdDelegate {
    func didRecordImpression(ad _: TeadsAd) {}

    func didRecordClick(ad _: TeadsAd) {}

    func willPresentModalView(ad _: TeadsAd) -> UIViewController? {
        return self
    }

    func didCatchError(ad: TeadsAd, error _: Error) {
        closeSlot(ad: ad)
    }

    func didClose(ad: TeadsAd) {
        closeSlot(ad: ad)
    }
}

extension InReadDirectCollectionViewController: TeadsInReadAdPlacementDelegate {
    func didReceiveAd(ad: TeadsInReadAd, adRatio _: TeadsAdRatio) {
        elements.insert(.ad(ad), at: adItemNumber)
        let indexPaths = [IndexPath(row: adItemNumber, section: 0)]
        collectionView.insertItems(at: indexPaths)
        collectionView.collectionViewLayout.invalidateLayout()
        ad.delegate = self
    }

    func didFailToReceiveAd(reason: AdFailReason) {
        print("didFailToReceiveAd: \(reason.description)")
    }

    func didUpdateRatio(ad: TeadsInReadAd, adRatio _: TeadsAdRatio) {
        updateAdSize(ad: ad)
    }

    func adOpportunityTrackerView(trackerView: TeadsAdOpportunityTrackerView) {
        elements.insert(.trackerView(trackerView), at: trackerViewItemNumber)
        let indexPaths = [IndexPath(row: trackerViewItemNumber, section: 0)]
        collectionView.insertItems(at: indexPaths)
        collectionView.collectionViewLayout.invalidateLayout()
    }
}
