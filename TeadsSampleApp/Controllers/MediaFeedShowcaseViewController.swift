//
//  MediaFeedShowcaseViewController.swift
//  TeadsSampleApp
//
//  Created by AI Assistant on 09/10/2025.
//  Copyright © 2025 Teads. All rights reserved.
//
//  This showcase demonstrates the integration of both Media Placement (video ads)
//  and Feed Placement (content recommendations) in a single view, following
//  the official Teads SDK documentation patterns.
//

import TeadsSDK
import UIKit

/// Showcase controller demonstrating Media + Feed placement integration
class MediaFeedShowcaseViewController: TeadsViewController {
    // MARK: - UI Components

    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()

    private let contentStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    // Article content
    private let headerImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .systemBlue
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Media + Feed Placement Showcase"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.numberOfLines = 0
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = """
        This example demonstrates the integration of both Media Placement (video ads) \
        and Feed Placement (content recommendations) following Teads SDK best practices.
        """
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.textColor = .secondaryLabel
        return label
    }()

    // Media Placement Container
    private let mediaPlacementContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private var mediaHeightConstraint: NSLayoutConstraint?

    // Feed Placement Container
    private let feedPlacementContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Placements

    private var mediaPlacement: TeadsAdPlacementMedia?
    private var feedPlacement: TeadsAdPlacementFeed?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Media + Feed Showcase"
        view.backgroundColor = .systemBackground

        setupUI()
        setupPlacements()
    }

    // MARK: - Setup

    private func setupUI() {
        // Add scroll view
        view.addSubview(scrollView)
        scrollView.addSubview(contentStackView)

        // Header image
        contentStackView.addArrangedSubview(headerImageView)

        // Content container
        let contentContainer = UIView()
        let contentStack = UIStackView(arrangedSubviews: [
            titleLabel,
            descriptionLabel,
            createArticleParagraph(),
            createSectionHeader("Media Placement (Video Ad)"),
            mediaPlacementContainer,
            createArticleParagraph(),
            createArticleParagraph(),
            createSectionHeader("Feed Placement (Content Recommendations)"),
            feedPlacementContainer,
        ])
        contentStack.axis = .vertical
        contentStack.spacing = 16
        contentStack.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        contentStack.isLayoutMarginsRelativeArrangement = true

        contentContainer.addSubview(contentStack)
        contentStack.translatesAutoresizingMaskIntoConstraints = false

        contentStackView.addArrangedSubview(contentContainer)

        // Constraints
        NSLayoutConstraint.activate([
            // ScrollView
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            // Content Stack
            contentStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            // Header image
            headerImageView.heightAnchor.constraint(equalToConstant: 200),

            // Content stack
            contentStack.topAnchor.constraint(equalTo: contentContainer.topAnchor),
            contentStack.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor),
            contentStack.bottomAnchor.constraint(equalTo: contentContainer.bottomAnchor),

            // Media container
            mediaPlacementContainer.heightAnchor.constraint(greaterThanOrEqualToConstant: 100),

            // Feed container
            feedPlacementContainer.heightAnchor.constraint(greaterThanOrEqualToConstant: 200),
        ])

        // Store media height constraint for dynamic updates
        mediaHeightConstraint = mediaPlacementContainer.heightAnchor.constraint(equalToConstant: 300)
        mediaHeightConstraint?.isActive = true
    }

    private func setupPlacements() {
        setupMediaPlacement()
        setupFeedPlacement()
    }

    // MARK: - Media Placement Setup

    private func setupMediaPlacement() {
        // Create Media Placement configuration
        // Using test PID 84242 (Direct Landscape)
        let mediaConfig = TeadsAdPlacementMediaConfig(
            pid: 84242,
            articleUrl: URL(string: "https://www.teads.com")!,
            enableValidationMode: validationModeEnabled
        )

        // Create placement using unified API
        mediaPlacement = Teads.createPlacement(with: mediaConfig, delegate: self)

        // Load ad and add to container
        if let adView = try? mediaPlacement?.loadAd() {
            adView.translatesAutoresizingMaskIntoConstraints = false
            mediaPlacementContainer.addSubview(adView)

            NSLayoutConstraint.activate([
                adView.topAnchor.constraint(equalTo: mediaPlacementContainer.topAnchor),
                adView.leadingAnchor.constraint(equalTo: mediaPlacementContainer.leadingAnchor),
                adView.trailingAnchor.constraint(equalTo: mediaPlacementContainer.trailingAnchor),
                adView.bottomAnchor.constraint(equalTo: mediaPlacementContainer.bottomAnchor),
            ])
        }
    }

    // MARK: - Feed Placement Setup

    private func setupFeedPlacement() {
        // Create Feed Placement configuration
        // Using test Widget ID MB_2 and Installation Key NANOWDGT01
        let feedConfig = TeadsAdPlacementFeedConfig(
            articleUrl: URL(string: "https://mobile-demo.outbrain.com")!,
            widgetId: "MB_2",
            installationKey: "NANOWDGT01",
            widgetIndex: 0
        )

        // Create placement using unified API
        feedPlacement = Teads.createPlacement(with: feedConfig, delegate: self)

        // Load feed widget and add to container
        if let feedView = try? feedPlacement?.loadAd() {
            feedView.translatesAutoresizingMaskIntoConstraints = false
            feedPlacementContainer.addSubview(feedView)

            NSLayoutConstraint.activate([
                feedView.topAnchor.constraint(equalTo: feedPlacementContainer.topAnchor, constant: 8),
                feedView.leadingAnchor.constraint(equalTo: feedPlacementContainer.leadingAnchor, constant: 8),
                feedView.trailingAnchor.constraint(equalTo: feedPlacementContainer.trailingAnchor, constant: -8),
                feedView.bottomAnchor.constraint(equalTo: feedPlacementContainer.bottomAnchor, constant: -8),
            ])
        }
    }

    // MARK: - Helper Methods

    private func createSectionHeader(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .label
        return label
    }

    private func createArticleParagraph() -> UILabel {
        let label = UILabel()
        label.text = """
        Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt \
        ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco \
        laboris nisi ut aliquip ex ea commodo consequat.
        """
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.textColor = .label
        return label
    }
}

