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
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
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
                MediaFeedShowcaseSample()
            }
        }
    }

    private var formatsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            RootSectionHeader("Formats")
            pillGrid(for: SampleFormat.allCases, columns: 3) { format in
                RootPillButton(
                    title: format.displayName,
                    isSelected: viewModel.format == format
                ) {
                    viewModel.selectFormat(format)
                }
            }
        }
    }

    private var providersSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            RootSectionHeader("Providers")
            pillGrid(for: viewModel.availableProviders, columns: 3) { provider in
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
            pillGrid(for: viewModel.availableCreatives, columns: 2) { creative in
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
    private func pillGrid<Item: Hashable>(
        for items: [Item],
        columns: Int,
        @ViewBuilder pill: @escaping (Item) -> some View
    ) -> some View {
        let pillColumn = GridItem(.flexible(), spacing: itemSpacing)
        LazyVGrid(columns: Array(repeating: pillColumn, count: columns), spacing: itemSpacing) {
            ForEach(items, id: \.self) { item in
                pill(item)
            }
        }
    }

    private var integrationsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            RootSectionHeader("Integrations")
            LazyVGrid(columns: integrationColumns, spacing: 16) {
                ForEach(viewModel.availableIntegrations) { integration in
                    NavigationLink {
                        SampleDestinationFactory.destination(for: viewModel.selection(for: integration))
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
                Text("📺 Media + Feed")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .background(Color.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
        }
    }
}

#Preview {
    RootCatalogView()
}
