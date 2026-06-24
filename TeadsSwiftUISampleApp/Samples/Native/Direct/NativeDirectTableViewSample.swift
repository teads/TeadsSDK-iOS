//
//  NativeDirectTableViewSample.swift
//  TeadsSwiftUISampleApp
//
//  Copyright © 2026 Teads. All rights reserved.
//

import SwiftUI

struct NativeDirectTableViewSample: View {
    let pid: Int
    let validationMode: Bool

    private static let articleCount = 8
    private static let adIndex = 3

    var body: some View {
        List {
            ArticleHeaderImage()
                .listRowInsets(EdgeInsets())
                .listRowSeparator(.hidden)

            ForEach(0 ..< Self.articleCount, id: \.self) { index in
                if index == Self.adIndex {
                    TeadsNativeAdHost(pid: pid, validationMode: validationMode)
                        .frame(height: 250)
                        .padding(.horizontal, 10)
                        .listRowInsets(EdgeInsets())
                        .listRowSeparator(.hidden)
                } else {
                    FakeNativeArticleRow()
                        .listRowSeparator(.hidden)
                }
            }
        }
        .listStyle(.plain)
        .navigationBarTitleDisplayMode(.inline)
        .teadsBrandNavigationBar()
    }
}

struct FakeNativeArticleRow: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image("image-article")
                .resizable()
                .scaledToFill()
                .frame(height: 120)
                .clipped()
            HStack(spacing: 12) {
                Image("TeadsLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 28, height: 28)
                VStack(alignment: .leading, spacing: 2) {
                    Text("Teads")
                        .font(.headline)
                    Text("The global media platform")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Button {
                    if let url = URL(string: "https://teads.com") {
                        UIApplication.shared.open(url)
                    }
                } label: {
                    Text("Discover")
                        .font(.subheadline.weight(.semibold))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.teadsBlue)
                        .foregroundStyle(.white)
                        .clipShape(Capsule())
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 12)
            .padding(.bottom, 8)
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.cellBorder, lineWidth: 0.5))
        .padding(.horizontal, 10)
        .padding(.vertical, 4)
    }
}

#Preview {
    NavigationStack {
        NativeDirectTableViewSample(pid: SamplePID.directNativeDisplay, validationMode: true)
    }
}
