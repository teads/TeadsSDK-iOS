//
//  NativeMopubTableViewController.swift
//  TeadsSampleApp
//
//  Created by Paul Nicolas on 26/07/2021.
//  Copyright © 2021 Teads. All rights reserved.
//

import UIKit
#if canImport(MoPubSDK)
import MoPubSDK
#else
import MoPub
#endif
import TeadsMoPubAdapter
import TeadsSDK

class NativeMopubTableViewController: TeadsViewController {
    @IBOutlet var tableView: UITableView!

    let headerCell = "TeadsContentCell"
    let teadsAdCellIndentifier = "NativeTableViewCell"
    let fakeArticleCell = "FakeArticleNativeTableViewCell"
    let adRowNumber = 3

    private var elements = [MPNativeAd?]()

    override func viewDidLoad() {
        super.viewDidLoad()

        (0 ..< 8).forEach { _ in
            elements.append(nil)
        }

        let mpConfig = MPMoPubConfiguration(adUnitIdForAppInitialization: pid)
        mpConfig.loggingLevel = .debug

        if MoPub.sharedInstance().isSdkInitialized {
            loadAd()
        }

        MoPub.sharedInstance().initializeSdk(with: mpConfig) { [weak self] in
            self?.loadAd()
        }
    }

    func loadAd() {
        let settings = MPAdapterTeadsNativeAdRendererSettings()

        settings.renderingViewClass = MoPubNativeAdView.self

        let config: MPNativeAdRendererConfiguration =
            MPAdapterTeadsNativeAdRenderer.rendererConfiguration(with: settings)

        let adRequest = MPNativeAdRequest(adUnitIdentifier: pid, rendererConfigurations: [config])

        let targeting = MPNativeAdRequestTargeting()
        targeting?.desiredAssets = [kAdTitleKey, kAdTextKey, kAdCTATextKey, kAdIconImageKey, kAdMainImageKey, kAdStarRatingKey, kAdSponsoredByCompanyKey]

        let adSettings = TeadsAdapterSettings { settings in
            settings.enableDebug()
            settings.pageUrl("http://teads.tv")
        }
        targeting?.register(teadsAdSettings: adSettings)
        adRequest?.targeting = targeting

        adRequest?.start { [weak self] _, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            } else if let ad = response {
                self?.didReceiveAd(ad)
            }
        }
    }

    func didReceiveAd(_ ad: MPNativeAd) {
        ad.delegate = self
        elements.insert(ad, at: adRowNumber)
        let indexPaths = [IndexPath(row: adRowNumber, section: 0)]
        tableView.insertRows(at: indexPaths, with: .automatic)
    }

    func closeSlot(ad: TeadsAd) {
        elements.removeAll { $0 == ad }
        tableView.reloadData()
    }
}

extension NativeMopubTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return elements.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: headerCell, for: indexPath)
            return cell
        } else if let ad = elements[indexPath.row] {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: teadsAdCellIndentifier, for: indexPath) as? NativeTableViewCell else {
                return UITableViewCell()
            }

            if let av = try? ad.retrieveAdView() {
                av.frame = cell.nativeAdView.bounds
                av.autoresizingMask = [.flexibleHeight, .flexibleWidth]
                cell.nativeAdView.addSubview(av)
            }

            cell.nativeAdView.isHidden = false
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: fakeArticleCell, for: indexPath) as? FakeArticleNativeTableViewCell else {
                return UITableViewCell()
            }
            cell.setMockValues()
            return cell
        }
    }

    func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 250
        }
        return 400
    }
}

extension NativeMopubTableViewController: MPNativeAdDelegate {
    func viewControllerForPresentingModalView() -> UIViewController! {
        return self
    }
}
