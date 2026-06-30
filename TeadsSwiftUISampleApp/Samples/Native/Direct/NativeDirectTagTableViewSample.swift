//
//  NativeDirectTagTableViewSample.swift
//  TeadsSwiftUISampleApp
//
//  Copyright © 2026 Teads. All rights reserved.
//

import SwiftUI

struct NativeDirectTagTableViewSample: View {
    let pid: Int

    var body: some View {
        NativeDirectTableViewSample(pid: pid)
    }
}

#Preview {
    NavigationStack {
        NativeDirectTagTableViewSample(pid: SamplePID.directNativeDisplay)
    }
}
