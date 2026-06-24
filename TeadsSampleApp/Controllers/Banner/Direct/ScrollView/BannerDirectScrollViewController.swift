//
//  BannerDirectScrollViewController.swift
//  TeadsSampleApp
//
//  Copyright © 2026 Teads. All rights reserved.
//

import TeadsSDK
import UIKit

/// Direct Banner placement hosted in a scrolling article.
class BannerDirectViewController: TeadsViewController {
    fileprivate let adContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private var adHeightConstraint: NSLayoutConstraint?
    private var placement: TeadsAdPlacementBanner?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Banner — Direct"
        view.backgroundColor = .systemBackground
        setupScrollArticle()
        loadBanner()
    }

    private func setupScrollArticle() {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        let stack = UIStackView(arrangedSubviews: [
            SampleArticleViews.headerImageView(),
            SampleArticleViews.titleLabel("The Future of Digital Advertising"),
            SampleArticleViews.paragraphLabel(),
            adContainer,
            SampleArticleViews.paragraphLabel(),
            SampleArticleViews.paragraphLabel(),
        ])
        stack.axis = .vertical
        stack.spacing = 16
        stack.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16)
        stack.isLayoutMarginsRelativeArrangement = true
        stack.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stack)

        adHeightConstraint = adContainer.heightAnchor.constraint(equalToConstant: 250)
        adHeightConstraint?.isActive = true

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            stack.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stack.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])
    }

    private func loadBanner() {
        let config = TeadsAdPlacementBannerConfig(
            articleUrl: URL(string: PID.outbrainArticleUrl)!,
            widgetId: PID.bannerWidgetId,
            installationKey: PID.outbrainInstallationKey,
            widgetIndex: 0
        )
        placement = Teads.createPlacement(with: config, delegate: self)
        guard let adView = try? placement?.loadAd() else { return }
        adView.translatesAutoresizingMaskIntoConstraints = false
        adContainer.addSubview(adView)
        NSLayoutConstraint.activate([
            adView.topAnchor.constraint(equalTo: adContainer.topAnchor),
            adView.leadingAnchor.constraint(equalTo: adContainer.leadingAnchor),
            adView.trailingAnchor.constraint(equalTo: adContainer.trailingAnchor),
            adView.bottomAnchor.constraint(equalTo: adContainer.bottomAnchor),
        ])
    }

    fileprivate func updateAdHeight(_ height: CGFloat) {
        adHeightConstraint?.constant = height
        UIView.animate(withDuration: 0.3) { self.view.layoutIfNeeded() }
    }
}

extension BannerDirectViewController: TeadsAdPlacementEventsDelegate {
    func adPlacement(_: TeadsAdPlacementIdentifiable?, didEmitEvent event: TeadsAdPlacementEventName, data: [String: Any]?) {
        if event == .heightUpdated, let height = data?["height"] as? CGFloat {
            updateAdHeight(height)
        }
    }
}

/// Concrete entry used by the catalogue router.
final class BannerDirectScrollViewController: BannerDirectViewController {}
