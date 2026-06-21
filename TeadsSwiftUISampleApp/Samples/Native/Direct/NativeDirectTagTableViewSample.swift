//
//  NativeDirectTagTableViewSample.swift
//  TeadsSwiftUISampleApp
//
//  Copyright © 2026 Teads. All rights reserved.
//

import SwiftUI

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
