//
//  InReadSASScrollViewSample.swift
//  TeadsSwiftUISampleApp
//
//  Copyright © 2026 Teads. All rights reserved.
//

import SwiftUI

/// InRead • SAS • ScrollView.
///
/// Drives Smart AdServer via the Teads adapter, with a fake article scaffold around the ad slot.
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
