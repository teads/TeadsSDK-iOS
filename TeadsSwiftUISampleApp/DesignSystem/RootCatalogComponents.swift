//
//  RootCatalogComponents.swift
//  TeadsSwiftUISampleApp
//
//  Copyright © 2026 Teads. All rights reserved.
//

import SwiftUI

/// A pill button matching the UIKit sample's `RootButtonCollectionViewCell`.
///
/// Selected pills fill with the primary color and white text; unselected pills show a bordered
/// outline. Used for the Formats and Providers rows.
struct RootPillButton: View {
    let title: String
    var isSelected: Bool
    var action: () -> Void = {}

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 16))
                .lineLimit(1)
                .padding(.horizontal, 14)
                .frame(height: 32)
                .frame(maxWidth: .infinity)
                .foregroundStyle(isSelected ? Color.white : Color.cellBorder)
                .background(isSelected ? Color.teadsPrimary : Color.appBackground)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(isSelected ? Color.teadsPrimary : Color.cellBorder, lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
    }
}

/// A square image + label card matching the UIKit sample's `RootImageViewLabelCollectionViewCell`,
/// used for the Integrations grid.
struct IntegrationCard: View {
    let title: String
    let imageName: String

    var body: some View {
        VStack(spacing: 8) {
            Image(imageName)
                .resizable()
                .renderingMode(.template)
                .scaledToFit()
                .frame(height: 56)
            Text(title)
                .font(.system(size: 16))
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
        .foregroundStyle(Color.teadsGray)
        .frame(maxWidth: .infinity)
        .aspectRatio(1, contentMode: .fit)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.teadsGray, lineWidth: 1)
        )
    }
}

/// Section header matching the UIKit catalogue's section titles ("Formats", "Providers", ...).
struct RootSectionHeader: View {
    let title: String

    init(_ title: String) {
        self.title = title
    }

    var body: some View {
        Text(title)
            .font(.title3.bold())
            .foregroundStyle(Color.appText)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 8)
    }
}
