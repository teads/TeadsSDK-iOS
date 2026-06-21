//
//  InReadSASScrollViewSample.swift
//  TeadsSwiftUISampleApp
//
//  Copyright © 2026 Teads. All rights reserved.
//

import SwiftUI

struct InReadSASScrollViewSample: View {
    let formatId: Int

    var body: some View {
        ScrollView {
            FakeArticle {
                SASBannerHost(formatId: formatId)
                    .padding(.horizontal)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .teadsBrandNavigationBar()
    }
}

#Preview {
    NavigationStack {
        InReadSASScrollViewSample(formatId: SamplePID.sasLandscape)
    }
}
