//
//  NativeDirectCollectionViewController.swift
//  TeadsSampleApp
//
//  Created by Paul Nicolas on 26/07/2021.
//  Copyright © 2021 Teads. All rights reserved.
//

import TeadsSDK
import UIKit

class NativeDirectCollectionViewController: TeadsViewController {
    @IBOutlet var collectionView: UICollectionView!

    let contentCell = "TeadsContentCell"
    let teadsAdCellIndentifier = "NativeAdCollectionViewCell"
    let fakeArticleCell = "fakeArticleCell"
    let adItemNumber = 3
    var placement: TeadsNativeAdPlacement?

    private var elements = [TeadsNativeAd?]()

    override func viewDidLoad() {
        super.viewDidLoad()

        for _ in 0 ..< 8 {
            elements.append(nil)
        }

        let placementSettings = TeadsAdPlacementSettings { settings in
            settings.enableDebug()
        }

        // keep a strong reference to placement instance
        placement = Teads.createNativePlacement(pid: Int(pid) ?? 0, settings: placementSettings, delegate: self)

        placement?.requestAd(requestSettings: TeadsAdRequestSettings { settings in
            settings.pageUrl("https://www.teads.com")
        })
    }
}

extension NativeDirectCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return elements.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: contentCell, for: indexPath)
            cell.contentView.translatesAutoresizingMaskIntoConstraints = false
            cell.contentView.widthAnchor.constraint(equalToConstant: collectionView.bounds.width).isActive = true
            return cell
        } else if let ad = elements[indexPath.item] {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: teadsAdCellIndentifier, for: indexPath) as? NativeAdCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.adView.bind(ad)
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: fakeArticleCell, for: indexPath) as? FakeArticleNativeCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.setMockValues()
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 250)
    }

    func closeSlot(ad: TeadsAd) {
        elements.removeAll { $0 == ad }
        collectionView.reloadData()
    }
}

extension NativeDirectCollectionViewController: TeadsAdDelegate {
    func didRecordImpression(ad _: TeadsAd) {
        // you may want to use this callback for your own analytics
    }

    func didRecordClick(ad _: TeadsAd) {
        // you may want to use this callback for your own analytics
    }

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

extension NativeDirectCollectionViewController: TeadsNativeAdPlacementDelegate {
    func didReceiveAd(ad: TeadsNativeAd) {
        elements.insert(ad, at: adItemNumber)
        let indexPaths = [IndexPath(item: adItemNumber, section: 0)]
        collectionView.insertItems(at: indexPaths)
        collectionView.reloadData()
        ad.delegate = self
    }

    func didFailToReceiveAd(reason: AdFailReason) {
        print("didFailToReceiveAd: \(reason.description)")
    }

    func adOpportunityTrackerView(trackerView _: TeadsAdOpportunityTrackerView) {
        // not relevant in collectionView integration
    }
}
