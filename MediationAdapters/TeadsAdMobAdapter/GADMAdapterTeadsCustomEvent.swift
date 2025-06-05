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
public class GADMAdapterTeadsCustomEvent: NSObject, GADMediationAdapter {
    public static func adSDKVersion() -> GADVersionNumber {
        let versionComponents = String(Teads.sdkVersion).components(
            separatedBy: ".")

        if versionComponents.count >= 3 {
            let majorVersion = Int(versionComponents[0]) ?? 0
            let minorVersion = Int(versionComponents[1]) ?? 0
            let patchVersion = Int(versionComponents[2]) ?? 0

            return GADVersionNumber(
                majorVersion: majorVersion, minorVersion: minorVersion, patchVersion: patchVersion
            )
        }

        return GADVersionNumber()
    }

    public static func adapterVersion() -> GADVersionNumber {
        adSDKVersion()
    }

    public static func networkExtrasClass() -> GADAdNetworkExtras.Type? {
        TeadsAdapterSettings.self
    }

    public static func setUpWith(
        _: GADMediationServerConfiguration,
        completionHandler: @escaping GADMediationAdapterSetUpCompletionBlock
    ) {
        Teads.configure()
        completionHandler(nil)
    }

    override public required init() {
        super.init()
    }
}
