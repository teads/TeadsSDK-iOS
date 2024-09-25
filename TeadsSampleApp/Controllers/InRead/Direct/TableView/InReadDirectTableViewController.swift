import TeadsSDK
import UIKit

class InReadDirectTableViewController: TeadsViewController {
    @IBOutlet var tableView: UITableView!

    let contentCell = "TeadsContentCell"
    let teadsAdCellIdentifier = "TeadsAdCell"
    let fakeArticleCell = "fakeArticleCell"
    let trackerViewRowNumber = 3

    private var ads = [TeadsInReadAd]()
    var adRatios: [TeadsAdRatio?] = []
    private var adViews: [TeadsInReadAdView] = []
    var adHeightConstraints: [NSLayoutConstraint] = []
    var adBoundFlags: [Bool] = []
    var teadsTrackerView = TeadsAdOpportunityTrackerView()

    var numberOfAds = 0
    var maxAds = 5

    var placement: TeadsInReadAdPlacement?

    override func viewDidLoad() {
        super.viewDidLoad()

        let placementSettings = TeadsAdPlacementSettings { settings in
            settings.enableDebug()
        }

        // Create the placement, keeping a strong reference
        placement = Teads.createInReadPlacement(pid: Int(pid) ?? 0, settings: placementSettings, delegate: self)

        // Request multiple ads
        for _ in 0 ..< maxAds {
            placement?.requestAd(requestSettings: TeadsAdRequestSettings { settings in
                settings.pageUrl("https://www.teads.com")
            })
        }

        // Create placeholder adViews
        for _ in 0 ..< maxAds {
            let adPlaceholderView = TeadsInReadAdView()

            // Set initial placeholder height
            let initialHeightConstraint = adPlaceholderView.heightAnchor.constraint(equalToConstant: 250)
            initialHeightConstraint.isActive = true

            // Store the initial height constraint so we can deactivate it later
            adHeightConstraints.append(initialHeightConstraint)

            adViews.append(adPlaceholderView)
            adBoundFlags.append(false) // Track unbound placeholders
        }

        tableView.register(AdOpportunityTrackerTableViewCell.self, forCellReuseIdentifier: AdOpportunityTrackerTableViewCell.identifier)
    }

    func closeSlot(ad: TeadsAd) {
        guard let inReadAd = ad as? TeadsInReadAd else { return }
        if let index = ads.firstIndex(of: inReadAd) {
            adBoundFlags[index] = false
        }
        tableView.reloadData()
        numberOfAds -= 1
    }

    func updateAdCellHeight(at index: Int) {
        tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
}

extension InReadDirectTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return 17 // Static number of rows as per the example (can be dynamic based on actual data)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            return tableView.dequeueReusableCell(withIdentifier: contentCell, for: indexPath)
        } else if indexPath.row == 1 {
            let cellAd = tableView.dequeueReusableCell(withIdentifier: AdOpportunityTrackerTableViewCell.identifier, for: indexPath) as! AdOpportunityTrackerTableViewCell
            cellAd.setTrackerView(teadsTrackerView)
            return cellAd
        } else if indexPath.row % 3 == 0 {
            let cellAd = tableView.dequeueReusableCell(withIdentifier: teadsAdCellIdentifier, for: indexPath)
            let adIndex = (indexPath.row / 3) - 1
            if adIndex < ads.count {
                // Create a blue background container view
                let adContainerView = UIView()
                adContainerView.backgroundColor = UIColor.blue
                adContainerView.translatesAutoresizingMaskIntoConstraints = false

                // Create and bind the ad view
                let teadsAdView = adViews[adIndex]
                if !teadsAdView.isDescendant(of: adContainerView) {
                    teadsAdView.removeFromSuperview()
                    teadsAdView.bind(ads[adIndex])
                    teadsAdView.translatesAutoresizingMaskIntoConstraints = false
                    adContainerView.addSubview(teadsAdView)
                }

                // Add the container to the cell content view
                cellAd.contentView.addSubview(adContainerView)

                // Setup constraints for the container and ad view
                NSLayoutConstraint.activate([
                    // Set container view constraints to fill the cell
                    adContainerView.leadingAnchor.constraint(equalTo: cellAd.contentView.leadingAnchor),
                    adContainerView.trailingAnchor.constraint(equalTo: cellAd.contentView.trailingAnchor),
                    adContainerView.topAnchor.constraint(equalTo: cellAd.contentView.topAnchor),
                    adContainerView.bottomAnchor.constraint(equalTo: cellAd.contentView.bottomAnchor),

                    // Set the ad view constraints to fit within the container view
                    teadsAdView.leadingAnchor.constraint(equalTo: adContainerView.leadingAnchor, constant: 10),
                    teadsAdView.trailingAnchor.constraint(equalTo: adContainerView.trailingAnchor, constant: -10),
                    teadsAdView.topAnchor.constraint(equalTo: adContainerView.topAnchor, constant: 10),
                    teadsAdView.bottomAnchor.constraint(equalTo: adContainerView.bottomAnchor, constant: -10),
                ])
            }
            return cellAd
        } else {
            return tableView.dequeueReusableCell(withIdentifier: fakeArticleCell, for: indexPath)
        }
    }

    func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 1 {
            return 0 // Tracker view row
        } else if indexPath.row % 3 == 0, indexPath.row != 0 {
            let adIndex = (indexPath.row / 3) - 1
            if adRatios.count > adIndex, let adRatio = adRatios[adIndex] {
                resizeTeadsAd(at: adIndex, adRatio: adRatio)
            }
            return adHeightConstraints[adIndex].constant
        }
        return UITableView.automaticDimension
    }
}

