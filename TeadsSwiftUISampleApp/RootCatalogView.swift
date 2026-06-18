//
//  RootCatalogView.swift
//  TeadsSwiftUISampleApp
//
//  Copyright © 2026 Teads. All rights reserved.
//

import SwiftUI

/// Entry screen listing every available SwiftUI sample, grouped by format and provider.
///
/// Mirrors the UIKit `TeadsSampleApp` root catalogue, translated to a SwiftUI `NavigationStack`.
struct RootCatalogView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("InRead • Direct") {
                    ForEach(InReadDirectSample.allCases) { sample in
                        NavigationLink(sample.title) {
                            sample.destination
                        }
                    }
                }
            }
            .navigationTitle("Teads SwiftUI")
        }
    }
}

/// The InRead Direct samples (parity-matrix row one).
enum InReadDirectSample: String, CaseIterable, Identifiable {
    case scrollView
    case list
    case lazyVGrid
    case pagedTabView
    case webView

    var id: String { rawValue }

    var title: String {
        switch self {
            case .scrollView: "ScrollView"
            case .list: "List"
            case .lazyVGrid: "LazyVGrid (CollectionView)"
            case .pagedTabView: "Paged TabView (PageView)"
            case .webView: "WebView"
        }
    }

    @ViewBuilder
    var destination: some View {
        switch self {
            case .scrollView: InReadDirectScrollViewSample()
            case .list: InReadDirectListSample()
            case .lazyVGrid: InReadDirectLazyVGridSample()
            case .pagedTabView: InReadDirectPagedTabViewSample()
            case .webView: InReadDirectWebViewSample()
        }
    }
}

#Preview {
    RootCatalogView()
}
