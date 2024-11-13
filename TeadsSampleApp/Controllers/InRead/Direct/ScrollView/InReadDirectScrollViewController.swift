import TeadsSDK
import UIKit

class InReadDirectScrollViewController: TeadsViewController {
    @IBOutlet var scrollDownImageView: TeadsGradientImageView!
    @IBOutlet var teadsAdView: TeadsInReadAdView!
    @IBOutlet var teadsAdHeightConstraint: NSLayoutConstraint!
    var adRatio: TeadsAdRatio?
    var placement: TeadsInReadAdPlacement?

    let anotherView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        let pSettings = TeadsAdPlacementSettings { settings in
            settings.enableDebug()
        }

        // Set up teadsAdView and anotherView
        teadsAdView.translatesAutoresizingMaskIntoConstraints = false
        anotherView.translatesAutoresizingMaskIntoConstraints = false
        anotherView.backgroundColor = .black
        view.addSubview(anotherView)
        view.addSubview(teadsAdView)

        // Uncomment the following lines to make teadsAdView match parent width
//        NSLayoutConstraint.activate([
//            teadsAdView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            teadsAdView.topAnchor.constraint(equalTo: view.topAnchor),
//            teadsAdView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//            teadsAdView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//        ])

        // Uncomment the following lines to make teadsAdView fill 50% of the available horizontal content
        NSLayoutConstraint.activate([
            teadsAdView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            teadsAdView.topAnchor.constraint(equalTo: view.topAnchor),
            teadsAdView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            teadsAdView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),

            anotherView.leadingAnchor.constraint(equalTo: teadsAdView.trailingAnchor),
            anotherView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            anotherView.topAnchor.constraint(equalTo: view.topAnchor),
            anotherView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            anotherView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
        ])

        // keep a strong reference to placement instance
        placement = Teads.createInReadPlacement(pid: Int(pid) ?? 0, settings: pSettings, delegate: self)
        placement?.requestAd(requestSettings: TeadsAdRequestSettings { settings in
            settings.pageUrl("https://www.teads.com")
        })
        // We use an observer to know when a rotation happened, to resize the ad
        // You can use whatever way you want to do so
        NotificationCenter.default.addObserver(self, selector: #selector(rotationDetected), name: UIDevice.orientationDidChangeNotification, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc func rotationDetected() {
        if let adRatio = adRatio {
            resizeTeadsAd(adRatio: adRatio)
        }
    }

    func resizeTeadsAd(adRatio: TeadsAdRatio) {
        self.adRatio = adRatio
        teadsAdHeightConstraint.constant = adRatio.calculateHeight(for: teadsAdView.frame.width)
    }

    func closeAd() {
        // be careful if you want to load another ad in the same page don't remove the observer
        NotificationCenter.default.removeObserver(self)
        teadsAdHeightConstraint.constant = 0
    }
}

extension InReadDirectScrollViewController: TeadsInReadAdPlacementDelegate {
    func adOpportunityTrackerView(trackerView: TeadsAdOpportunityTrackerView) {
        teadsAdView.addSubview(trackerView)
    }

    func didReceiveAd(ad: TeadsInReadAd, adRatio: TeadsAdRatio) {
        teadsAdView.bind(ad)
        ad.delegate = self
        resizeTeadsAd(adRatio: adRatio)
    }

    func didFailToReceiveAd(reason _: AdFailReason) {
        closeAd()
    }

    func didUpdateRatio(ad _: TeadsInReadAd, adRatio: TeadsAdRatio) {
        resizeTeadsAd(adRatio: adRatio)
    }
}

extension InReadDirectScrollViewController: TeadsAdDelegate {
    func willPresentModalView(ad _: TeadsAd) -> UIViewController? {
        return self
    }

    func didCatchError(ad _: TeadsAd, error _: Error) {
        closeAd()
    }

    func didClose(ad _: TeadsAd) {
        closeAd()
    }

    func didRecordImpression(ad _: TeadsAd) {}

    func didRecordClick(ad _: TeadsAd) {}

    func didExpandedToFullscreen(ad _: TeadsAd) {}

    func didCollapsedFromFullscreen(ad _: TeadsAd) {}
}
