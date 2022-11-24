//
//  NativeAppLovinTableViewController.swift
//  TeadsSDKIntegrationTestsApp
//
//  Created by Paul Nicolas on 15/02/2022.
//

import AppLovinSDK
import TeadsAppLovinAdapter
import TeadsSDK
import UIKit

class NativeAppLovinTableViewController: TeadsViewController {
    @IBOutlet var tableView: UITableView!

    let headerCell = "TeadsContentCell"
    let teadsAdCellIndentifier = "NativeTableViewCell"
    let fakeArticleCell = "FakeArticleNativeTableViewCell"
    let adRowNumber = 3

    private var elements = [MANativeAdView?]()
    private var nativeAdLoader: MANativeAdLoader!
    private var nativeAdView: MANativeAdView!

    override func viewDidLoad() {
        super.viewDidLoad()

        (0 ..< 8).forEach { _ in
            elements.append(nil)
        }

        ALSdk.shared()?.mediationProvider = ALMediationProviderMAX
        ALSdk.shared()!.settings.isVerboseLoggingEnabled = true
        ALSdk.shared()!.initializeSdk { [weak self] (_: ALSdkConfiguration) in
            self?.loadAd()
        }
    }

    func loadAd() {
        // FIXME: This ids should be replaced by your own AppLovin AdUnitId
        let APPLOVIN_AD_UNIT_ID = pid
        nativeAdLoader = MANativeAdLoader(adUnitIdentifier: APPLOVIN_AD_UNIT_ID)

        // Setting the modal parent view controller.
        let teadsAdSettings = TeadsAdapterSettings { settings in
            settings.enableDebug()
            settings.pageUrl("https://www.teads.tv")
        }

        nativeAdLoader.register(teadsAdSettings: teadsAdSettings)

        nativeAdLoader.nativeAdDelegate = self
        nativeAdView = AppLovinNativeAdView.loadNib()
        nativeAdView.bindViews(with: MANativeAdViewBinder { builder in
            builder.titleLabelTag = 1
            builder.advertiserLabelTag = 2
            builder.bodyLabelTag = 3
            builder.iconImageViewTag = 4
            builder.optionsContentViewTag = 5
            builder.mediaContentViewTag = 6
            builder.callToActionButtonTag = 7
        })
        nativeAdLoader.loadAd(into: nativeAdView)
    }

    func closeSlot(ad: TeadsAd) {
        elements.removeAll { $0 == ad }
        tableView.reloadData()
    }
}

extension NativeAppLovinTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return elements.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: headerCell, for: indexPath)
            return cell
        } else if let nativeAdView = elements[indexPath.row] {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: teadsAdCellIndentifier, for: indexPath) as? NativeTableViewCell else {
                return UITableViewCell()
            }
            nativeAdView.translatesAutoresizingMaskIntoConstraints = false
            cell.nativeAdView.addSubview(nativeAdView)
            nativeAdView.topAnchor.constraint(equalTo: cell.contentView.topAnchor).isActive = true
            nativeAdView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor).isActive = true
            nativeAdView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor).isActive = true
            nativeAdView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor).isActive = true

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

extension NativeAppLovinTableViewController: MANativeAdDelegate {
    func didLoadNativeAd(_ nativeAdView: MANativeAdView?, for _: MAAd) {
        elements.insert(nativeAdView, at: adRowNumber)
        let indexPaths = [IndexPath(row: adRowNumber, section: 0)]
        tableView.insertRows(at: indexPaths, with: .automatic)
    }

    func didFailToLoadNativeAd(forAdUnitIdentifier _: String, withError _: MAError) {
        // handle fail to load
    }

    func didClickNativeAd(_: MAAd) {
        print("didClickNativeAd")
    }
}
