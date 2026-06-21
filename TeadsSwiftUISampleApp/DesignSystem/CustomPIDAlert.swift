//
//  CustomPIDAlert.swift
//  TeadsSwiftUISampleApp
//
//  Copyright © 2026 Teads. All rights reserved.
//

import SwiftUI

/// Modifier that mirrors the UIKit sample's `pidAlert()` — a number-pad text field for entering a
/// custom PID, persisted to `UserDefaults` via `SamplePID.custom`.
private struct CustomPIDAlertModifier: ViewModifier {
    @Binding var isPresented: Bool
    @State private var entry = ""

    func body(content: Content) -> some View {
        content.alert("Enter your custom PID", isPresented: seedingBinding) {
            TextField("PID", text: $entry)
                .keyboardType(.numberPad)
            Button("Cancel", role: .cancel) {}
            Button("OK") {
                if let value = Int(entry) {
                    SamplePID.custom = value
                }
            }
        } message: {
            EmptyView()
        }
    }

    /// Mirrors the upstream `isPresented` binding, but seeds `entry` the moment SwiftUI flips it
    /// to `true` — which is the same hook point an `onChange(of:)` would have served, minus the
    /// API-version dance.
    private var seedingBinding: Binding<Bool> {
        Binding(
            get: { isPresented },
            set: { newValue in
                if newValue, !isPresented {
                    let fallback = SamplePID.custom > 0 ? SamplePID.custom : SamplePID.directLandscape
                    entry = "\(fallback)"
                }
                isPresented = newValue
            }
        )
    }
}

extension View {
    /// Presents the custom-PID alert when `isPresented` is true.
    func customPIDAlert(isPresented: Binding<Bool>) -> some View {
        modifier(CustomPIDAlertModifier(isPresented: isPresented))
    }
}
