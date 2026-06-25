//
//  BannerDirectScrollViewController.swift
//  TeadsSampleApp
//
//  Copyright © 2026 Teads. All rights reserved.
//

import TeadsSDK
import UIKit

/// Direct Banner placement anchored to the bottom of the screen over a scrolling article.
class BannerDirectViewController: TeadsViewController {
    private let scrollView = UIScrollView()
    private var placement: TeadsAdPlacementBanner?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Banner — Direct"
        view.backgroundColor = .systemBackground
        setupScrollArticle()
        loadBanner()
    }

    private func setupScrollArticle() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        let stack = UIStackView(arrangedSubviews: [
            SampleArticleViews.headerImageView(),
            SampleArticleViews.titleLabel("The Future of Digital Advertising"),
            SampleArticleViews.paragraphLabel(),
            SampleArticleViews.paragraphLabel(),
            SampleArticleViews.titleLabel("Why Outstream Wins"),
            SampleArticleViews.paragraphLabel(),
            SampleArticleViews.paragraphLabel(),
            SampleArticleViews.paragraphLabel(),
            SampleArticleViews.titleLabel("Looking Ahead"),
            SampleArticleViews.paragraphLabel(),
            SampleArticleViews.paragraphLabel(),
        ])
        stack.axis = .vertical
        stack.spacing = 16
        stack.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16)
        stack.isLayoutMarginsRelativeArrangement = true
        stack.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stack)

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
        adView.backgroundColor = .systemBackground
        view.addSubview(adView)
        NSLayoutConstraint.activate([
            adView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            adView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            adView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}

extension BannerDirectViewController: TeadsAdPlacementEventsDelegate {
    func adPlacement(_: TeadsAdPlacementIdentifiable?, didEmitEvent event: TeadsAdPlacementEventName, data: [String: Any]?) {
        guard event == .heightUpdated, let height = data?["height"] as? CGFloat else { return }
        // Reserve room so the last content clears the anchored banner.
        scrollView.contentInset.bottom = height + 16
        scrollView.verticalScrollIndicatorInsets.bottom = height + 16
    }
}

/// Concrete entry used by the catalogue router.
final class BannerDirectScrollViewController: BannerDirectViewController {}
