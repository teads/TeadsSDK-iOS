//
//  SampleDestinationFactory.swift
//  TeadsSwiftUISampleApp
//
//  Copyright © 2026 Teads. All rights reserved.
//

import SwiftUI

/// Resolves a `SampleSelection` to the concrete sample screen.
enum SampleDestinationFactory {
    @ViewBuilder
    static func destination(for selection: SampleSelection, validationMode: Bool) -> some View {
        switch selection.format {
            case .inRead: inReadDestination(for: selection, validationMode: validationMode)
            case .native: nativeDestination(for: selection, validationMode: validationMode)
            case .interstitial: InterstitialAdmobSample(pid: selection.stringPID)
        }
    }

    @ViewBuilder
    private static func inReadDestination(for selection: SampleSelection, validationMode: Bool) -> some View {
        switch selection.provider {
            case .direct:
                switch selection.integration {
                    case .scrollView: InReadDirectScrollViewSample(selection: selection, validationMode: validationMode)
                    case .tableView: InReadDirectTableViewSample(selection: selection, validationMode: validationMode)
                    case .collectionView: InReadDirectCollectionViewSample(selection: selection, validationMode: validationMode)
                    case .pageView: InReadDirectPageViewSample(selection: selection, validationMode: validationMode)
                    case .webView: InReadDirectWebViewSample(selection: selection)
                    case .tableTagView: SampleUnavailableView()
                }
            case .admob:
                switch selection.integration {
                    case .scrollView: InReadAdmobScrollViewSample(pid: selection.stringPID)
                    case .tableView: InReadAdmobTableViewSample(pid: selection.stringPID)
                    case .webView: InReadAdmobWebViewSample(pid: selection.stringPID)
                    default: SampleUnavailableView()
                }
            case .sas:
                switch selection.integration {
                    case .scrollView: InReadSASScrollViewSample(formatId: selection.integerPID)
                    case .tableView: InReadSASTableViewSample(formatId: selection.integerPID)
                    default: SampleUnavailableView()
                }
            case .appLovin:
                InReadAppLovinScrollViewSample(adUnitId: selection.stringPID, isMREC: selection.isMREC)
        }
    }

    @ViewBuilder
    private static func nativeDestination(for selection: SampleSelection, validationMode: Bool) -> some View {
        switch selection.provider {
            case .direct:
                switch selection.integration {
                    case .tableView: NativeDirectTableViewSample(pid: selection.integerPID, validationMode: validationMode)
                    case .collectionView: NativeDirectCollectionViewSample(pid: selection.integerPID, validationMode: validationMode)
                    case .tableTagView: NativeDirectTagTableViewSample(pid: selection.integerPID, validationMode: validationMode)
                    default: SampleUnavailableView()
                }
            case .admob: NativeAdmobTableViewSample(pid: selection.stringPID)
            case .appLovin: NativeAppLovinTableViewSample(pid: selection.stringPID)
            case .sas: NativeSASTableViewSample()
        }
    }
}

/// Placeholder shown for catalogue combinations without an implementation.
struct SampleUnavailableView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "tray")
                .font(.system(size: 48))
                .foregroundStyle(.secondary)
            Text("Coming soon")
                .font(.headline)
            Text("This integration is not available yet in the SwiftUI sample.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .teadsBrandNavigationBar()
    }
}
