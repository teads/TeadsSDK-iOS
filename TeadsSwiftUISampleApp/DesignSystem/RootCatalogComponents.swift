//
//  RootCatalogComponents.swift
//  TeadsSwiftUISampleApp
//
//  Copyright © 2026 Teads. All rights reserved.
//

import SwiftUI

/// Pill button used in the catalogue rows.
struct RootPillButton: View {
    let title: String
    var isSelected: Bool
    var action: () -> Void = {}

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 16))
                .lineLimit(1)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 12)
                .frame(height: 32)
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

/// Card used in the integrations grid.
struct IntegrationCard: View {
    let title: String
    let imageName: String

    var body: some View {
        VStack(spacing: 8) {
            Image(imageName)
                .resizable()
                .renderingMode(.template)
                .scaledToFit()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            Text(title)
                .font(.system(size: 17))
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
        .padding(16)
        .foregroundStyle(Color.teadsGray)
        .frame(maxWidth: .infinity)
        .aspectRatio(1, contentMode: .fit)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.teadsGray, lineWidth: 1)
        )
    }
}

/// Catalogue section header.
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
