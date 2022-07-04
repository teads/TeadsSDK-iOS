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
    let trackerViewRowNumber = 3 // tracker view needs to be placed above the slot view
    var adRowNumber: Int {
        return trackerViewRowNumber + 1
    }

    var placement: TeadsInReadAdPlacement?

    enum TeadsElement: Equatable {
        case article
        case ad(_ ad: TeadsInReadAd)
        case trackerView(_ trackerView: TeadsAdOpportunityTrackerView)
    }

    private var elements = [TeadsElement]()

    override func viewDidLoad() {
        super.viewDidLoad()

        (0 ..< 8).forEach { _ in
            elements.append(.article)
        }

        let placementSettings = TeadsAdPlacementSettings { settings in
            settings.enableDebug()
        }
        
        //keep a strong reference to placement instance
        placement = Teads.createInReadPlacement(pid: Int(pid) ?? 0, settings: placementSettings, delegate: self)
        placement?.requestAd(requestSettings: TeadsAdRequestSettings { settings in
            settings.pageUrl("https://www.teads.tv")
        })

        tableView.register(AdOpportunityTrackerTableViewCell.self, forCellReuseIdentifier: AdOpportunityTrackerTableViewCell.identifier)
    }

    func closeSlot(ad: TeadsAd) {
        guard let inReadAd = ad as? TeadsInReadAd else {
            return
        }
        elements.removeAll { $0 == .ad(inReadAd) }
        tableView.reloadData()
    }

    func updateAdCellHeight() {
        tableView.reloadRows(at: [IndexPath(row: adRowNumber, section: 0)], with: .automatic)
    }
}

extension InReadDirectTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return elements.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            return tableView.dequeueReusableCell(withIdentifier: contentCell, for: indexPath)
        } else if case let .ad(ad) = elements[indexPath.row] {
            let cellAd = tableView.dequeueReusableCell(withIdentifier: teadsAdCellIndentifier, for: indexPath)
            let teadsAdView = TeadsInReadAdView(bind: ad)
            cellAd.contentView.addSubview(teadsAdView)
            teadsAdView.setupConstraintsToFitSuperView(horizontalMargin: 10)
            return cellAd
        } else if case let .trackerView(trackerView) = elements[indexPath.row],
                  let cellAd = tableView.dequeueReusableCell(withIdentifier: AdOpportunityTrackerTableViewCell.identifier, for: indexPath) as? AdOpportunityTrackerTableViewCell
        {
            cellAd.setTrackerView(trackerView)
            return cellAd
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: fakeArticleCell, for: indexPath)
            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if case let .ad(ad) = elements[indexPath.row] {
            return ad.adRatio.calculateHeight(for: tableView.frame.width - 20)
        } else if case .trackerView = elements[indexPath.row] {
            return 0
        }
        return UITableView.automaticDimension
    }
}

extension InReadDirectTableViewController: TeadsInReadAdPlacementDelegate {
    func didReceiveAd(ad: TeadsInReadAd, adRatio _: TeadsAdRatio) {
        elements.insert(.ad(ad), at: adRowNumber)
        ad.delegate = self
        let indexPaths = [IndexPath(row: adRowNumber, section: 0)]
        tableView.insertRows(at: indexPaths, with: .automatic)
    }

    func didFailToReceiveAd(reason: AdFailReason) {
        print("didFailToReceiveAd: \(reason.description)")
    }

    func didUpdateRatio(ad: TeadsInReadAd, adRatio _: TeadsAdRatio) {
        if let row = elements.firstIndex(of: .ad(ad)) {
            tableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .automatic)
        }
    }

    func adOpportunityTrackerView(trackerView: TeadsAdOpportunityTrackerView) {
        elements.insert(.trackerView(trackerView), at: trackerViewRowNumber)
        let indexPaths = [IndexPath(row: trackerViewRowNumber, section: 0)]
        tableView.insertRows(at: indexPaths, with: .automatic)
    }
}

extension InReadDirectTableViewController: TeadsAdDelegate {
    func didRecordImpression(ad _: TeadsAd) {}

    func didRecordClick(ad _: TeadsAd) {}

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
