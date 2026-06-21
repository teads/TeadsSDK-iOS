//
//  RootCatalogView.swift
//  TeadsSwiftUISampleApp
//
//  Copyright © 2026 Teads. All rights reserved.
//

import SwiftUI

/// Catalogue entry screen.
struct RootCatalogView: View {
    @StateObject private var viewModel = CatalogViewModel()
    @State private var showShowcase = false

    private let itemSpacing: CGFloat = 15
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

    private var formatsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            RootSectionHeader("Formats")
            HStack(spacing: itemSpacing) {
                ForEach(SampleFormat.allCases) { format in
                    RootPillButton(
                        title: format.displayName,
                        isSelected: viewModel.format == format
                    ) {
                        viewModel.selectFormat(format)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
    }

    private var providersSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            RootSectionHeader("Providers")
            pillRows(for: viewModel.availableProviders, perRow: 3) { provider in
                RootPillButton(
                    title: provider.displayName,
                    isSelected: viewModel.provider == provider
                ) {
                    viewModel.selectProvider(provider)
                }
            }
        }
    }

    private var creativesSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            RootSectionHeader("Creatives")
            pillRows(for: viewModel.availableCreatives, perRow: 3) { creative in
                RootPillButton(
                    title: creative.displayName,
                    isSelected: viewModel.creative == creative
                ) {
                    viewModel.selectCreative(creative)
                }
            }
        }
    }

    @ViewBuilder
    private func pillRows<Item: Hashable>(
        for items: [Item],
        perRow: Int,
        @ViewBuilder pill: @escaping (Item) -> some View
    ) -> some View {
        VStack(alignment: .leading, spacing: itemSpacing) {
            ForEach(items.chunked(into: perRow), id: \.self) { row in
                HStack(spacing: itemSpacing) {
                    ForEach(row, id: \.self) { item in
                        pill(item).fixedSize()
                    }
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

private extension Array {
    func chunked(into size: Int) -> [[Element]] {
        guard size > 0 else { return [] }
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}

#Preview {
    RootCatalogView()
}
