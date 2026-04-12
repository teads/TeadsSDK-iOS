//
//  InterstitialAdmobViewController.swift
//  TeadsSampleApp
//
//  Copyright © 2026 Teads. All rights reserved.
//

import GoogleMobileAds
import UIKit

final class InterstitialAdmobViewController: TeadsViewController {
    private var interstitialAd: InterstitialAd?
    private var isContentUnlocked = false
    private var isWaitingForAd = false

    private let scrollView = UIScrollView()
    private let contentStack = UIStackView()
    private var paywallContainer: UIView?
    private var watchAdButton: UIButton?
    private var spinner: UIActivityIndicatorView?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadInterstitialAd()
    }

    // MARK: - UI Setup

    private func setupUI() {
        view.backgroundColor = .systemBackground

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        contentStack.axis = .vertical
        contentStack.spacing = 0
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentStack)

        setupConstraints()
        rebuildContent()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            contentStack.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])
    }

    private func rebuildContent() {
        contentStack.arrangedSubviews.forEach { $0.removeFromSuperview() }

        let titleLabel = UILabel()
        titleLabel.text = ArticleContent.title
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleLabel.numberOfLines = 0
        titleLabel.textColor = .label
        contentStack.addArrangedSubview(wrapWithPadding(titleLabel))

        let previewLabel = UILabel()
        previewLabel.text = ArticleContent.previewParagraph
        previewLabel.font = .systemFont(ofSize: 16)
        previewLabel.numberOfLines = 0
        previewLabel.textColor = .secondaryLabel
        contentStack.addArrangedSubview(wrapWithPadding(previewLabel))

        if isContentUnlocked {
            for paragraph in ArticleContent.lockedParagraphs {
                let label = UILabel()
                label.text = paragraph
                label.font = .systemFont(ofSize: 16)
                label.numberOfLines = 0
                label.textColor = .secondaryLabel
                contentStack.addArrangedSubview(wrapWithPadding(label))
            }
        } else {
            let paywall = buildPaywall()
            contentStack.addArrangedSubview(paywall)
            paywallContainer = paywall
        }
    }

    private func buildPaywall() -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false

        let fadedLabel = UILabel()
        fadedLabel.text = ArticleContent.lockedParagraphs.first
        fadedLabel.font = .systemFont(ofSize: 16)
        fadedLabel.numberOfLines = 4
        fadedLabel.textColor = .secondaryLabel
        fadedLabel.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(fadedLabel)

        let gradientContainer = GradientView()
        gradientContainer.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(gradientContainer)

        let card = UIView()
        card.backgroundColor = .secondarySystemBackground
        card.layer.cornerRadius = 12
        card.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        card.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(card)

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

        setupPaywallConstraints(container: container, fadedLabel: fadedLabel, gradient: gradientContainer, card: card, cardStack: cardStack)

        return container
    }

    private func setupPaywallConstraints(container: UIView, fadedLabel: UILabel, gradient: UIView, card: UIView, cardStack: UIStackView) {
        NSLayoutConstraint.activate([
            fadedLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 16),
            fadedLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            fadedLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),

            gradient.topAnchor.constraint(equalTo: fadedLabel.topAnchor),
            gradient.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            gradient.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            gradient.heightAnchor.constraint(equalToConstant: 100),

            card.topAnchor.constraint(equalTo: gradient.bottomAnchor),
            card.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            card.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            card.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            card.heightAnchor.constraint(greaterThanOrEqualToConstant: 200),

            cardStack.centerXAnchor.constraint(equalTo: card.centerXAnchor),
            cardStack.centerYAnchor.constraint(equalTo: card.centerYAnchor),
            cardStack.leadingAnchor.constraint(greaterThanOrEqualTo: card.leadingAnchor, constant: 24),
            cardStack.trailingAnchor.constraint(lessThanOrEqualTo: card.trailingAnchor, constant: -24),
        ])
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
            DispatchQueue.main.async {
                guard let self else { return }

                if let error {
                    print("Interstitial ad failed to load: \(error.localizedDescription)")
                    return
                }

                guard let ad else { return }

                ad.fullScreenContentDelegate = self
                self.interstitialAd = ad

                if self.isWaitingForAd {
                    self.presentInterstitial(ad)
                }
            }
        }
    }

    private func presentInterstitial(_ ad: InterstitialAd) {
        isWaitingForAd = false
        spinner?.stopAnimating()
        watchAdButton?.isHidden = false
        ad.present(from: self)
    }

    @objc private func watchAdTapped() {
        if let interstitialAd {
            presentInterstitial(interstitialAd)
        } else {
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

private final class GradientView: UIView {
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
