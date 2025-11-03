//
//  NativeTagDirectTableViewController.swift
//  TeadsSampleApp
//
//  Created by Paul NICOLAS on 14/04/2023.
//  Copyright © 2023 Teads. All rights reserved.
//

import TeadsSDK
import UIKit

class NativeTagDirectTableViewController: TeadsViewController {
    @IBOutlet var tableView: UITableView!

    let headerCell = "TeadsContentCell"
    let teadsAdCellIndentifier = "NativeAdTableViewCell"
    let fakeArticleCell = "FakeArticleNativeTableViewCell"
    let adRowNumber = 3
    var adRatio: TeadsAdRatio?
    var teadsAdIsLoaded = false
    var placement: TeadsAdPlacementMedia?
    var tableViewAdCellWidth: CGFloat!

    private var elements = [TeadsNativeAd?]()

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
                // For native ads with tags, we may need to extract the native ad object differently
            }
        } catch {
            print("Failed to load ad: \(error)")
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableViewAdCellWidth = tableView.frame.width - 20
    }

    func closeSlot(ad: TeadsAd) {
        elements.removeAll { $0 == ad }
        tableView.reloadData()
    }

    func updateAdCellHeight() {
        tableView.reloadRows(at: [IndexPath(row: adRowNumber, section: 0)], with: .automatic)
    }
}

extension NativeTagDirectTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return elements.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: headerCell, for: indexPath)
            return cell
        } else if let ad = elements[indexPath.row] {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: teadsAdCellIndentifier, for: indexPath) as? NativeAdTableViewCell else {
                return UITableViewCell()
            }
            // specify a unique tag non-zero value for each UI element on your interface builder or programmatically
            cell.adView.bind(ad) { builder in
                builder.titleLabelTag = 1
                builder.contentLabelTag = 2
                builder.mediaViewTag = 3
                builder.iconImageViewTag = 4
                builder.callToActionButtonTag = 5
            }
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: fakeArticleCell, for: indexPath) as? FakeArticleNativeTableViewCell else {
                return UITableViewCell()
            }
            cell.setMockValues()
            return cell
        }
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 250
    }
}

extension NativeTagDirectTableViewController: TeadsAdPlacementEventsDelegate {
    func adPlacement(
        _: TeadsAdPlacementIdentifiable?,
        didEmitEvent event: TeadsAdPlacementEventName,
        data: [String: Any]?
    ) {
        switch event {
            case .ready:
                // For native ads, the ad object may be in the data dictionary
                if let nativeAd = data?["nativeAd"] as? TeadsNativeAd {
                    elements.insert(nativeAd, at: adRowNumber)
                    let indexPaths = [IndexPath(row: adRowNumber, section: 0)]
                    tableView.insertRows(at: indexPaths, with: .automatic)
                    tableView.reloadData()
                } else if let adView = data?["adView"] as? UIView {
//                    elements.insert(adView, at: adRowNumber)
//                    let indexPaths = [IndexPath(row: adRowNumber, section: 0)]
//                    tableView.insertRows(at: indexPaths, with: .automatic)
                }
            case .failed:
                print("didFailToReceiveAd: \(String(describing: data?["error"]))")
            default:
                break
        }
    }
}

// TeadsAdDelegate is handled through unified events system
