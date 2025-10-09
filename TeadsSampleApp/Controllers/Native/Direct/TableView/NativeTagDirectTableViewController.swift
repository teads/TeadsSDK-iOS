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
    var teadsAdIsLoaded = false
    var placement: TeadsAdPlacementMediaNative?
    var tableViewAdCellWidth: CGFloat!
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
        teadsAdIsLoaded = false
        if adRowNumber < elements.count {
            elements[adRowNumber] = false
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

        tableView.reloadData()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableViewAdCellWidth = tableView.frame.width - 20
    }

    func closeSlot() {
        if adRowNumber < elements.count {
            elements[adRowNumber] = false
            teadsAdIsLoaded = false
        }
        tableView.reloadData()
    }

    func updateAdCellHeight() {
        if teadsAdIsLoaded {
            tableView.reloadRows(at: [IndexPath(row: adRowNumber, section: 0)], with: .automatic)
        }
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
        } else if elements[indexPath.row], let nativeAdView = adView {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: teadsAdCellIndentifier, for: indexPath) as? NativeAdTableViewCell else {
                return UITableViewCell()
            }
            // The ad is already bound via loadAd() closure
            // Note: Tag-based binding would need to be set up when creating the adView
            // Just add the view to the cell if not already added
            if cell.adView != nativeAdView {
                cell.adView = nativeAdView
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
                print("Native ad ready")
                teadsAdIsLoaded = true
                elements.insert(true, at: adRowNumber)
                let indexPaths = [IndexPath(row: adRowNumber, section: 0)]
                tableView.insertRows(at: indexPaths, with: .automatic)
                tableView.reloadData()

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
