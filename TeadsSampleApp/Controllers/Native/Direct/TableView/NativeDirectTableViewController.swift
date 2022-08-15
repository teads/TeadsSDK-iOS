//
//  NativeDirectTableViewController.swift
//  TeadsSampleApp
//
//  Created by Paul Nicolas on 26/07/2021.
//  Copyright © 2021 Teads. All rights reserved.
//

import TeadsSDK
import UIKit

class NativeDirectTableViewController: TeadsViewController {
    @IBOutlet var tableView: UITableView!

    let headerCell = "TeadsContentCell"
    let teadsAdCellIndentifier = "NativeAdTableViewCell"
    let fakeArticleCell = "FakeArticleNativeTableViewCell"
    let adRowNumber = 3
    var adRatio: TeadsAdRatio?
    var teadsAdIsLoaded = false
    var placement: TeadsNativeAdPlacement?
    var tableViewAdCellWidth: CGFloat!

    private var elements = [TeadsNativeAd?]()

    override func viewDidLoad() {
        super.viewDidLoad()

        (0 ..< 8).forEach { _ in
            elements.append(nil)
        }

        let placementSettings = TeadsAdPlacementSettings { settings in
            settings.enableDebug()
        }

        // keep a strong reference to placement instance
        placement = Teads.createNativePlacement(pid: Int(pid) ?? 0, settings: placementSettings, delegate: self)

        placement?.requestAd(requestSettings: TeadsAdRequestSettings { settings in
            settings.pageUrl("https://www.teads.tv")
        })
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

extension NativeDirectTableViewController: UITableViewDelegate, UITableViewDataSource {
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
            cell.adView.bind(ad)
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

extension NativeDirectTableViewController: TeadsNativeAdPlacementDelegate {
    func didReceiveAd(ad: TeadsNativeAd) {
        elements.insert(ad, at: adRowNumber)
        let indexPaths = [IndexPath(row: adRowNumber, section: 0)]
        tableView.insertRows(at: indexPaths, with: .automatic)
        tableView.reloadData()
        ad.delegate = self
    }

    func didFailToReceiveAd(reason: AdFailReason) {
        print("didFailToReceiveAd: \(reason.description)")
    }

    func adOpportunityTrackerView(trackerView _: TeadsAdOpportunityTrackerView) {
        // not relevant in tableView integration
    }
}

extension NativeDirectTableViewController: TeadsAdDelegate {
    func didRecordImpression(ad _: TeadsAd) {
        // you may want to use this callback for your own analytics
    }

    func didRecordClick(ad _: TeadsAd) {
        // you may want to use this callback for your own analytics
    }

    func willPresentModalView(ad _: TeadsAd) -> UIViewController? {
        return self
    }

    func didCatchError(ad: TeadsAd, error _: Error) {
        closeSlot(ad: ad)
    }

    func didClose(ad: TeadsAd) {
        closeSlot(ad: ad)
    }
}
