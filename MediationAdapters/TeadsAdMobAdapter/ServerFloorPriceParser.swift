//
//  ServerFloorPriceParser.swift
//  TeadsAdMobAdapter
//

import Foundation

/// Floor price extracted from a GAM dashboard JSON credentials string.
///
/// Shared by every AdMob adapter that needs to read a server-side `pbf` value
/// alongside the publisher value coming from `TeadsAdapterSettings`.
enum ServerFloorPriceParser {
    // Decoded as Double so we accept both integer (`150`) and floating-point (`150.0`,
    // `150.7`) JSON values, then truncated to Int. Matches Android's `JSONObject.getInt`,
    // which calls `Number.intValue()` and silently truncates fractional parts.
    private struct Payload: Decodable {
        let pbf: Double?
    }

    /// Parses the `pbf` floor price from a GAM dashboard JSON credentials string.
    /// Returns `nil` for missing input, malformed JSON, or a missing/non-numeric `pbf`.
    /// Floating-point values are truncated to `Int` (e.g. `150.7` → `150`).
    static func floorPrice(fromJSON json: String?) -> Int? {
        guard
            let data = json?.data(using: .utf8),
            let pbf = (try? JSONDecoder().decode(Payload.self, from: data))?.pbf else { return nil }
        return Int(exactly: pbf.rounded(.towardZero))
    }
}
