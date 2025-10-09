//
//  InReadDirectTableViewController.swift
//  TeadsSampleApp
//
//  Created by Jérémy Grosjean on 02/10/2017.
//  Copyright © 2018 Teads. All rights reserved.
//

import TeadsSDK
import UIKit

class InReadDirectTableViewController: TeadsViewController {
    @IBOutlet var tableView: UITableView!

    let contentCell = "TeadsContentCell"
    let teadsAdCellIndentifier = "TeadsAdCell"
    let fakeArticleCell = "fakeArticleCell"
    static let incrementPosition = 3
    var adRequestedIndices = Set<Int>()

    // Store placements and their corresponding ad views
    var placements: [UUID: TeadsAdPlacementMedia] = [:]
    var adViews: [UUID: UIView] = [:]
    var adHeights: [UUID: CGFloat] = [:]

    override var pid: String {
        didSet {
            guard oldValue != pid, isViewLoaded else { return }
            resetAds()
        }
    }

    enum TeadsElement: Equatable {
        case article
        case ad(id: UUID)

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

    private var elements = [TeadsElement]()
    private var currentAdIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        for _ in 0 ..< 8 {
            elements.append(.article)
        }
    }

    func createAndLoadAd(at position: Int) {
        let adId = UUID()
        let config = TeadsAdPlacementMediaConfig(
            pid: Int(pid) ?? 0,
            articleUrl: URL(string: "https://www.teads.com"),
            enableValidationMode: validationModeEnabled
        )

        if let placement: TeadsAdPlacementMedia = Teads.createPlacement(with: config, delegate: self) {
            placements[adId] = placement

            if let adView = try? placement.loadAd() {
                adViews[adId] = adView

                // Insert ad into table
                let adRowIndex = position + 1
                elements.insert(.ad(id: adId), at: adRowIndex)
                let indexPaths = [IndexPath(row: adRowIndex, section: 0)]
                tableView.insertRows(at: indexPaths, with: .automatic)
            }
        }
    }

    func closeSlot(adId: UUID) {
        elements.removeAll { $0 == .ad(id: adId) }
        placements.removeValue(forKey: adId)
        adViews.removeValue(forKey: adId)
        adHeights.removeValue(forKey: adId)
        tableView.reloadData()
    }

    private func resetAds() {
        // Clear all ad state
        placements.removeAll()
        adViews.removeAll()
        adHeights.removeAll()
        adRequestedIndices.removeAll()

        // Reset elements to articles only
        elements = [TeadsElement]()
        for _ in 0 ..< 8 {
            elements.append(.article)
        }

        tableView.reloadData()
    }
}

extension InReadDirectTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return elements.count
    }

    func tableView(_: UITableView, willDisplay _: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row % InReadDirectTableViewController.incrementPosition == 0,
           elements[indexPath.row] == .article,
           !adRequestedIndices.contains(indexPath.row) {
            adRequestedIndices.insert(indexPath.row)
            createAndLoadAd(at: indexPath.row)
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            return tableView.dequeueReusableCell(withIdentifier: contentCell, for: indexPath)
        } else if case let .ad(id) = elements[indexPath.row],
                  let adView = adViews[id] {
            let cellAd = tableView.dequeueReusableCell(withIdentifier: teadsAdCellIndentifier, for: indexPath)
            // Remove from previous parent if any
            adView.removeFromSuperview()
            cellAd.contentView.addSubview(adView)
            adView.setupConstraintsToFitSuperView(horizontalMargin: 10)
            return cellAd
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: fakeArticleCell, for: indexPath)
            return cell
        }
    }

    func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if case let .ad(id) = elements[indexPath.row],
           let height = adHeights[id] {
            return height
        }
        return UITableView.automaticDimension
    }
}

extension InReadDirectTableViewController: TeadsAdPlacementEventsDelegate {
    func adPlacement(
        _ placement: TeadsAdPlacementIdentifiable?,
        didEmitEvent event: TeadsAdPlacementEventName,
        data: [String: Any]?
    ) {
        // Find which ad this event belongs to
        guard let placementId = placement?.placementId,
              let adId = placements.first(where: { $0.value.placementId == placementId })?.key else {
            return
        }

        switch event {
            case .ready:
                print("Ad ready for \(adId)")

            case .rendered:
                print("Ad rendered for \(adId)")

            case .heightUpdated:
                if let height = data?["height"] as? CGFloat {
                    adHeights[adId] = height
                    if let row = elements.firstIndex(of: .ad(id: adId)) {
                        tableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .automatic)
                    }
                }

            case .viewed:
                print("Ad viewed for \(adId)")

            case .clicked:
                print("Ad clicked for \(adId)")

            case .failed:
                print("Ad failed for \(adId): \(data?["reason"] ?? "Unknown")")
                closeSlot(adId: adId)

            case .complete:
                print("Video complete for \(adId)")
                closeSlot(adId: adId)

            default:
                break
        }
    }
}

extension UIView {
    func setupConstraintsToFitSuperView(horizontalMargin: CGFloat = 0) {
        guard let superview = superview else {
            return
        }
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: superview.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: superview.bottomAnchor).isActive = true
        leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: horizontalMargin).isActive = true
        trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -horizontalMargin).isActive = true
    }
}
