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
    var adPosition: [(UUID, Int)] = []
    static let incrementPosition = 3
    var adRequestedIndices = Set<Int>()

    var placement: TeadsAdPlacementMedia?

    enum TeadsElement: Equatable {
        case article
        case adView(_ adView: UIView)
        case trackerView(_ trackerView: TeadsAdOpportunityTrackerView)
    }

    private var elements = [TeadsElement]()

    func trackerViewRowNumber(requestIdentifier: UUID?) -> Int {
        guard let requestIdentifier else {
            return InReadDirectTableViewController.incrementPosition
        }
        guard let position = adPosition.first(where: { uuid, _ in
            uuid == requestIdentifier
        }) else {
            let newPosition = (adPosition.last?.1 ?? 0) + InReadDirectTableViewController.incrementPosition
            adPosition.append((requestIdentifier, newPosition))
            return newPosition
        }
        return position.1
    }

    func adRowNumber(requestIdentifier: UUID?) -> Int {
        return trackerViewRowNumber(requestIdentifier: requestIdentifier) + 1
    }

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
        tableView.register(AdOpportunityTrackerTableViewCell.self, forCellReuseIdentifier: AdOpportunityTrackerTableViewCell.identifier)
    }

    func closeSlot(adView: UIView) {
        elements.removeAll {
            if case let .adView(view) = $0 {
                return view == adView
            }
            return false
        }
        tableView.reloadData()
    }
}

extension InReadDirectTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return elements.count
    }

    func tableView(_: UITableView, willDisplay _: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row % InReadDirectTableViewController.incrementPosition == 0, elements[indexPath.row] == .article, !adRequestedIndices.contains(indexPath.row) {
            adRequestedIndices.insert(indexPath.row)
            do {
                if let adView = try placement?.loadAd() {
                    let adRowIndex = adRowNumber(requestIdentifier: nil)
                    elements.insert(.adView(adView), at: adRowIndex)
                    let indexPaths = [IndexPath(row: adRowIndex, section: 0)]
                    tableView.insertRows(at: indexPaths, with: .automatic)
                }
            } catch {
                print("Failed to load ad: \(error)")
            }
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            return tableView.dequeueReusableCell(withIdentifier: contentCell, for: indexPath)
        } else if case let .adView(adView) = elements[indexPath.row] {
            let cellAd = tableView.dequeueReusableCell(withIdentifier: teadsAdCellIndentifier, for: indexPath)
            cellAd.contentView.addSubview(adView)
            adView.translatesAutoresizingMaskIntoConstraints = false
            adView.topAnchor.constraint(equalTo: cellAd.contentView.topAnchor).isActive = true
            adView.leadingAnchor.constraint(equalTo: cellAd.contentView.leadingAnchor, constant: 10).isActive = true
            adView.trailingAnchor.constraint(equalTo: cellAd.contentView.trailingAnchor, constant: -10).isActive = true
            adView.bottomAnchor.constraint(equalTo: cellAd.contentView.bottomAnchor).isActive = true
            return cellAd
        } else if case let .trackerView(trackerView) = elements[indexPath.row],
                  let cellAd = tableView.dequeueReusableCell(withIdentifier: AdOpportunityTrackerTableViewCell.identifier, for: indexPath) as? AdOpportunityTrackerTableViewCell {
            cellAd.setTrackerView(trackerView)
            return cellAd
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: fakeArticleCell, for: indexPath)
            return cell
        }
    }

    func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if case .adView = elements[indexPath.row] {
            // Height is managed by the placement through events
            return 300 // Default height, will be updated via heightUpdated event
        } else if case .trackerView = elements[indexPath.row] {
            return 0
        }
        return UITableView.automaticDimension
    }
}

extension InReadDirectTableViewController: TeadsAdPlacementEventsDelegate {
    func adPlacement(
        _: TeadsAdPlacementIdentifiable?,
        didEmitEvent event: TeadsAdPlacementEventName,
        data: [String: Any]?
    ) {
        switch event {
            case .ready:
                // Ad is ready, view should already be added in willDisplay
                break
            case .heightUpdated:
                if let height = data?["height"] as? CGFloat {
                    // Find and update the ad row height
                    for (index, element) in elements.enumerated() {
                        if case .adView = element {
                            tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
                            break
                        }
                    }
                }
            case .failed:
                print("didFailToReceiveAd: \(String(describing: data?["error"]))")
            default:
                break
        }
    }
}

// TeadsAdDelegate is handled through unified events system

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
