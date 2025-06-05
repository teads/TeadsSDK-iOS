//
//  AdMobHelper.swift
//  TeadsAdMobAdapter
//
//  Created by Richard Dépierre on 28/03/2024.
//

import GoogleMobileAds
import TeadsSDK
import UIKit

public enum AdMobHelper {
    public static func getGMAVersionNumber() -> String {
        // Get GMA version number
        let gmaVersionNumber = MobileAds.shared.versionNumber

        // Extract major, minor, and patch version numbers
        let majorVersion = gmaVersionNumber.majorVersion
        let minorVersion = gmaVersionNumber.minorVersion
        let patchVersion = gmaVersionNumber.patchVersion

        // Construct the formatted version string
        let formattedVersion = "\(majorVersion).\(minorVersion).\(patchVersion)"

        return formattedVersion
    }
}
