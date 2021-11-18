//
//  TeadsSASAdapterHelper.swift
//  TeadsSASAdapter
//
//  Created by Jérémy Grosjean on 06/11/2020.
//

import UIKit
import TeadsSDK

@objc public final class TeadsSASAdapterHelper: NSObject {

    @objc public static func teadsAdSettingsToString(adSettings: TeadsAdapterSettings) -> String? {
        guard let adSettingsEscapedString = adSettings.escapedString else {
            return nil
        }
        return "teadsAdSettingsKey=\(adSettingsEscapedString)"
    }

    @objc public static func concatAdSettingsToKeywords(keywordsStrings: String, adSettings: TeadsAdapterSettings) -> String {
        if let adSettingsStrings = teadsAdSettingsToString(adSettings: adSettings) {
            return "\(keywordsStrings);\(adSettingsStrings)"
        }
        return keywordsStrings
    }

    static func stringToAdSettings(adSettingsString: String?) -> TeadsAdapterSettings? {
        if let adSettingsString = adSettingsString?.removingPercentEncoding?.data(using: .utf8) {
            return try? JSONDecoder().decode(TeadsAdapterSettings.self, from: adSettingsString)
        }
        return nil
    }

}

extension TeadsAdapterSettings {

    var escapedString: String? {
        if let data = try? JSONEncoder().encode(self), let adSettingsString = String(data: data, encoding: .utf8) {
            return adSettingsString.addingPercentEncoding(withAllowedCharacters: .urlUserAllowed)
        }
        return nil
    }
}

struct ServerParameter: Codable {
    var placementId: Int?
    var teadsAdSettingsKey: String?

    static func instance(from serverParameterString: String) -> Self? {
        guard let data = serverParameterString.data(using: .utf8) else {
            return nil
        }
        return try? JSONDecoder().decode(Self.self, from: data)
    }

    var adSettings: TeadsAdapterSettings {
        return TeadsSASAdapterHelper.stringToAdSettings(adSettingsString: teadsAdSettingsKey) ?? TeadsAdapterSettings()
    }
}
