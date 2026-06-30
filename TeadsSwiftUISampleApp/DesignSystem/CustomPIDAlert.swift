//
//  CustomPIDAlert.swift
//  TeadsSwiftUISampleApp
//
//  Copyright © 2026 Teads. All rights reserved.
//

import SwiftUI

/// Number-pad alert for entering a custom PID.
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
    /// Presents the custom-PID alert.
    func customPIDAlert(isPresented: Binding<Bool>) -> some View {
        modifier(CustomPIDAlertModifier(isPresented: isPresented))
    }
}
