//
//  InterstitialAdmobViewController.swift
//  TeadsSampleApp
//
//  Copyright © 2026 Teads. All rights reserved.
//

import GoogleMobileAds
import UIKit

class InterstitialAdmobViewController: TeadsViewController {
    private var interstitialAd: InterstitialAd?
    private var isContentUnlocked = false
    private var isWaitingForAd = false

    private let scrollView = UIScrollView()
    private let contentStack = UIStackView()
    private var paywallContainer: UIView?
    private var watchAdButton: UIButton?
    private var spinner: UIActivityIndicatorView?

    // Article paragraphs
    private let articleTitle = "The Future of Digital Advertising"
    private let previewParagraph = """
    The digital advertising landscape is undergoing a profound transformation. \
    As privacy regulations tighten and third-party cookies phase out, publishers \
    and advertisers are rethinking how they connect with audiences. New formats \
    like interstitial ads offer immersive, full-screen experiences that capture \
    attention while respecting user choice.
    """
    private let lockedParagraphs = [
        """
        Interstitial ads have emerged as one of the most effective ad formats for mobile apps. \
        Unlike banner ads that compete for attention within a crowded interface, interstitials \
        command the full screen, delivering higher engagement rates and better brand recall. \
        Publishers who integrate interstitials at natural transition points — between articles, \
        levels, or content sections — see significantly improved monetization without sacrificing \
        user experience.
        """,
        """
        The key to successful interstitial implementation lies in timing and relevance. \
        Ads shown at natural content breaks feel less intrusive than those interrupting \
        active engagement. Combined with server-side optimization for ad quality and \
        frequency capping, interstitials can achieve the delicate balance between revenue \
        generation and user satisfaction that every publisher seeks.
        """,
        """
        Looking ahead, the convergence of contextual targeting, first-party data, and \
        premium ad formats like interstitials will define the next era of digital advertising. \
        Publishers who invest in these capabilities today will be best positioned to thrive \
        in a privacy-first world where user trust is the ultimate currency.
        """,
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        loadInterstitialAd()
    }

    // MARK: - UI Setup

    private func setupUI() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

