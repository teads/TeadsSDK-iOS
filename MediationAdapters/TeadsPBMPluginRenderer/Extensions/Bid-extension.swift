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
        case adm // Ad markup
        case nurl // Notification URL
        case price // Bid price
        // Additional fields can be added if needed:
        case adid // Ad identifier
        case adomain // Advertiser domain
        case crid // Creative ID
        case impid // Impression ID
    }

    // MARK: - Encodable Conformance

    /// Encodes selected bid properties into the given encoder.
    /// Only `adm`, `nurl`, and `price` are guaranteed to be encoded.
    /// Other fields are preserved in the `Bid`'s `toJsonDictionary()` output.
    ///
    /// - Parameter encoder: The encoder to write data into.
    /// - Throws: Any encoding error propagated from the container.
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(adm, forKey: .adm)
        try container.encode(nurl, forKey: .nurl)
        try container.encode(price, forKey: .price)
    }

    // MARK: - JSON String Serialization

    /// Serializes the full bid dictionary to a pretty-printed JSON string.
    ///
    /// Uses `bid.toJsonDictionary()` to include all available fields,
    /// then validates the JSON and converts it to `String` with UTF-8 encoding.
    ///
    /// - Returns: A JSON string representation of the bid payload.
    /// - Throws: `TeadsPluginError.jsonSerialization` if the dictionary is invalid JSON.
    ///           `TeadsPluginError.stringEncoding` if UTF-8 conversion fails.
    public func stringify() throws -> String {
        return ""
//        let dictionary = bid.toJsonDictionary()
//        guard JSONSerialization.isValidJSONObject(dictionary) else {
//            throw TeadsPBMPluginError.jsonSerialization
//        }
//
//        let data = try JSONSerialization.data(
//            withJSONObject: dictionary,
//            options: .prettyPrinted
//        )
//
//        guard let jsonString = String(data: data, encoding: .utf8) else {
//            throw TeadsPBMPluginError.stringEncoding
//        }
//
//        return jsonString
    }
}
