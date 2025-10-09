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
        case ad(id: String)

        static func ==(lhs: TeadsElement, rhs: TeadsElement) -> Bool {
            switch (lhs, rhs) {
                case (.article, .article):
                    return true
                case let (.ad(id1), .ad(id2)):
                    return id1 == id2
                default:
                    return false
            }
        }
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

    // Store placement and ad view
    var adId: String?
    var adView: UIView?
    var adHeight: CGFloat = 0

    private var elements = [TeadsElement]()

    override var pid: String {
        didSet {
            guard oldValue != pid, isViewLoaded else { return }
            setupPlacement()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        for _ in 0 ..< 8 {
            elements.append(.article)
        }

        setupPlacement()
    }

    private func setupPlacement() {
        // Clean up existing placement and views
        placement = nil
        adView = nil
        adHeight = 0
        if let id = adId {
            elements.removeAll { $0 == .ad(id: id) }
        }

        // Create placement with new API
        let config = TeadsAdPlacementMediaConfig(
            pid: Int(pid) ?? 0,
            articleUrl: URL(string: "https://www.teads.com"),
            enableValidationMode: validationModeEnabled
        )

        placement = Teads.createPlacement(with: config, delegate: self)

        if let id = placement?.placementId {
            adId = id
            elements.insert(.ad(id: id), at: 3)
        }

        // Load ad and store view
        if let view = try? placement?.loadAd() {
            adView = view
            // Ad will be inserted when ready event is received
        }

        collectionView.reloadData()
    }

    @objc func rotationDetected() {
        var indexPaths = [IndexPath]()
        for index in 0 ..< elements.count {
            indexPaths.append(IndexPath(row: index, section: 0))
        }
        collectionView.reloadItems(at: indexPaths)
        collectionView.collectionViewLayout.invalidateLayout()
    }

    func closeSlot(id: String) {
        elements.removeAll { $0 == .ad(id: id) }
        adView = nil
        adHeight = 0
        collectionView.reloadData()
    }

    func updateAdSize(id: String) {
        if let row = elements.firstIndex(of: .ad(id: id)) {
            collectionView.reloadItems(at: [IndexPath(row: row, section: 0)])
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
        } else if case .ad = elements[indexPath.row],
                  let view = adView {
            let cellAd = collectionView.dequeueReusableCell(withReuseIdentifier: teadsAdCellIndentifier, for: indexPath)
            // Remove from previous parent if any
            view.removeFromSuperview()
            cellAd.contentView.addSubview(view)
            view.setupConstraintsToFitSuperView(horizontalMargin: 10)
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
        } else if case .ad = elements[indexPath.row] {
            let width = collectionView.frame.width - 20
            return .init(width: width, height: adHeight)
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
        guard let id = adId else {
            return
        }

        switch event {
            case .ready:
                print("Ad ready")
                // Insert ad into collection
                elements.insert(.ad(id: id), at: adItemNumber)
                let indexPaths = [IndexPath(row: adItemNumber, section: 0)]
                collectionView.insertItems(at: indexPaths)
                collectionView.collectionViewLayout.invalidateLayout()

            case .rendered:
                print("Ad rendered")

            case .heightUpdated:
                if let height = data?["height"] as? CGFloat {
                    adHeight = height
                    updateAdSize(id: id)
                }

            case .viewed:
                print("Ad viewed (impression)")

            case .clicked:
                print("Ad clicked")

            case .failed:
                print("Ad failed: \(data?["reason"] ?? "Unknown")")
                closeSlot(id: id)

            case .complete:
                print("Video complete")
                closeSlot(id: id)

            default:
                break
        }
    }
}
