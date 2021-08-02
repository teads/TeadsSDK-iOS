//
//  NativeDirectCollectionViewController.swift
//  TeadsSampleApp
//
//  Created by Paul Nicolas on 26/07/2021.
//  Copyright © 2021 Teads. All rights reserved.
//

import UIKit
import TeadsSDK

class NativeDirectCollectionViewController: TeadsViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let contentCell = "TeadsContentCell"
    let teadsAdCellIndentifier = "NativeAdCollectionViewCell"
    let fakeArticleCell = "fakeArticleCell"
    let adItemNumber = 3
    var placement: TeadsNativeAdPlacement?
    
    private var elements = [TeadsNativeAd?]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        (0..<8).forEach { _ in
            elements.append(nil)
        }
        
        let placementSettings = TeadsAdPlacementSettings { (settings) in
            settings.enableDebug()
        }
        placement = Teads.createNativePlacement(pid: Int(pid) ?? 0, settings: placementSettings, delegate: self)
        
        placement?.requestAd(requestSettings: TeadsAdRequestSettings(build: { (settings) in
            settings.pageUrl("https://www.teads.tv")
        }))
    }
}

extension NativeDirectCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
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
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: fakeArticleCell, for: indexPath)
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 250)
    }
    
    func closeSlot(ad: TeadsAd) {
        elements.removeAll { $0 == ad }
        collectionView.reloadData()
    }
}

extension NativeDirectCollectionViewController: TeadsAdDelegate {
    
    func didRecordImpression(ad: TeadsAd) {
        
    }
    
    func didRecordClick(ad: TeadsAd) {
        
    }
    
    func willPresentModalView(ad: TeadsAd) -> UIViewController? {
        return self
    }
    
    func didCatchError(ad: TeadsAd, error: Error) {
        closeSlot(ad: ad)
    }
    
    func didCloseAd(ad: TeadsAd) {
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
    }
    
    func adOpportunityTrackerView(trackerView: TeadsAdOpportunityTrackerView) {
        // TODO
    }
    
}
