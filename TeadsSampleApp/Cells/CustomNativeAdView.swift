//
//  CustomNativeAdView.swift
//  demo
//
//  Created by Assistant on 13/08/2025.
//

import TeadsSDK
import UIKit

/// Factory for creating customized TeadsNativeAdView instances
@available(iOS 13.0, *)
class CustomNativeAdView {
    static func create() -> TeadsNativeAdView {
        let nativeAdView = TeadsNativeAdView(frame: .zero)
        setupCustomLayout(for: nativeAdView)
        return nativeAdView
    }

    private static func setupCustomLayout(for adView: TeadsNativeAdView) {
//        adView.translatesAutoresizingMaskIntoConstraints = false
        adView.backgroundColor = .systemBackground
        adView.layer.cornerRadius = 12
        adView.layer.borderWidth = 1
        adView.layer.borderColor = UIColor.systemGray4.cgColor

        // Add shadow
        adView.layer.shadowColor = UIColor.black.cgColor
        adView.layer.shadowOpacity = 0.1
        adView.layer.shadowOffset = CGSize(width: 0, height: 2)
        adView.layer.shadowRadius = 4

        // Create and configure UI components
        let containerStackView = createContainerStack()
        let headerStackView = createHeaderStack()
        let contentStackView = createContentStack()

        // Create native ad components
        let titleLabel = createTitleLabel()
        let contentLabel = createContentLabel()
        let mediaView = createMediaView()
        let iconImageView = createIconImageView()
        let advertiserLabel = createAdvertiserLabel()
        let callToActionButton = createCallToActionButton()
        let sponsoredLabel = createSponsoredLabel()

        // Connect outlets
        adView.titleLabel = titleLabel
        adView.contentLabel = contentLabel
        adView.mediaView = mediaView
        adView.iconImageView = iconImageView
        adView.advertiserLabel = advertiserLabel
        adView.callToActionButton = callToActionButton

        // Setup hierarchy
        adView.addSubview(containerStackView)

        // Header with icon and advertiser
        headerStackView.addArrangedSubview(iconImageView)
        headerStackView.addArrangedSubview(advertiserLabel)
        headerStackView.addArrangedSubview(UIView()) // Spacer
        headerStackView.addArrangedSubview(sponsoredLabel)

        // Content section
        contentStackView.addArrangedSubview(titleLabel)
        contentStackView.addArrangedSubview(contentLabel)
        contentStackView.addArrangedSubview(mediaView)
        contentStackView.addArrangedSubview(callToActionButton)

        // Main container
        containerStackView.addArrangedSubview(headerStackView)
        containerStackView.addArrangedSubview(contentStackView)

        // Setup constraints
        setupConstraints(
            containerStackView: containerStackView,
            iconImageView: iconImageView,
            mediaView: mediaView,
            sponsoredLabel: sponsoredLabel,
            callToActionButton: callToActionButton,
            adView: adView
        )
    }

    // MARK: - Component Factories

    private static func createContainerStack() -> UIStackView {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12
        stack.distribution = .fill
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }

    private static func createHeaderStack() -> UIStackView {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center
        stack.distribution = .fill
        return stack
    }

    private static func createContentStack() -> UIStackView {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 8
        stack.distribution = .fill
        stack.alignment = .fill
        return stack
    }

    private static func createTitleLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .label
        label.numberOfLines = 2
        return label
    }

    private static func createContentLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.numberOfLines = 3
        return label
    }

    private static func createMediaView() -> TeadsMediaView {
        let mediaView = TeadsMediaView()
        mediaView.translatesAutoresizingMaskIntoConstraints = false
        mediaView.contentMode = .scaleAspectFill
        mediaView.clipsToBounds = true
        mediaView.layer.cornerRadius = 8
        mediaView.backgroundColor = .systemGray5
        return mediaView
    }

    private static func createIconImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16
        imageView.backgroundColor = .systemGray4
        return imageView
    }

    private static func createAdvertiserLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .tertiaryLabel
        label.numberOfLines = 1
        return label
    }

    private static func createCallToActionButton() -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 6
        return button
    }

    private static func createSponsoredLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Sponsored"
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = .tertiaryLabel
        label.backgroundColor = .systemGray6
        label.textAlignment = .center
        label.layer.cornerRadius = 4
        label.clipsToBounds = true
        return label
    }

    // MARK: - Constraints

    private static func setupConstraints(
        containerStackView: UIStackView,
        iconImageView: UIImageView,
        mediaView: TeadsMediaView,
        sponsoredLabel: UILabel,
        callToActionButton: UIButton,
        adView: TeadsNativeAdView
    ) {
        NSLayoutConstraint.activate([
            // Container
            containerStackView.topAnchor.constraint(equalTo: adView.topAnchor, constant: 12),
            containerStackView.leadingAnchor.constraint(
                equalTo: adView.leadingAnchor, constant: 12
            ),
            containerStackView.trailingAnchor.constraint(
                equalTo: adView.trailingAnchor, constant: -12
            ),
            containerStackView.bottomAnchor.constraint(equalTo: adView.bottomAnchor, constant: -12),

            // Icon
            iconImageView.widthAnchor.constraint(equalToConstant: 32),
            iconImageView.heightAnchor.constraint(equalToConstant: 32),

            // Media view
            mediaView.heightAnchor.constraint(equalToConstant: 160),

            // Sponsored label
            sponsoredLabel.widthAnchor.constraint(equalToConstant: 70),
            sponsoredLabel.heightAnchor.constraint(equalToConstant: 18),

            // CTA button
            callToActionButton.heightAnchor.constraint(equalToConstant: 36),
        ])
    }
}
