//
//  NativeDirectTagTableViewSample.swift
//  TeadsSwiftUISampleApp
//
//  Copyright © 2026 Teads. All rights reserved.
//

import SwiftUI

/// Native • Direct • TableView-Tag.
///
/// Identical wiring to `NativeDirectTableViewSample`. In the UIKit sample this variant exists to
/// demonstrate tag-based binding of the `TeadsNativeAdView` subviews (configured in the .xib); the
/// SwiftUI integration delegates that wiring to `TeadsNativeAdView` itself so the screen ends up
/// behaving the same as the standard TableView variant.
struct NativeDirectTagTableViewSample: View {
    let pid: Int
    let validationMode: Bool

    var body: some View {
        NativeDirectTableViewSample(pid: pid, validationMode: validationMode)
    }
}

#Preview {
    NavigationStack {
        NativeDirectTagTableViewSample(pid: SamplePID.directNativeDisplay, validationMode: true)
    }
}