        contentStack.axis = .vertical
        contentStack.spacing = 0
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentStack)
        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])

        rebuildContent()
    }

    private func rebuildContent() {
        contentStack.arrangedSubviews.forEach { $0.removeFromSuperview() }

        // Title
        let titleLabel = UILabel()
        titleLabel.text = articleTitle
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleLabel.numberOfLines = 0
        titleLabel.textColor = .label
        let titleWrapper = wrapWithPadding(titleLabel)
        contentStack.addArrangedSubview(titleWrapper)

        // Preview paragraph
        let previewLabel = UILabel()
        previewLabel.text = previewParagraph
        previewLabel.font = .systemFont(ofSize: 16)
        previewLabel.numberOfLines = 0
        previewLabel.textColor = .secondaryLabel
        let previewWrapper = wrapWithPadding(previewLabel)
        contentStack.addArrangedSubview(previewWrapper)

        if isContentUnlocked {
            // Show all locked paragraphs
            for paragraph in lockedParagraphs {
                let label = UILabel()
                label.text = paragraph
                label.font = .systemFont(ofSize: 16)
                label.numberOfLines = 0
                label.textColor = .secondaryLabel
                let wrapper = wrapWithPadding(label)
                contentStack.addArrangedSubview(wrapper)
            }
        } else {
            // Paywall overlay
            let paywall = buildPaywall()
            contentStack.addArrangedSubview(paywall)
            paywallContainer = paywall
        }
    }

    private func buildPaywall() -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false

        // Faded preview text
        let fadedLabel = UILabel()
        fadedLabel.text = lockedParagraphs.first
        fadedLabel.font = .systemFont(ofSize: 16)
        fadedLabel.numberOfLines = 4
        fadedLabel.textColor = .secondaryLabel
        fadedLabel.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(fadedLabel)

        // Gradient overlay
        let gradientContainer = GradientView()
        gradientContainer.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(gradientContainer)

        // Paywall card
        let card = UIView()
        card.backgroundColor = .secondarySystemBackground
        card.layer.cornerRadius = 12
        card.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        card.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(card)

        // Card content
        let cardStack = UIStackView()
        cardStack.axis = .vertical
        cardStack.alignment = .center
        cardStack.spacing = 12
        cardStack.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(cardStack)

        let premiumLabel = UILabel()
        premiumLabel.text = "Premium Content"
        premiumLabel.font = .systemFont(ofSize: 18, weight: .bold)
        premiumLabel.textColor = .label
        cardStack.addArrangedSubview(premiumLabel)

        let descLabel = UILabel()
        descLabel.text = "Watch an ad to read the rest of the article"
        descLabel.font = .systemFont(ofSize: 14)
        descLabel.textColor = .secondaryLabel
        descLabel.textAlignment = .center
        descLabel.numberOfLines = 0
        cardStack.addArrangedSubview(descLabel)

        let button = UIButton(type: .system)
        button.setTitle("Watch Ad", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.contentEdgeInsets = UIEdgeInsets(top: 12, left: 32, bottom: 12, right: 32)
        button.addTarget(self, action: #selector(watchAdTapped), for: .touchUpInside)
        cardStack.addArrangedSubview(button)
        watchAdButton = button

        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.hidesWhenStopped = true
        cardStack.addArrangedSubview(activityIndicator)
        spinner = activityIndicator

        // Layout
        NSLayoutConstraint.activate([
            fadedLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 16),
            fadedLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            fadedLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),

            gradientContainer.topAnchor.constraint(equalTo: fadedLabel.topAnchor),
            gradientContainer.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            gradientContainer.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            gradientContainer.heightAnchor.constraint(equalToConstant: 100),

            card.topAnchor.constraint(equalTo: gradientContainer.bottomAnchor),
            card.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            card.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            card.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            card.heightAnchor.constraint(greaterThanOrEqualToConstant: 200),

            cardStack.centerXAnchor.constraint(equalTo: card.centerXAnchor),
            cardStack.centerYAnchor.constraint(equalTo: card.centerYAnchor),
            cardStack.leadingAnchor.constraint(greaterThanOrEqualTo: card.leadingAnchor, constant: 24),
            cardStack.trailingAnchor.constraint(lessThanOrEqualTo: card.trailingAnchor, constant: -24),
        ])

        return container
    }

    private func wrapWithPadding(_ view: UIView) -> UIView {
        let wrapper = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        wrapper.addSubview(view)
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: wrapper.topAnchor, constant: 8),
            view.leadingAnchor.constraint(equalTo: wrapper.leadingAnchor, constant: 16),
            view.trailingAnchor.constraint(equalTo: wrapper.trailingAnchor, constant: -16),
            view.bottomAnchor.constraint(equalTo: wrapper.bottomAnchor, constant: -8),
        ])
        return wrapper
    }

    // MARK: - Ad Loading

    private func loadInterstitialAd() {
        let request = Request()

        InterstitialAd.load(with: pid, request: request) { [weak self] ad, error in
            guard let self else { return }

            if let error {
                print("Interstitial ad failed to load: \(error.localizedDescription)")
                return
            }

            guard let ad else { return }

            ad.fullScreenContentDelegate = self
            self.interstitialAd = ad

            // If user already tapped "Watch Ad", show immediately
            if self.isWaitingForAd {
                self.presentInterstitial()
            }
        }
    }

    private func presentInterstitial() {
        guard let interstitialAd else { return }
        isWaitingForAd = false
        spinner?.stopAnimating()
        watchAdButton?.isHidden = false
        interstitialAd.present(from: self)
    }

    @objc private func watchAdTapped() {
        if let interstitialAd {
            interstitialAd.present(from: self)
        } else {
            // Ad still loading — show spinner and wait
            isWaitingForAd = true
            watchAdButton?.isHidden = true
            spinner?.startAnimating()
        }
    }

    private func unlockContent() {
        isContentUnlocked = true
        interstitialAd = nil
        rebuildContent()
    }
}

// MARK: - FullScreenContentDelegate

extension InterstitialAdmobViewController: FullScreenContentDelegate {
    func adDidDismissFullScreenContent(_: FullScreenPresentingAd) {
        unlockContent()
    }

    func ad(_: FullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("Interstitial failed to present: \(error.localizedDescription)")
        interstitialAd = nil
        unlockContent()
    }

    func adDidRecordImpression(_: FullScreenPresentingAd) {
        print("Interstitial: impression recorded")
    }

    func adDidRecordClick(_: FullScreenPresentingAd) {
        print("Interstitial: click recorded")
    }
}

// MARK: - Gradient View

private class GradientView: UIView {
    override class var layerClass: AnyClass { CAGradientLayer.self }

    override func layoutSubviews() {
        super.layoutSubviews()
        guard let gradient = layer as? CAGradientLayer else { return }
        gradient.colors = [
            UIColor.systemBackground.withAlphaComponent(0).cgColor,
            UIColor.systemBackground.cgColor,
        ]
        gradient.startPoint = CGPoint(x: 0.5, y: 0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1)
    }
}
