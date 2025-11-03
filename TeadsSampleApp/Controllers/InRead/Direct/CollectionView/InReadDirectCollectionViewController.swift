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
        case adView(_ adView: UIView)
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

    var placement: TeadsAdPlacementMedia?

    private var elements = [TeadsElement]()

    override func viewDidLoad() {
        super.viewDidLoad()

        for _ in 0 ..< 8 {
            elements.append(.article)
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
                elements.insert(.adView(adView), at: adItemNumber)
                collectionView.insertItems(at: [IndexPath(item: adItemNumber, section: 0)])
            }
        } catch {
            print("Failed to load ad: \(error)")
        }

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

    func closeSlot(adView: UIView) {
        elements.removeAll {
            if case let .adView(view) = $0 {
                return view == adView
            }
            return false
        }
        collectionView.reloadData()
    }

    func updateAdSize(adView: UIView) {
        if let row = elements.firstIndex(where: {
            if case let .adView(view) = $0 {
                return view == adView
            }
            return false
        }) {
            collectionView.reloadItems(at: [IndexPath(item: row, section: 0)])
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
        } else if case let .adView(adView) = elements[indexPath.row] {
            let cellAd = collectionView.dequeueReusableCell(withReuseIdentifier: teadsAdCellIndentifier, for: indexPath)
            cellAd.contentView.addSubview(adView)
            adView.translatesAutoresizingMaskIntoConstraints = false
            adView.topAnchor.constraint(equalTo: cellAd.contentView.topAnchor).isActive = true
            adView.leadingAnchor.constraint(equalTo: cellAd.contentView.leadingAnchor, constant: 10).isActive = true
            adView.trailingAnchor.constraint(equalTo: cellAd.contentView.trailingAnchor, constant: -10).isActive = true
            adView.bottomAnchor.constraint(equalTo: cellAd.contentView.bottomAnchor).isActive = true
            return cellAd
        } else if case let .trackerView(trackerView) = elements[indexPath.row],
                  let cellAd = collectionView.dequeueReusableCell(withReuseIdentifier: AdOpportunityTrackerCollectionViewCell.identifier, for: indexPath) as? AdOpportunityTrackerCollectionViewCell {
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
        } else if case .adView = elements[indexPath.row] {
            // Height is managed by the placement through events
            let width = collectionView.frame.width - 20
            return .init(width: width, height: 300) // Default height, will be updated via heightUpdated event
        } else if case .trackerView = elements[indexPath.row] {
            return .init(width: 1, height: 0)
        } else {
            return CGSize(width: collectionView.bounds.width, height: 300)
        }
    }
}

extension InReadDirectCollectionViewController: TeadsAdPlacementEventsDelegate {
    func adPlacement(
        _: TeadsAdPlacementIdentifiable?,
        didEmitEvent event: TeadsAdPlacementEventName,
        data: [String: Any]?
    ) {
        switch event {
            case .ready:
                // Ad is ready, view should already be added
                break
            case .heightUpdated:
                if let height = data?["height"] as? CGFloat {
                    // Find and update the ad item height
                    for (index, element) in elements.enumerated() {
                        if case .adView = element {
                            collectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
                            collectionView.collectionViewLayout.invalidateLayout()
                            break
                        }
                    }
                }
            case .failed:
                print("didFailToReceiveAd: \(String(describing: data?["error"]))")
            case .complete:
                if let adView = data?["adView"] as? UIView {
                    closeSlot(adView: adView)
                }
            default:
                break
        }
    }
}