extension InReadDirectTableViewController: TeadsInReadAdPlacementDelegate {
    func didReceiveAd(ad: TeadsInReadAd, adRatio: TeadsAdRatio) {
        print("Ad received successfully")
        // Keep a strong reference to each received ad
        ads.append(ad)

        if let index = adBoundFlags.firstIndex(of: false) {
            let adPlaceholderView = adViews[index]
            adPlaceholderView.bind(ad)
            ad.delegate = self

            // Mark the placeholder as bound
            adBoundFlags[index] = true

            // Resize and update layout
            resizeTeadsAd(at: index, adRatio: adRatio)
            let rowIndex = (index + 1) * 3
            tableView.reloadRows(at: [IndexPath(row: rowIndex, section: 0)], with: .automatic)
            adPlaceholderView.layoutIfNeeded()
            tableView.reloadData()
        }
    }

    func didFailToReceiveAd(reason: AdFailReason) {
        print("didFailToReceiveAd: \(reason.description)")
    }

    func didUpdateRatio(ad: TeadsInReadAd, adRatio: TeadsAdRatio) {
        if let index = ads.firstIndex(of: ad) {
            resizeTeadsAd(at: index, adRatio: adRatio)
            let rowIndex = (index + 1) * 3
            tableView.reloadRows(at: [IndexPath(row: rowIndex, section: 0)], with: .automatic)
        }
    }

    func adOpportunityTrackerView(trackerView: TeadsAdOpportunityTrackerView) {
        teadsTrackerView = trackerView
        tableView.reloadRows(at: [IndexPath(row: trackerViewRowNumber, section: 0)], with: .automatic)
    }

    func resizeTeadsAd(at index: Int, adRatio: TeadsAdRatio) {
        guard index < adViews.count else { return }

        let adView = adViews[index]

        // Remove any old height constraints
        if index < adHeightConstraints.count {
            adHeightConstraints[index].isActive = false
            adHeightConstraints.remove(at: index)
        }

        // Calculate the new height based on the adRatio and view width
        let newHeight = adRatio.calculateHeight(for: adView.frame.width)

        print("Resizing ad at index \(index) to height \(newHeight) based on width \(adView.frame.width)")

        // Create and activate a new height constraint
        let newHeightConstraint = adView.heightAnchor.constraint(equalToConstant: 400)
        newHeightConstraint.isActive = true

        // Store the new height constraint
        adHeightConstraints.insert(newHeightConstraint, at: index)

        // Trigger layout updates
        tableView.layoutIfNeeded()
    }
}

extension InReadDirectTableViewController: TeadsAdDelegate {
    func didRecordImpression(ad _: TeadsAd) {}
    func didRecordClick(ad _: TeadsAd) {}
    func willPresentModalView(ad _: TeadsAd) -> UIViewController? { return nil }
    func didCatchError(ad: TeadsAd, error _: Error) { closeSlot(ad: ad) }
    func didClose(ad: TeadsAd) { closeSlot(ad: ad) }
}

extension UIView {
    func setupConstraintsToFitSuperView(horizontalMargin: CGFloat = 0) {
        guard let superview = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superview.topAnchor),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor),
            leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: horizontalMargin),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -horizontalMargin),
        ])
    }
}
