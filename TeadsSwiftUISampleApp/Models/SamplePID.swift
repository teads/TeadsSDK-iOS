//
//  SamplePID.swift
//  TeadsSwiftUISampleApp
//
//  Copyright © 2026 Teads. All rights reserved.
//

import Foundation

/// Public test placement identifiers, kept in sync with the UIKit `TeadsSampleApp`.
///
/// These are public demo PIDs only — no internal placements are referenced here.
enum SamplePID {
    // InRead Direct
    static let inReadDirectLandscape = 84242
    static let inReadDirectVertical = 127_546
    static let inReadDirectSquare = 127_547
    static let inReadDirectCarousel = 128_779

    /// Default article URL used by the demo placements.
    static let articleURL = URL(string: "https://www.teads.com")
}
