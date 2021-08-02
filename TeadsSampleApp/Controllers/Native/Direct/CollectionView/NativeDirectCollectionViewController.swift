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
    var adHeight: CGFloat?
    var adRatio: TeadsAdRatio?
    var teadsAdIsLoaded = false
    var placement: TeadsNativeAdPlacement?
    var tableViewAdCellWidth: CGFloat!
    var collectionViewCellHeight: CGFloat = 250
    
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
        
        // We use an observer to know when a rotation happened, to resize the ad
        // You can use whatever way you want to do so
        NotificationCenter.default.addObserver(self, selector: #selector(rotationDetected), name: UIDevice.orientationDidChangeNotification, object: nil)
                        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func rotationDetected() {
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    func closeSlot() {
        adHeight = 0
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
        closeSlot()
    }
    
    func didCloseAd(ad: TeadsAd) {
        closeSlot()
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
        closeSlot()
    }
    
    func adOpportunityTrackerView(trackerView: TeadsAdOpportunityTrackerView) {
        // TODO
    }
    
}
