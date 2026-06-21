//
//  RootCatalogView.swift
//  TeadsSwiftUISampleApp
//
//  Copyright © 2026 Teads. All rights reserved.
//

import SwiftUI

/// Entry screen — the SwiftUI port of the UIKit `RootViewController` catalogue:
/// Formats / Providers / Creatives / Integrations + Showcase + Settings, branded nav bar.
struct RootCatalogView: View {
    @StateObject private var viewModel = CatalogViewModel()
    @State private var showShowcase = false

    private let integrationColumns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16),
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    formatsSection
                    providersSection
                    if viewModel.showsCreatives {
                        creativesSection
                    }
                    integrationsSection
                    showcaseSection
                    settingsSection
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 32)
            }
            .background(Color.appBackground)
            .navigationBarTitleDisplayMode(.inline)
            .teadsBrandNavigationBar()
            .customPIDAlert(isPresented: $viewModel.isCustomPIDAlertPresented)
            .alert(
                "Coming soon",
                isPresented: Binding(
                    get: { viewModel.comingSoonMessage != nil },
                    set: { if !$0 { viewModel.comingSoonMessage = nil } }
                )
            ) {
                Button("OK") { viewModel.comingSoonMessage = nil }
            } message: {
                Text(viewModel.comingSoonMessage ?? "")
            }
            .navigationDestination(isPresented: $showShowcase) {
                MediaFeedShowcaseSample(validationMode: viewModel.validationModeEnabled)
            }
        }
    }

    // MARK: Sections

    private var formatsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            RootSectionHeader("Formats")
            HStack(spacing: 4) {
                ForEach(SampleFormat.allCases) { format in
                    RootPillButton(
                        title: format.displayName,
                        isSelected: viewModel.format == format
                    ) {
                        viewModel.selectFormat(format)
                    }
                }
            }
        }
    }

    private var providersSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            RootSectionHeader("Providers")
            FlowHStack(spacing: 4) {
                ForEach(viewModel.availableProviders) { provider in
                    RootPillButton(
                        title: provider.displayName,
                        isSelected: viewModel.provider == provider
                    ) {
                        viewModel.selectProvider(provider)
                    }
                    .fixedSize()
                }
            }
        }
    }

    private var creativesSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            RootSectionHeader("Creatives")
            FlowHStack(spacing: 4) {
                ForEach(viewModel.availableCreatives) { creative in
                    RootPillButton(
                        title: creative.displayName,
                        isSelected: viewModel.creative == creative
                    ) {
                        viewModel.selectCreative(creative)
                    }
                    .fixedSize()
                }
            }
        }
    }

    private var integrationsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            RootSectionHeader("Integrations")
            LazyVGrid(columns: integrationColumns, spacing: 16) {
                ForEach(viewModel.availableIntegrations) { integration in
                    NavigationLink {
                        SampleDestinationFactory.destination(
                            for: viewModel.selection(for: integration),
                            validationMode: viewModel.validationModeEnabled
                        )
                    } label: {
                        IntegrationCard(title: integration.displayName, imageName: integration.imageName)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private var showcaseSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            RootSectionHeader("Showcase")
            Button {
                showShowcase = true
            } label: {
                Text("📺 Media + Feed Showcase")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .background(Color.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
        }
    }

    private var settingsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            RootSectionHeader("Settings")
            Toggle("Validation Mode", isOn: $viewModel.validationModeEnabled)
                .font(.system(size: 16))
                .padding(.vertical, 8)
        }
    }
}

/// A simple horizontal flow container that wraps to the next line when items don't fit.
/// Used for the Providers and Creatives pill rows (the UIKit sample uses a flow layout there too).
struct FlowHStack<Content: View>: View {
    let spacing: CGFloat
    @ViewBuilder var content: () -> Content

    init(spacing: CGFloat = 4, @ViewBuilder content: @escaping () -> Content) {
        self.spacing = spacing
        self.content = content
    }

    var body: some View {
        FlowLayout(spacing: spacing) {
            content()
        }
    }
}

/// Minimal flow layout. Available on iOS 16+, matching the project's deployment target.
private struct FlowLayout: Layout {
    var spacing: CGFloat = 4

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache _: inout ()) -> CGSize {
        let width = proposal.width ?? .infinity
        let rows = arrange(subviews: subviews, in: width)
        let height = rows.reduce(into: CGFloat(0)) { sum, row in
            sum += row.height + (sum == 0 ? 0 : spacing)
        }
        return CGSize(width: width.isFinite ? width : rows.map(\.width).max() ?? 0, height: height)
    }

    func placeSubviews(in bounds: CGRect, proposal _: ProposedViewSize, subviews: Subviews, cache _: inout ()) {
        let rows = arrange(subviews: subviews, in: bounds.width)
        var y = bounds.minY
        for row in rows {
            var x = bounds.minX
            for item in row.items {
                let size = item.view.sizeThatFits(.unspecified)
                item.view.place(at: CGPoint(x: x, y: y), proposal: ProposedViewSize(width: size.width, height: size.height))
                x += size.width + spacing
            }
            y += row.height + spacing
        }
    }

    private struct Row {
        var items: [(view: LayoutSubview, size: CGSize)] = []
        var width: CGFloat = 0
        var height: CGFloat = 0
    }

    private func arrange(subviews: Subviews, in width: CGFloat) -> [Row] {
        var rows: [Row] = [Row()]
        for view in subviews {
            let size = view.sizeThatFits(.unspecified)
            let candidateWidth = rows[rows.count - 1].width + (rows[rows.count - 1].items.isEmpty ? 0 : spacing) + size.width
            if candidateWidth > width, !rows[rows.count - 1].items.isEmpty {
                rows.append(Row())
            }
            let last = rows.count - 1
            rows[last].items.append((view: view, size: size))
            rows[last].width += size.width + (rows[last].items.count == 1 ? 0 : spacing)
            rows[last].height = max(rows[last].height, size.height)
        }
        return rows
    }
}

#Preview {
    RootCatalogView()
}
