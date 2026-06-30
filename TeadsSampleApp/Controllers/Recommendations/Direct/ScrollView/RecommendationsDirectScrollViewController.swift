//
//  RecommendationsDirectScrollViewController.swift
//  TeadsSampleApp
//
//  Copyright © 2026 Teads. All rights reserved.
//

import TeadsSDK
import UIKit

/// Direct Recommendations placement. The SDK returns recommendation items, so the
/// publisher renders the UI — here as a vertical stack of cards inside an article.
class RecommendationsDirectScrollViewController: TeadsViewController {
    private let recommendationsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12
        return stack
    }()

    private var placement: TeadsAdPlacementRecommendations?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Recommendations — Direct"
        view.backgroundColor = .systemBackground
        setupScrollArticle()
        loadRecommendations()
    }

    private func setupScrollArticle() {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        let header = SampleArticleViews.titleLabel("You may also like")
        let stack = UIStackView(arrangedSubviews: [
            SampleArticleViews.headerImageView(),
            SampleArticleViews.titleLabel("The Future of Digital Advertising"),
            SampleArticleViews.paragraphLabel(),
            header,
            recommendationsStack,
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

    private func loadRecommendations() {
        let config = TeadsAdPlacementRecommendationsURLConfig(
            articleUrl: URL(string: PID.outbrainArticleUrl)!,
            widgetId: PID.recommendationsWidgetId
        )
        let placement = TeadsAdPlacementRecommendations(config, delegate: self)
        self.placement = placement
        placement.loadAd { [weak self] response in
            DispatchQueue.main.async {
                guard let self else { return }
                if response.error != nil { return }
                for recommendation in response.recommendations {
                    self.recommendationsStack.addArrangedSubview(RecommendationCardView(recommendation: recommendation) { [weak self] url in
                        self?.handleClick(url: url, recommendation: recommendation)
                    })
                }
            }
        }
    }

    private func handleClick(url: URL?, recommendation _: OBRecommendation) {
        guard let url else { return }
        UIApplication.shared.open(url)
    }
}

extension RecommendationsDirectScrollViewController: TeadsAdPlacementEventsDelegate {
    func adPlacement(_: TeadsAdPlacementIdentifiable?, didEmitEvent _: TeadsAdPlacementEventName, data _: [String: Any]?) {}
}

/// Simple recommendation card. Publishers can style this however they like.
final class RecommendationCardView: UIView {
    private let onTap: (URL?) -> Void
    private let recommendation: OBRecommendation

    init(recommendation: OBRecommendation, onTap: @escaping (URL?) -> Void) {
        self.recommendation = recommendation
        self.onTap = onTap
        super.init(frame: .zero)
        setup()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) { fatalError("init(coder:) is not supported") }

    private func setup() {
        layer.cornerRadius = 12
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemGray5.cgColor

        let thumbnail = UIView()
        thumbnail.backgroundColor = .systemGray4
        thumbnail.layer.cornerRadius = 8
        thumbnail.translatesAutoresizingMaskIntoConstraints = false
        thumbnail.widthAnchor.constraint(equalToConstant: 80).isActive = true
        thumbnail.heightAnchor.constraint(equalToConstant: 60).isActive = true

        let titleLabel = UILabel()
        titleLabel.text = recommendation.content
        titleLabel.font = .systemFont(ofSize: 15, weight: .medium)
        titleLabel.numberOfLines = 2

        let sourceLabel = UILabel()
        sourceLabel.text = recommendation.source
        sourceLabel.font = .systemFont(ofSize: 12)
        sourceLabel.textColor = .secondaryLabel

        let textStack = UIStackView(arrangedSubviews: [titleLabel, sourceLabel])
        textStack.axis = .vertical
        textStack.spacing = 4

        let stack = UIStackView(arrangedSubviews: [thumbnail, textStack])
        stack.axis = .horizontal
        stack.spacing = 12
        stack.alignment = .center
        stack.layoutMargins = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        stack.isLayoutMarginsRelativeArrangement = true
        stack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])

        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapped)))
    }

    @objc private func tapped() {
        onTap(recommendation.url.flatMap { URL(string: $0) })
    }
}
