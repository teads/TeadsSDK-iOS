//
//  InReadDirectCollectionViewController.swift
//  TeadsDemoApp
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
    var adRatio: CGFloat?
    var teadsAdIsLoaded = false
    var teadsAdView: TFAInReadAdView?
    var collectionViewAdCellWidth: CGFloat!
    var fakeArticleCellHeight: CGFloat = 300
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        teadsAdView = TFAInReadAdView(withPid: UserDefaults.standard.integer(forKey: "PID"), andDelegate: self)
        teadsAdView?.load()
        
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
    
    func resizeTeadsAd(adRatio: CGFloat) {
        if adRatio > 0 {
            adHeight = collectionViewAdCellWidth/adRatio
        }
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

extension InReadDirectCollectionViewController: TFAAdDelegate {
    
    func didReceiveAd(_ ad: TFAAdView, adRatio: CGFloat) {
        self.adRatio = adRatio
        resizeTeadsAd(adRatio: adRatio)
    }
    
    func didFailToReceiveAd(_ ad: TFAAdView, adFailReason: AdFailReason) {
        closeSlot()
    }
    
    func adClose(_ ad: TFAAdView, userAction: Bool) {
        closeSlot()
        //be careful if you want to load another ad in the same page don't remove the observer
        NotificationCenter.default.removeObserver(self)
    }
    
    public func didUpdateRatio(_ ad: TFAAdView, ratio: CGFloat) {
        adRatio = ratio
        //update slot with the right ratio
        resizeTeadsAd(adRatio: ratio)
    }
    
    public func adError(_ ad: TFAAdView, errorMessage: String) {
        //be careful if you want to load another ad in the same page don't remove the observer
        NotificationCenter.default.removeObserver(self)
    }
    
    public func adBrowserWillOpen(_ ad: TFAAdView) -> UIViewController? {
        return self
    }
    
}
