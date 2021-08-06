//
//  InReadDirectCollectionViewController.swift
//  TeadsSampleApp
//
//  Created by Thibaud Saint-Etienne on 12/10/2020.
//  Copyright © 2020 Teads. All rights reserved.
//

import UIKit
import TeadsSDK

class InReadDirectCollectionViewController: TeadsViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let contentCell = "TeadsContentCell"
    let teadsAdCellIndentifier = "TeadsAdCell"
    let fakeArticleCell = "fakeArticleCell"
    let adItemNumber = 2
    var placement: TeadsInReadAdPlacement?
    
    private var elements = [TeadsInReadAd?]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        (0..<8).forEach { _ in
            elements.append(nil)
        }
        
        let placementSettings = TeadsAdPlacementSettings { (settings) in
            settings.enableDebug()
        }
        placement = Teads.createInReadPlacement(pid: Int(pid) ?? 0, settings: placementSettings, delegate: self)
        
        placement?.requestAd(requestSettings: TeadsAdRequestSettings { settings in
            settings.pageUrl("https://www.teads.tv")
        })
    }
    
    @objc func rotationDetected() {
        var indexPaths = [IndexPath]()
        for index in 0..<elements.count {
            indexPaths.append(IndexPath(row: index, section: 0))
        }
        collectionView.reloadItems(at: indexPaths)
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    func closeSlot(ad: TeadsAd) {
        elements.removeAll { $0 == ad }
        collectionView.reloadData()
    }
    
    func updateAdSize(ad: TeadsInReadAd) {
        if let row = elements.firstIndex(of: ad) {
            collectionView.reloadItems(at: [IndexPath(row: row, section: 0)])
            collectionView.collectionViewLayout.invalidateLayout()
        }
    }
    
}

extension InReadDirectCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return elements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            return collectionView.dequeueReusableCell(withReuseIdentifier: contentCell, for: indexPath)
        } else if let ad = elements[indexPath.row] {
            let cellAd = collectionView.dequeueReusableCell(withReuseIdentifier: teadsAdCellIndentifier, for: indexPath)
            let teadsAdView = TeadsInReadAdView(bind: ad)
            cellAd.contentView.addSubview(teadsAdView)
            teadsAdView.setupConstraintsToFitSuperView(horizontalMargin: 10)
            return cellAd
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: fakeArticleCell, for: indexPath)
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == 0 {
            let cell = collectionView.cellForItem(at: indexPath)
            guard let bounds = cell?.bounds else {
                return CGSize.zero
            }
            return CGSize(width: collectionView.bounds.width, height: bounds.height)
        } else if let ad = elements[indexPath.row] {
            let width = collectionView.frame.width - 20
            let height = ad.adRatio.calculateHeight(for: width)
            return .init(width: width, height: height)
        } else {
            return CGSize(width: collectionView.bounds.width, height: 300)
        }
    }
}

extension InReadDirectCollectionViewController: TeadsAdDelegate {
    
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

extension InReadDirectCollectionViewController: TeadsInReadAdPlacementDelegate {
    
    func didReceiveAd(ad: TeadsInReadAd, adRatio: TeadsAdRatio) {
        elements.insert(ad, at: adItemNumber)
        let indexPaths = [IndexPath(row: adItemNumber, section: 0)]
        collectionView.insertItems(at: indexPaths)
        collectionView.collectionViewLayout.invalidateLayout()
        ad.delegate = self
    }
    
    func didFailToReceiveAd(reason: AdFailReason) {
        print("didFailToReceiveAd: \(reason.description)")
    }
    
    func didUpdateRatio(ad: TeadsInReadAd, adRatio: TeadsAdRatio) {
        updateAdSize(ad: ad)
    }
    
    func adOpportunityTrackerView(trackerView: TeadsAdOpportunityTrackerView) {
        //not relevant in tableView integration
    }
}
