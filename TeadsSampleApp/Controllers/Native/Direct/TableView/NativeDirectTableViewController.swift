//
//  NativeDirectTableViewController.swift
//  TeadsSampleApp
//
//  Created by Paul Nicolas on 26/07/2021.
//  Copyright © 2021 Teads. All rights reserved.
//

import TeadsSDK
import UIKit

@available(iOS 13.0, *)
class NativeDirectTableViewController: TeadsViewController {
    @IBOutlet var tableView: UITableView!

    let headerCell = "TeadsContentCell"
    let teadsAdCellIndentifier = "NativeAdTableViewCell"
    let fakeArticleCell = "FakeArticleNativeTableViewCell"
    let adRowNumber = 3
    var adRatio: TeadsAdRatio?
    var teadsAdIsLoaded = false
    var placement: TeadsAdPlacementMediaNative?
    private var nativeAdView: TeadsNativeAdView?
    var tableViewAdCellWidth: CGFloat!

    private var elements: [Any?] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        for _ in 0 ..< 8 {
            elements.append(nil)
        }

        // Create custom native ad view
        nativeAdView = createCustomNativeAdView()

        // Create configuration
        let config = TeadsAdPlacementMediaConfig(
            pid: Int(pid) ?? 0,
            articleUrl: URL(string: "https://www.teads.com")
        )

        // Create placement
        placement = TeadsAdPlacementMediaNative(config, delegate: self)

        // Load and bind the ad
        do {
            if let binder = try placement?.loadAd(), let nativeAdView = nativeAdView {
                binder(nativeAdView)
            }
        } catch {
            print("Failed to load native ad: \(error)")
        }
    }

    @available(iOS 13.0, *)
    private func createCustomNativeAdView() -> TeadsNativeAdView {
        // Create your custom native ad view
        let adView = TeadsNativeAdView(frame: .zero)

        adView.backgroundColor = .systemBackground
        adView.layer.cornerRadius = 12
        adView.layer.shadowColor = UIColor.black.cgColor
        adView.layer.shadowOpacity = 0.1
        adView.layer.shadowRadius = 8

        return adView
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableViewAdCellWidth = tableView.frame.width - 20
    }

    func closeSlot(ad: Any) {
        elements.removeAll {
            if let element = $0, let elementAsEquatable = element as? AnyHashable, let adAsEquatable = ad as? AnyHashable {
                return elementAsEquatable == adAsEquatable
            }
            return false
        }
        tableView.reloadData()
    }

    func updateAdCellHeight() {
        tableView.reloadRows(at: [IndexPath(row: adRowNumber, section: 0)], with: .automatic)
    }
}

@available(iOS 13.0, *)
extension NativeDirectTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return elements.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: headerCell, for: indexPath)
            return cell
        } else if elements[indexPath.row] != nil && elements[indexPath.row] is String, let nativeAdView = nativeAdView {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: teadsAdCellIndentifier, for: indexPath) as? NativeAdTableViewCell else {
                return UITableViewCell()
            }
            // The native ad view is already bound, just ensure it's in the cell
            if nativeAdView.superview != cell.contentView {
                // Remove from any previous parent
                nativeAdView.removeFromSuperview()
                // Add to cell
                cell.contentView.addSubview(nativeAdView)
                nativeAdView.translatesAutoresizingMaskIntoConstraints = false
                nativeAdView.topAnchor.constraint(equalTo: cell.contentView.topAnchor).isActive = true
                nativeAdView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor).isActive = true
                nativeAdView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor).isActive = true
                nativeAdView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor).isActive = true
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

@available(iOS 13.0, *)
extension NativeDirectTableViewController: TeadsAdPlacementEventsDelegate {
    func adPlacement(
        _: TeadsAdPlacementIdentifiable?,
        didEmitEvent event: TeadsAdPlacementEventName,
        data: [String: Any]?
    ) {
        switch event {
            case .ready:
                // Ad is ready, insert a marker in the elements array to indicate ad is ready
                if let _ = nativeAdView {
                    elements.insert("nativeAd" as Any, at: adRowNumber)
                    let indexPaths = [IndexPath(row: adRowNumber, section: 0)]
                    tableView.insertRows(at: indexPaths, with: .automatic)
                }
            case .failed:
                print("didFailToReceiveAd: \(String(describing: data?["error"]))")
            default:
                break
        }
    }
}

// TeadsAdDelegate is handled through unified events system
