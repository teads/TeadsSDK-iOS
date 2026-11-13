//
//  TeadsRecommendationsView.swift
//  TeadsSwiftUISampleApp
//
//  Copyright © 2026 Teads. All rights reserved.
//

import Combine
import SafariServices
import SwiftUI
import TeadsSDK
import WebKit

/// SwiftUI view for Recommendations placements, which return raw recommendation items
/// rather than a ready-made view. Handles the async load lifecycle and renders each
/// recommendation through a custom item builder.
struct TeadsRecommendationsView<ItemContent: View>: View {
    private let config: any TeadsAdPlacementRecommendationsConfig
    private let delegate: TeadsAdPlacementEventsDelegate?
    private let itemBuilder: (OBRecommendation, @escaping () -> Void) -> ItemContent

    @State private var placement: TeadsAdPlacementRecommendations?
    @State private var recommendations: [OBRecommendation] = []
    @State private var isLoading = true
    @State private var hasError = false
    @State private var errorMessage: String?
    @State private var destination: ClickDestination?

    init(
        config: any TeadsAdPlacementRecommendationsConfig,
        delegate: TeadsAdPlacementEventsDelegate? = nil,
        @ViewBuilder itemContent: @escaping (OBRecommendation, @escaping () -> Void) -> ItemContent
    ) {
        self.config = config
        self.delegate = delegate
        itemBuilder = itemContent
    }

    var body: some View {
        Group {
            if hasError {
                statusView(systemImage: "exclamationmark.triangle", title: "Failed to load recommendations", detail: errorMessage)
            } else if isLoading {
                VStack(spacing: 8) {
                    ProgressView()
                    Text("Loading recommendations…")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .onAppear { loadRecommendations() }
            } else if recommendations.isEmpty {
                statusView(systemImage: "doc.text", title: "No recommendations available", detail: nil)
            } else {
                VStack(spacing: 12) {
                    ForEach(recommendations, id: \.url) { recommendation in
                        itemBuilder(recommendation) {
                            handleClick(recommendation)
                        }
                    }
                }
            }
        }
        .sheet(item: $destination) { destination in
            switch destination {
            case let .paid(url):
                SafariView(url: url).ignoresSafeArea()
            case let .organic(url):
                ArticleWebView(url: url)
            }
        }
    }

    private func statusView(systemImage: String, title: String, detail: String?) -> some View {
        VStack(spacing: 8) {
            Image(systemName: systemImage)
                .foregroundStyle(.secondary)
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
            if let detail {
                Text(detail)
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
                    .multilineTextAlignment(.center)
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }

    private func loadRecommendations() {
        let placement = TeadsAdPlacementRecommendations(config, delegate: delegate)
        self.placement = placement
        placement.loadAd { response in
            DispatchQueue.main.async {
                isLoading = false
                if let error = response.error {
                    hasError = true
                    errorMessage = error.localizedDescription
                } else {
                    recommendations = response.recommendations
                }
            }
        }
    }

    private func handleClick(_ recommendation: OBRecommendation) {
        guard let placement else { return }
        // For organic links getUrl reports the click, so only call it after the tap
        guard let url = TeadsAdPlacementRecommendations.getUrl(recommendation) else { return }
        delegate?.adPlacement(placement, didEmitEvent: .clicked, data: ["url": url.absoluteString])

        // Paid: open in SFSafariViewController. Organic: open in the app.
        destination = recommendation.isPaidLink ? .paid(url) : .organic(url)
    }
}

private enum ClickDestination: Identifiable {
    case paid(URL)
    case organic(URL)

    var id: String {
        switch self {
        case let .paid(url): "paid-\(url.absoluteString)"
        case let .organic(url): "organic-\(url.absoluteString)"
        }
    }
}

private struct SafariView: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context _: Context) -> SFSafariViewController {
        SFSafariViewController(url: url)
    }

    func updateUIViewController(_: SFSafariViewController, context _: Context) {}
}

/// Minimal in-app screen for organic recommendations. Replace it with your own article screen.
private struct ArticleWebView: UIViewRepresentable {
    let url: URL

    func makeUIView(context _: Context) -> WKWebView {
        let webView = WKWebView()
        // Open the url as is, without any escaping or decoding
        webView.load(URLRequest(url: url))
        return webView
    }

    func updateUIView(_: WKWebView, context _: Context) {}
}

extension TeadsRecommendationsView where ItemContent == DefaultRecommendationItemContent {
    init(
        config: any TeadsAdPlacementRecommendationsConfig,
        delegate: TeadsAdPlacementEventsDelegate? = nil
    ) {
        self.init(config: config, delegate: delegate) { recommendation, onClick in
            DefaultRecommendationItemContent(recommendation: recommendation, onClick: onClick)
        }
    }
}

/// Default recommendation card. Publishers can supply their own item builder instead.
struct DefaultRecommendationItemContent: View {
    let recommendation: OBRecommendation
    let onClick: () -> Void

    var body: some View {
        Button {
            onClick()
        } label: {
            HStack(spacing: 12) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(.systemGray4))
                    .frame(width: 80, height: 60)
                    .overlay(Image(systemName: "photo").foregroundStyle(.secondary))

                VStack(alignment: .leading, spacing: 4) {
                    if let content = recommendation.content {
                        Text(content)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .lineLimit(2)
                            .foregroundStyle(.primary)
                    }
                    if let source = recommendation.source {
                        Text(source)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                Spacer()
            }
            .padding(12)
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color(.systemGray5), lineWidth: 1))
        }
        .buttonStyle(.plain)
    }
}
