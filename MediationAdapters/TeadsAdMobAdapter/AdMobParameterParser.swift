//
//  AdMobParameterParser.swift
//  TeadsAdMobAdapter
//
//  Created by Dmitry Mazo on 29/04/2026.
//

import Foundation

// MARK: - Parameter types

/// Banner parameters supplied by either the GAM-side credential JSON or
/// the local extras dict.
struct BannerParameters: Decodable {
    let articleUrl: URL
    let widgetId: String
    let installationKey: String
    let widgetIndex: Int?
    let userId: String?
    let darkMode: Bool?
    let extId: String?
    let extSecondaryId: String?
    let obPubImp: String?
}

struct InterstitialParameters: Decodable {
    let articleUrl: URL
    let widgetId: String
    let installationKey: String
}

// MARK: - Parser

/// Decodes any `Decodable` parameters type from either a raw JSON credential string
/// (set by the publisher in the AdMob dashboard) or a serialized
/// ``TeadsAdapterSettings`` dictionary (set via ``GADRequest.register``).
enum AdMobParameterParser {
    /// Decodes from a JSON string supplied in the server-side credentials field.
    static func parse<T: Decodable>(fromCredentialJSON rawParameter: String) -> T? {
        guard let data = rawParameter.data(using: .utf8) else { return nil }
        return try? JSONDecoder().decode(T.self, from: data)
    }

    /// Decodes from a dictionary produced by ``TeadsAdapterSettings.toDictionary()``.
    static func parse<T: Decodable>(fromSettingsDict dict: [String: Any]) -> T? {
        guard let data = try? JSONSerialization.data(withJSONObject: dict),
              let wrapper = try? JSONDecoder().decode(SettingsWrapper<T>.self, from: data) else {
            return nil
        }
        return wrapper.adRequestSettings.extras
    }
}

// MARK: - Private decoding wrapper

private struct SettingsWrapper<T: Decodable>: Decodable {
    let adRequestSettings: RequestSettings

    struct RequestSettings: Decodable {
        let extras: T
    }
}
