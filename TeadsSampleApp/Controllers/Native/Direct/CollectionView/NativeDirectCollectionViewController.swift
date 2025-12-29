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
    var placement: TeadsAdPlacementMediaNative?
    var adView: TeadsNativeAdView?

    private var elements = [Bool]() // true = ad loaded, false = article

    override var pid: String {
        didSet {
            guard oldValue != pid, isViewLoaded else { return }
            setupPlacement()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        for _ in 0 ..< 8 {
            elements.append(false)
        }

        setupPlacement()
    }

    private func setupPlacement() {
        // Clean up existing placement and views
        placement = nil
        adView = nil
        if adItemNumber < elements.count {
            elements[adItemNumber] = false
        }

        // Create placement with new API
        let config = TeadsAdPlacementMediaConfig(
            pid: Int(pid) ?? 0,
            articleUrl: URL(string: "https://www.teads.com"),
            enableValidationMode: validationModeEnabled
        )

        placement = Teads.createPlacement(with: config, delegate: self)

        // Create native ad view
        let nativeAdView = TeadsNativeAdView()
        adView = nativeAdView

        // Load ad and register the view
        if let bindClosure = try? placement?.loadAd() {
            bindClosure(nativeAdView)
        }

        collectionView.reloadData()
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
        } else if elements[indexPath.item], let nativeAdView = adView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: teadsAdCellIndentifier, for: indexPath) as? NativeAdCollectionViewCell else {
                return UICollectionViewCell()
            }
            // The ad is already bound via loadAd() closure
            // Just add the view to the cell if not already added
            if cell.adView != nativeAdView {
                cell.adView = nativeAdView
            }
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

    func closeSlot() {
        if adItemNumber < elements.count {
            elements[adItemNumber] = false
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
                print("Native ad ready")
                elements.insert(true, at: adItemNumber)
                let indexPaths = [IndexPath(item: adItemNumber, section: 0)]
                collectionView.insertItems(at: indexPaths)
                collectionView.reloadData()

            case .viewed:
                print("Native ad viewed (impression)")

            case .clicked:
                print("Native ad clicked")

            case .failed:
                print("Native ad failed: \(data?["error"] ?? "Unknown")")
                closeSlot()

            default:
                break
        }
    }
}
