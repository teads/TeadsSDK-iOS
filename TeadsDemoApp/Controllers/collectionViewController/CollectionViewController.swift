//
//  CollectionViewController.swift
//  TeadsApp
//
//  Created by Jérémy Grosjean on 29/05/2017.
//  Copyright © 2018 Teads. All rights reserved.
//

import UIKit
import TeadsSDK

private let reuseIdentifier = "teadsTestCell"
private let reuseIdentifierAd = "teadsAdCell"

class CollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, TFAAdDelegate {

    private var adIndexPath: IndexPath!
    var teadsAdView: TFAInReadAdView?
    private var adRatio: CGFloat?
    private var shouldCloseAd = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.adIndexPath = IndexPath(row: 21, section: 0)

        self.teadsAdView = TFAInReadAdView(withPid: UserDefaults.standard.integer(forKey: "PID"), andDelegate: self)
        self.teadsAdView?.load()
        self.teadsAdView?.translatesAutoresizingMaskIntoConstraints = false
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: UICollectionViewCell
        if indexPath == self.adIndexPath {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifierAd, for: indexPath)
            if let cellAd = cell as? TeadsAdCollectionViewCell {
                if self.teadsAdView != nil {
                    cellAd.teadsAdContainerView.addSubview(self.teadsAdView!)
                    var allConstraints = [NSLayoutConstraint]()
                    let viewsDictionary: [String: UIView] = ["adView": self.teadsAdView!]
                    let adHorizontalConstraints = NSLayoutConstraint.constraints(
                        withVisualFormat: "H:|[adView]|",
                        options: [],
                        metrics: nil,
                        views: viewsDictionary)
                    allConstraints += adHorizontalConstraints
                    let adVerticalConstraints = NSLayoutConstraint.constraints(
                        withVisualFormat: "V:|[adView]|",
                        options: [],
                        metrics: nil,
                        views: viewsDictionary)
                    allConstraints += adVerticalConstraints
                    NSLayoutConstraint.activate(allConstraints)
                }
            }
        } else {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
            if let cellTest = cell as? TestCollectionViewCell {
                cellTest.cellLabel.text = "index \(indexPath.row)"
            }
        }
        
        // Configure the cell
        
        return cell
    }

    // MARK: UICollectionViewDelegate

    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath == self.adIndexPath {
            if self.adRatio == nil {
                return CGSize(width: UIScreen.main.bounds.width, height: 0)
            } else {
                return CGSize(width: self.shouldCloseAd ? 0 : UIScreen.main.bounds.width, height: self.shouldCloseAd ? 0 : UIScreen.main.bounds.width/self.adRatio!)
            }
        } else {
            return CGSize(width: UIScreen.main.bounds.width/3-10, height: 100)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    // MARK: TFAAdView Delegate
    
    func didReceiveAd(_ ad: TFAAdView, adRatio: CGFloat) {
        self.adRatio = CGFloat(adRatio)
        self.collectionView?.performBatchUpdates({
            self.collectionView?.collectionViewLayout.invalidateLayout()
        }, completion: nil)
    }
    
    public func didUpdateRatio(_ ad: TFAAdView, ratio: CGFloat) {
        adRatio = ratio
        self.collectionView?.performBatchUpdates({
            self.collectionView?.collectionViewLayout.invalidateLayout()
        }, completion: nil)
    }
    
    func didFailToReceiveAd(_ ad: TFAAdView, adFailReason: AdFailReason) {
        self.shouldCloseAd = true
        self.collectionView?.performBatchUpdates({
            self.collectionView?.collectionViewLayout.invalidateLayout()
        }, completion: nil)
    }
    
    func adClose(_ ad: TFAAdView, userAction: Bool) {
        self.shouldCloseAd = true
        self.collectionView?.performBatchUpdates({
            self.collectionView?.collectionViewLayout.invalidateLayout()
        }, completion: nil)
    }

    
    public func adError(_ ad: TFAAdView, errorMessage: String) {
    }
    
    func adBrowserWillOpen(_ ad: TFAAdView) -> UIViewController? {
        return self
    }
}
