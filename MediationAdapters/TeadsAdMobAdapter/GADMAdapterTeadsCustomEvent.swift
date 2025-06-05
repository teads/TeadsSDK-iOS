//
//  GADMAdapterTeadsCustomEvent.swift
//  TeadsAdMobAdapter
//
//  Created by Thibaud Saint-Etienne on 26/10/2022.
//

import Foundation
import GoogleMobileAds
import TeadsSDK

@objc(GADMAdapterTeadsCustomEvent)
public class GADMAdapterTeadsCustomEvent: NSObject, MediationAdapter {
    public static func adSDKVersion() -> VersionNumber {
        let versionComponents = String(Teads.sdkVersion).components(
            separatedBy: ".")

        if versionComponents.count >= 3 {
            let majorVersion = Int(versionComponents[0]) ?? 0
            let minorVersion = Int(versionComponents[1]) ?? 0
            let patchVersion = Int(versionComponents[2]) ?? 0

            return VersionNumber(
                majorVersion: majorVersion, minorVersion: minorVersion, patchVersion: patchVersion
            )
        }

        return VersionNumber()
    }

    public static func adapterVersion() -> VersionNumber {
        adSDKVersion()
    }

    public static func networkExtrasClass() -> AdNetworkExtras.Type? {
        TeadsAdapterSettings.self
    }

    public static func setUpWith(
        _: MediationServerConfiguration,
        completionHandler: @escaping GADMediationAdapterSetUpCompletionBlock
    ) {
        Teads.configure()
        completionHandler(nil)
    }

    override public required init() {
        super.init()
    }
}
