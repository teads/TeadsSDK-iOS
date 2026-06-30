//
//  InterstitialDirectViewController.swift
//  TeadsSampleApp
//
//  Copyright © 2026 Teads. All rights reserved.
//

import TeadsSDK
import UIKit

/// Direct Interstitial placement gated behind a "Watch Ad" paywall.
class InterstitialDirectViewController: TeadsViewController {
    private let watchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Watch Ad", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.contentEdgeInsets = UIEdgeInsets(top: 12, left: 32, bottom: 12, right: 32)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let spinner = UIActivityIndicatorView(style: .medium)
    private let lockedStack = UIStackView()

    private var placement: TeadsAdPlacementInterstitial?
    private var isReady = false
    private var isWaitingForAd = false

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Interstitial — Direct"
        view.backgroundColor = .systemBackground
        setupUI()
        loadInterstitial()
    }

    private func setupUI() {
        let title = SampleArticleViews.titleLabel("The Future of Digital Advertising")
        let preview = SampleArticleViews.paragraphLabel()

        let premiumTitle = UILabel()
        premiumTitle.text = "Premium Content"
        premiumTitle.font = .systemFont(ofSize: 18, weight: .bold)
        premiumTitle.textAlignment = .center

        let premiumSubtitle = UILabel()
        premiumSubtitle.text = "Watch an ad to read the rest of the article"
        premiumSubtitle.font = .systemFont(ofSize: 14)
        premiumSubtitle.textColor = .secondaryLabel
        premiumSubtitle.numberOfLines = 0
        premiumSubtitle.textAlignment = .center

        watchButton.addTarget(self, action: #selector(watchTapped), for: .touchUpInside)

        lockedStack.axis = .vertical
        lockedStack.spacing = 12
        lockedStack.alignment = .center
        lockedStack.layoutMargins = UIEdgeInsets(top: 24, left: 24, bottom: 24, right: 24)
        lockedStack.isLayoutMarginsRelativeArrangement = true
        lockedStack.addArrangedSubview(premiumTitle)
        lockedStack.addArrangedSubview(premiumSubtitle)
        lockedStack.addArrangedSubview(watchButton)
        lockedStack.addArrangedSubview(spinner)
        spinner.isHidden = true
        lockedStack.backgroundColor = .secondarySystemBackground
        lockedStack.layer.cornerRadius = 12

        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        let stack = UIStackView(arrangedSubviews: [title, preview, lockedStack])
        stack.axis = .vertical
        stack.spacing = 16
        stack.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
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

    private func loadInterstitial() {
        let config = TeadsAdPlacementInterstitialConfig(
            articleUrl: URL(string: PID.interstitialDirectArticleUrl)!,
            widgetId: PID.interstitialDirectWidgetId,
            installationKey: PID.outbrainInstallationKey
        )
        let placement = TeadsAdPlacementInterstitial(config, delegate: self)
        self.placement = placement
        placement.loadAd()
    }

    @objc private func watchTapped() {
        if isReady {
            present()
        } else {
            isWaitingForAd = true
            watchButton.isHidden = true
            spinner.isHidden = false
            spinner.startAnimating()
        }
    }

    private func present() {
        isWaitingForAd = false
        guard let placement, placement.isReady else { return }
        placement.show(from: self)
    }

    private func unlockContent() {
        spinner.stopAnimating()
        lockedStack.isHidden = true
    }
}

extension InterstitialDirectViewController: TeadsFullScreenEventsDelegate {
    func adPlacement(_: TeadsAdPlacementIdentifiable?, didEmitEvent event: TeadsAdPlacementEventName, data: [String: Any]?) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            switch event {
                case .ready:
                    self.isReady = true
                    if self.isWaitingForAd { self.present() }
                case .failed:
                    print("Direct interstitial failed: \(data?["reason"] as? String ?? "unknown")")
                    self.unlockContent()
                default:
                    break
            }
        }
    }

    func fullScreenPlacement(_: TeadsAdPlacementIdentifiable?, didEmitEvent event: TeadsFullScreenEventName, data _: [String: Any]?) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            if event == .dismissed {
                self.placement?.invalidate()
                self.placement = nil
                self.unlockContent()
            }
        }
    }
}
