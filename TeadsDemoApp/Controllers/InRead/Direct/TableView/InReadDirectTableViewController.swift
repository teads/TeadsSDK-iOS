//
//  InReadDirectTableViewController.swift
//  TeadsDemoApp
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
    let adRowNumber = 2
    var adHeight: CGFloat?
    var adRatio: CGFloat?
    var teadsAdIsLoaded = false
    var teadsAdView: TFAInReadAdView?
    var tableViewAdCellWidth: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        teadsAdView = TFAInReadAdView(withPid: UserDefaults.standard.integer(forKey: "PID"), andDelegate: self)
        teadsAdView?.load()
        
        // We use an observer to know when a rotation happened, to resize the ad
        // You can use whatever way you want to do so
        NotificationCenter.default.addObserver(self, selector: #selector(rotationDetected), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableViewAdCellWidth = tableView.frame.width - 20
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc func rotationDetected() {
        if adRatio != nil {
            resizeTeadsAd(adRatio: adRatio!)
        }
    }
    
    func resizeTeadsAd(adRatio: CGFloat) {
        if adRatio > 0 {
            adHeight = tableViewAdCellWidth/adRatio
        }
        updateAdCellHeight()
    }
  
    func closeSlot() {
        adHeight = 0
        updateAdCellHeight()
    }
    
    func updateAdCellHeight() {
        tableView.reloadRows(at: [IndexPath(row: adRowNumber, section: 0)], with: .automatic)
    }

}

extension InReadDirectTableViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: contentCell, for: indexPath)
            return cell
        case adRowNumber:
            //need to create a cell and just add a teadsAd to it, so we have only one teads ad
            let cellAd = tableView.dequeueReusableCell(withIdentifier: teadsAdCellIndentifier, for: indexPath)
            if let teadsAdView = teadsAdView {
                cellAd.addSubview(teadsAdView)
                teadsAdView.frame = CGRect(x: 10, y: 0, width: tableViewAdCellWidth, height: adHeight ?? 250)
            }
            return cellAd
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: fakeArticleCell, for: indexPath)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == adRowNumber {
            return adHeight ?? 0
        } else {
            return UITableView.automaticDimension
        }
    }
    
}

extension InReadDirectTableViewController: TFAAdDelegate {
    
    func didReceiveAd(_ ad: TFAAdView, adRatio: CGFloat) {
        self.adRatio = adRatio
        resizeTeadsAd(adRatio: adRatio)
    }
    
    func didFailToReceiveAd(_ ad: TFAAdView, adFailReason: AdFailReason) {
        closeSlot()
    }
    
    func adClose(_ ad: TFAAdView, userAction: Bool) {
        closeSlot()
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
