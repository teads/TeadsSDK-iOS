//
//  TeadsBrandNavigationBar.swift
//  TeadsSwiftUISampleApp
//
//  Copyright © 2026 Teads. All rights reserved.
//

import SwiftUI

/// Applies the Teads-branded navigation bar used throughout the UIKit `TeadsSampleApp`:
/// a purple-to-blue gradient background with the white Teads logo centered as the title.
private struct TeadsBrandNavigationBar: ViewModifier {
    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Image("Teads-Sample-App-White")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 30)
                        .accessibilityLabel("Teads")
                }
            }
            .toolbarBackground(LinearGradient.teadsBrand, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
    }
}

extension View {
    /// Renders the Teads gradient navigation bar with the white logo, matching the UIKit sample.
    func teadsBrandNavigationBar() -> some View {
        modifier(TeadsBrandNavigationBar())
    }
}
