//
//  TableViewController.swift
//  TeadsDemoApp
//
//  Created by Jérémy Grosjean on 02/10/2017.
//  Copyright © 2018 Teads. All rights reserved.
//

import UIKit
import TeadsSDK

class TableViewController: UITableViewController, TFAAdDelegate {

    let firstCellIdentifier = "TeadsFirstCell"
    let contentCell = "TeadsContentCell"
    let articleCell = "TeadsArticleCell"
    let teadsAdCellIndentifier = "TeadsAdCell"
    let fakeArticleCell = "fakeArticleCell"
    let adRowNumber = 4
    var adHeight: CGFloat?
    var adRatio: CGFloat?
    var teadsAdIsLoaded = false
    var teadsAdView: TFAInReadAdView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.teadsAdView = TFAInReadAdView(withPid: UserDefaults.standard.integer(forKey: "PID"), andDelegate: self)
        self.teadsAdView?.load()
        self.teadsAdView?.translatesAutoresizingMaskIntoConstraints = false
        
        // We use an observer to know when a rotation happened, to resize the ad
        // You can use whatever way you want to do so
        NotificationCenter.default.addObserver(self, selector: #selector(self.rotationDetected), name: UIDevice.orientationDidChangeNotification, object: nil)
        guard let navigationBar = navigationController?.navigationBar else {
            return
        }
        Utils.teadsNavigationBar(navigationBar: navigationBar, navigationItem: navigationItem)
        tableView.rowHeight = UITableView.automaticDimension

    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc func rotationDetected() {
        if self.adRatio != nil {
            self.resizeTeadsAd(adRatio: self.adRatio!)
        }
    }
    
    func resizeTeadsAd(adRatio: CGFloat) {
        if adRatio > 0 {
            self.adHeight = self.tableView.frame.width/adRatio
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: self.firstCellIdentifier, for: indexPath)
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: self.articleCell, for: indexPath)
            return cell
        }else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: self.contentCell, for: indexPath)
            return cell
        } else if indexPath.row == adRowNumber {
            //need to create a cell and just add a teadsAd to it, so we have only one teads ad
            let cellAd = tableView.dequeueReusableCell(withIdentifier: self.teadsAdCellIndentifier, for: indexPath) as! TeadsAdTableViewCell
            if self.teadsAdView != nil {
                cellAd.adContentView.addSubview(self.teadsAdView!)
                var allConstraints = [NSLayoutConstraint]()
                let viewsDictionary: [String: UIView] = ["adView": self.teadsAdView!]
                let adHorizontalConstraints = NSLayoutConstraint.constraints(
                    withVisualFormat: "H:|[adView]|",
                    options: [],
                    metrics: nil,
                    views: viewsDictionary)
                allConstraints += adHorizontalConstraints
                let adVerticalConstraints = NSLayoutConstraint.constraints(
                    withVisualFormat: "V:|[adView]|",
                    options: [],
                    metrics: nil,
                    views: viewsDictionary)
                allConstraints += adVerticalConstraints
                NSLayoutConstraint.activate(allConstraints)
                teadsAdView?.frame = CGRect(x: 0, y: 0, width: teadsAdView!.bounds.width, height: adHeight ?? 250)
                cellAd.adContentView.layoutIfNeeded()
                
            }
            return cellAd
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: fakeArticleCell, for: indexPath)
            return cell
        }
    }

  
    func closeSlot() {
        self.adHeight = 0
        self.tableView.reloadRows(at: [IndexPath(row: self.adRowNumber, section: 0)], with: .automatic)
    }
    
    // MARK: - TFAAdDelegate
    
    func didReceiveAd(_ ad: TFAAdView, adRatio: CGFloat) {
        self.adRatio = adRatio
        self.resizeTeadsAd(adRatio: adRatio)
    }
    
    func didFailToReceiveAd(_ ad: TFAAdView, adFailReason: AdFailReason) {
        self.closeSlot()
    }
    
    func adClose(_ ad: TFAAdView, userAction: Bool) {
        self.closeSlot()
        //be careful if you want to load another ad in the same page don't remove the observer
        NotificationCenter.default.removeObserver(self)
    }
    
    public func didUpdateRatio(_ ad: TFAAdView, ratio: CGFloat) {
        adRatio = ratio
        //update slot with the right ratio
        resizeTeadsAd(adRatio: ratio)
    }
    
    public func adError(_ ad: TFAAdView, errorMessage: String) {
        //be careful if you want to load another ad in the same page don't remove the observer
        NotificationCenter.default.removeObserver(self)
    }
    
    public func adBrowserWillOpen(_ ad: TFAAdView) -> UIViewController? {
        return self
    }
}
