//
//  InReadDirectTableViewController.swift
//  TeadsSampleApp
//
//  Created by Jérémy Grosjean on 02/10/2017.
//  Copyright © 2018 Teads. All rights reserved.
//

import UIKit
import TeadsSDK

class InReadDirectTableViewController: TeadsViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let contentCell = "TeadsContentCell"
    let teadsAdCellIndentifier = "TeadsAdCell"
    let fakeArticleCell = "fakeArticleCell"
    let adRowNumber = 3
    var placement: TeadsInReadAdPlacement?
    
    private var elements = [TeadsInReadAd?]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        (0..<8).forEach { _ in
            elements.append(nil)
        }
            
        let placementSettings = TeadsAdPlacementSettings { (settings) in
            settings.enableDebug()
        }
        placement = Teads.createInReadPlacement(pid: Int(pid) ?? 0, settings: placementSettings, delegate: self)
        
        placement?.requestAd(requestSettings: TeadsAdRequestSettings { settings in
            settings.pageUrl("https://www.teads.tv")
        })
    }
    
    func closeSlot(ad: TeadsAd) {
        elements.removeAll { $0 == ad }
        tableView.reloadData()
    }
    
    func updateAdCellHeight() {
        tableView.reloadRows(at: [IndexPath(row: adRowNumber, section: 0)], with: .automatic)
    }
}

extension InReadDirectTableViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return elements.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            return tableView.dequeueReusableCell(withIdentifier: contentCell, for: indexPath)
        } else if let ad = elements[indexPath.row] {
            let cellAd = tableView.dequeueReusableCell(withIdentifier: teadsAdCellIndentifier, for: indexPath)
            let teadsAdView = TeadsInReadAdView(bind: ad)
            cellAd.contentView.addSubview(teadsAdView)
            teadsAdView.setupConstraintsToFitSuperView(horizontalMargin: 10)
            return cellAd
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: fakeArticleCell, for: indexPath)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let ad = elements[indexPath.row] {
            return ad.adRatio.calculateHeight(for: tableView.frame.width - 20)
        }
        return UITableView.automaticDimension
    }
    
}

extension InReadDirectTableViewController: TeadsInReadAdPlacementDelegate {
    
    func didReceiveAd(ad: TeadsInReadAd, adRatio: TeadsAdRatio) {
        elements.insert(ad, at: adRowNumber)
        ad.delegate = self
        let indexPaths = [IndexPath(row: adRowNumber, section: 0)]
        tableView.insertRows(at: indexPaths, with: .automatic)
    }
    
    func didFailToReceiveAd(reason: AdFailReason) {
        print("didFailToReceiveAd: \(reason.description)")
    }
    
    func didUpdateRatio(ad: TeadsInReadAd, adRatio: TeadsAdRatio) {
        if let row = elements.firstIndex(of: ad) {
            tableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .automatic)
        }
        
    }
    
    func adOpportunityTrackerView(trackerView: TeadsAdOpportunityTrackerView) {
        //not relevant in tableView integration
    }
    
}

extension InReadDirectTableViewController: TeadsAdDelegate {
    func didRecordImpression(ad: TeadsAd) {
        
    }
    
    func didRecordClick(ad: TeadsAd) {
        
    }
    
    func willPresentModalView(ad: TeadsAd) -> UIViewController? {
        return self
    }
    
    func didCatchError(ad: TeadsAd, error: Error) {
        closeSlot(ad: ad)
    }
    
    func didCloseAd(ad: TeadsAd) {
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
