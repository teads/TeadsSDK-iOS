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
    static let articleCount = 8

    var requestedAdIds = Set<UUID>()

    // Store placements and their corresponding ad views
    var placements: [UUID: TeadsAdPlacementMedia] = [:]
    var adViews: [UUID: UIView] = [:]

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

    override func viewDidLoad() {
        super.viewDidLoad()
        buildElements()
    }

    /// Seeds the feed with a fixed layout: articles interleaved with ad placeholder slots.
    /// The row count never changes afterwards, so ads only fill their existing slot.
    private func buildElements() {
        elements = []
        for index in 0 ..< Self.articleCount {
            elements.append(.article)
            if (index + 1) % Self.incrementPosition == 0 {
                elements.append(.ad(id: UUID()))
            }
        }
    }

    private func loadAd(for adId: UUID) {
        let config = TeadsAdPlacementMediaConfig(
            pid: Int(pid) ?? 0,
            articleUrl: URL(string: "https://www.teads.com")
        )

        guard let placement: TeadsAdPlacementMedia = Teads.createPlacement(with: config, delegate: self) else { return }
        placements[adId] = placement

        guard let adView = try? placement.loadAd() else { return }
        adViews[adId] = adView
        // Slot already exists — refresh it (deferred so we never mutate during a display pass).
        DispatchQueue.main.async { [weak self] in self?.reloadAdRow(for: adId) }
    }

    private func reloadAdRow(for adId: UUID) {
        guard let row = elements.firstIndex(of: .ad(id: adId)) else { return }
        tableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .none)
    }

    func closeSlot(adId: UUID) {
        placements.removeValue(forKey: adId)
        adViews.removeValue(forKey: adId)
        reloadAdRow(for: adId)
    }

    private func resetAds() {
        placements.removeAll()
        adViews.removeAll()
        requestedAdIds.removeAll()
        buildElements()
        tableView.reloadData()
    }
}

extension InReadDirectTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return elements.count
    }

    func tableView(_: UITableView, willDisplay _: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard case let .ad(id) = elements[indexPath.row], !requestedAdIds.contains(id) else { return }
        requestedAdIds.insert(id)
        loadAd(for: id)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            return tableView.dequeueReusableCell(withIdentifier: contentCell, for: indexPath)
        } else if case let .ad(id) = elements[indexPath.row] {
            let cellAd = tableView.dequeueReusableCell(withIdentifier: teadsAdCellIndentifier, for: indexPath)
            cellAd.contentView.subviews.forEach { $0.removeFromSuperview() }
            if let adView = adViews[id] {
                adView.removeFromSuperview()
                cellAd.contentView.addSubview(adView)
                adView.setupConstraintsToFitSuperView(horizontalMargin: 10)
            }
            return cellAd
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: fakeArticleCell, for: indexPath)
            return cell
        }
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
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
                reloadAdRow(for: adId)

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