// MARK: - TeadsAdPlacementEventsDelegate

extension MediaFeedShowcaseViewController: TeadsAdPlacementEventsDelegate {
    func adPlacement(
        _ placementId: TeadsAdPlacementIdentifiable?,
        didEmitEvent event: TeadsAdPlacementEventName,
        data: [String: Any]?
    ) {
        // Determine which placement triggered the event
        let placementType: String
        if placementId?.placementId == mediaPlacement?.placementId {
            placementType = "Media"
        } else if placementId?.placementId == feedPlacement?.placementId {
            placementType = "Feed"
        } else {
            placementType = "Unknown"
        }

        switch event {
            case .ready:
                print("[\(placementType)] Ad ready")

            case .rendered:
                print("[\(placementType)] Ad rendered")

            case .heightUpdated:
                if let height = data?["height"] as? CGFloat,
                   placementId?.placementId == mediaPlacement?.placementId {
                    // Update media container height
                    mediaHeightConstraint?.constant = height
                    UIView.animate(withDuration: 0.3) {
                        self.view.layoutIfNeeded()
                    }
                }

            case .viewed:
                print("[\(placementType)] Ad viewed (impression)")

            case .clicked:
                print("[\(placementType)] Ad clicked")

            case .failed:
                print("[\(placementType)] Ad failed: \(data?["reason"] ?? "Unknown")")

            case .play:
                print("[\(placementType)] Video play")

            case .pause:
                print("[\(placementType)] Video pause")

            case .complete:
                print("[\(placementType)] Video complete")

            default:
                break
        }
    }
}
