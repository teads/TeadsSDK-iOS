//
//  TeadsBrandNavigationBar.swift
//  TeadsSwiftUISampleApp
//
//  Copyright © 2026 Teads. All rights reserved.
//

import SwiftUI

/// Teads-branded navigation bar: gradient background, white logo title.
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
    /// Applies the Teads-branded navigation bar.
    func teadsBrandNavigationBar() -> some View {
        modifier(TeadsBrandNavigationBar())
    }
}
