//
//  TeadsColors.swift
//  TeadsSwiftUISampleApp
//
//  Copyright © 2026 Teads. All rights reserved.
//

import SwiftUI

/// Teads brand colors.
extension Color {
    static let appText = Color("AppTextColor")
    static let appBackground = Color("AppBackgroundColor")
    static let teadsPrimary = Color("PrimaryColor")
    static let lightBlue = Color("LightBlueColor")
    static let teadsBlue = Color("TeadsBlueColor")
    static let teadsPurple = Color("TeadsPurpleColor")
    static let teadsGray = Color("TeadsGrayColor")
    static let fakeArticle = Color("FakeArticleColor")
    static let cellBorder = Color("CellBorderColor")
}

/// Teads purple-to-blue gradient.
extension LinearGradient {
    static let teadsBrand = LinearGradient(
        colors: [.teadsPurple, .teadsBlue],
        startPoint: .leading,
        endPoint: .trailing
    )
}
