//
//  TeadsLogoView.swift
//  TeadsSwiftUISampleApp
//
//  Copyright © 2026 Teads. All rights reserved.
//

import SwiftUI

struct TeadsLogoView: View {
    let dark: Bool

    var body: some View {
        Text("Teads SDK Demo (SwiftUI)")
            .font(.system(size: 17, weight: .bold))
            .foregroundStyle(dark ? .white : .black)
    }
}
