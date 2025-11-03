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
    var placement: TeadsAdPlacementMedia?

    private var elements: [Any?] = [] // Changed to Any? to accommodate different ad types

    override func viewDidLoad() {
        super.viewDidLoad()

        for _ in 0 ..< 8 {
            elements.append(nil)
        }

        let placementSettings = TeadsAdPlacementSettings { settings in
            settings.enableDebug()
        }

        // Create placement with unified API
        let config = TeadsAdPlacementMediaConfig(
            pid: Int(pid) ?? 0,
            articleUrl: URL(string: "https://www.teads.com")
        )
        placement = TeadsAdPlacementMedia(config, delegate: self)

        // Load ad with unified API
        do {
            if let adView = try placement?.loadAd() {
                // For native ads, we may need to extract the native ad object differently
            }
        } catch {
            print("Failed to load ad: \(error)")
        }
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
        } else if let nativeAd = elements[indexPath.item] as? TeadsNativeAd {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: teadsAdCellIndentifier, for: indexPath) as? NativeAdCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.adView.bind(nativeAd)
            return cell
        } else if let adView = elements[indexPath.item] as? UIView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: teadsAdCellIndentifier, for: indexPath)
            cell.contentView.addSubview(adView)
            adView.translatesAutoresizingMaskIntoConstraints = false
            adView.topAnchor.constraint(equalTo: cell.contentView.topAnchor).isActive = true
            adView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor).isActive = true
            adView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor).isActive = true
            adView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor).isActive = true
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

    func closeSlot(ad: Any) {
        elements.removeAll {
            if let element = $0, let elementAsEquatable = element as? AnyHashable, let adAsEquatable = ad as? AnyHashable {
                return elementAsEquatable == adAsEquatable
            }
            return false
        }
        collectionView.reloadData()
    }
}

extension NativeDirectCollectionViewController: TeadsAdPlacementEventsDelegate {
    func adPlacement(
        _: TeadsAdPlacementIdentifiable?,
        didEmitEvent event: TeadsAdPlacementEventName,
        data: [String: Any]?
    ) {
        switch event {
            case .ready:
                // For native ads, the ad object may be in the data dictionary
                if let nativeAd = data?["nativeAd"] as? TeadsNativeAd {
                    elements.insert(nativeAd, at: adItemNumber)
                    let indexPaths = [IndexPath(item: adItemNumber, section: 0)]
                    collectionView.insertItems(at: indexPaths)
                    collectionView.reloadData()
                } else if let adView = data?["adView"] as? UIView {
                    elements.insert(adView, at: adItemNumber)
                    let indexPaths = [IndexPath(item: adItemNumber, section: 0)]
                    collectionView.insertItems(at: indexPaths)
                }
            case .failed:
                print("didFailToReceiveAd: \(String(describing: data?["error"]))")
            default:
                break
        }
    }
}
