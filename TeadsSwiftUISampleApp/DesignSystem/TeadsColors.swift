//
//  TeadsColors.swift
//  TeadsSwiftUISampleApp
//
//  Copyright © 2026 Teads. All rights reserved.
//

import SwiftUI

/// SwiftUI accessors for the brand colors shared with the UIKit `TeadsSampleApp`.
///
/// The color assets themselves are copied from the UIKit sample's catalogue so both apps render
/// with the exact same palette.
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

/// The signature Teads purple-to-blue horizontal gradient used on the navigation bar and headers.
extension LinearGradient {
    static let teadsBrand = LinearGradient(
        colors: [.teadsPurple, .teadsBlue],
        startPoint: .leading,
        endPoint: .trailing
    )
}
