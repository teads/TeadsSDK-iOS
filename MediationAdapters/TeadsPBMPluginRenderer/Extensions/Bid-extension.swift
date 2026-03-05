//
//  Bid-extension.swift
//  TeadsPBMPluginRenderer
//
//  Refactored by Richard Dépierre on 18/06/2025.
//

import Foundation
import PrebidMobile

// MARK: - Bid JSON Encoding

/// Retroactively adds `Encodable` conformance to `Bid` for JSON serialization.
/// This enables converting a `Bid` instance into a JSON string payload
/// that Teads SDK can consume.
extension Bid: @retroactive Encodable {
    // MARK: Coding Keys

    /// Keys to encode when serializing to JSON.
    private enum CodingKeys: String, CodingKey {
        case adm
        case nurl
        case burl
        case price
    }

    // MARK: - Encodable Conformance

    /// Encodes selected bid properties into the given encoder.
    ///
    /// - Parameter encoder: The encoder to write data into.
    /// - Throws: Any encoding error propagated from the container.
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(adm, forKey: .adm)
        try container.encodeIfPresent(nurl, forKey: .nurl)
        try container.encodeIfPresent(burl, forKey: .burl)
        try container.encode(price, forKey: .price)
    }

    // MARK: - JSON String Serialization

    /// Serializes the bid to a JSON string using `JSONEncoder`.
    ///
    /// - Returns: A JSON string representation of the bid payload.
    /// - Throws: `TeadsPluginError.jsonSerialization` if encoding fails.
    ///           `TeadsPluginError.stringEncoding` if UTF-8 conversion fails.
    public func stringify() throws -> String {
        let data: Data
        do {
            data = try JSONEncoder().encode(self)
        } catch {
            throw TeadsPBMPluginError.jsonSerialization
        }

        guard let jsonString = String(data: data, encoding: .utf8) else {
            throw TeadsPBMPluginError.stringEncoding
        }

        return jsonString
    }
}
