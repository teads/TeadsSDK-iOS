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
    var adHeight: CGFloat?
    var adRatio: TeadsAdRatio?
    var teadsAdIsLoaded = false
    var teadsAdView: TeadsInReadAdView?
    var collectionViewAdCellWidth: CGFloat!
    var fakeArticleCellHeight: CGFloat = 300
    var placement: TeadsInReadAdPlacement?

    override func viewDidLoad() {
        super.viewDidLoad()
        let placementSettings = TeadsAdPlacementSettings { (settings) in
            settings.enableDebug()
        }
        placement = Teads.createInReadPlacement(pid: Int(pid) ?? 0, settings: placementSettings, delegate: self)
        
        placement?.requestAd(requestSettings: TeadsAdRequestSettings(build: { (settings) in
            settings.pageUrl("https://www.teads.tv")
        }))
        
        teadsAdView = TeadsInReadAdView()
        
        // We use an observer to know when a rotation happened, to resize the ad
        // You can use whatever way you want to do so
        NotificationCenter.default.addObserver(self, selector: #selector(rotationDetected), name: UIDevice.orientationDidChangeNotification, object: nil)
                        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionViewAdCellWidth = collectionView.frame.width - 20
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func rotationDetected() {
        if adRatio != nil {
            resizeTeadsAd(adRatio: adRatio!)
        }
        
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    func resizeTeadsAd(adRatio: TeadsAdRatio) {
        adHeight = adRatio.calculateHeight(for: collectionViewAdCellWidth)
        updateAdCellHeight()
    }
    
    func closeSlot() {
        adHeight = 0
        updateAdCellHeight()
    }
    
    func updateAdCellHeight() {
        collectionView.reloadItems(at: [IndexPath(row: adItemNumber, section: 0)])
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
}

extension InReadDirectCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.item {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: contentCell, for: indexPath)
            cell.contentView.translatesAutoresizingMaskIntoConstraints = false
            cell.contentView.widthAnchor.constraint(equalToConstant: collectionView.bounds.width).isActive = true
            return cell
        case adItemNumber:
            //need to create a cell and just add a teadsAd to it, so we have only one teads ad
            let cellAd = collectionView.dequeueReusableCell(withReuseIdentifier: teadsAdCellIndentifier, for: indexPath)
            if let teadsAdView = teadsAdView {
                cellAd.addSubview(teadsAdView)
                teadsAdView.frame = CGRect(x: 0, y: 0, width: collectionViewAdCellWidth, height: adHeight ?? 250)
            }
            return cellAd
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: fakeArticleCell, for: indexPath)
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.item {
        case 0:
            let cell = collectionView.cellForItem(at: indexPath)
            guard let bounds = cell?.bounds else {
                return CGSize.zero
            }
            return CGSize(width: collectionView.bounds.width, height: bounds.height)
        case adItemNumber:
            return CGSize(width: collectionViewAdCellWidth, height: adHeight ?? 0)
        default:
            return CGSize(width: collectionView.bounds.width, height: fakeArticleCellHeight)
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
        closeSlot()
    }
    
    func didCloseAd(ad: TeadsAd) {
        closeSlot()
    }
    
}

extension InReadDirectCollectionViewController: TeadsInReadAdPlacementDelegate {
    
    func didReceiveAd(ad: TeadsInReadAd, adRatio: TeadsAdRatio) {
        teadsAdView?.bind(ad)
        ad.delegate = self
        let creativeRatio = adRatio
        self.adRatio = creativeRatio
        resizeTeadsAd(adRatio: creativeRatio)
    }
    
    func didFailToReceiveAd(reason: AdFailReason) {
        closeSlot()
    }
    
    func didUpdateRatio(ad: TeadsInReadAd, adRatio: TeadsAdRatio) {
        updateAdCellHeight()
        self.adRatio = adRatio
    }
    
    func adOpportunityTrackerView(trackerView: TeadsAdOpportunityTrackerView) {
        teadsAdView?.addSubview(trackerView)
    }
    
}
