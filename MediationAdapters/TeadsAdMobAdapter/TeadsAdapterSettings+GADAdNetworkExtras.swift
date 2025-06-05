//
//  TeadsAdapterSettings+GADAdNetworkExtras.swift
//  TeadsAdMobAdapter
//
//  Created by Thibaud Saint-Etienne on 27/10/2022.
//

import Foundation
import GoogleMobileAds
import TeadsSDK

@objc public final class GADMAdapterTeads: NSObject {
    @available(*, deprecated, message: "defaultLabel is not used anymore please pass your label value as parameter of the customEventExtra method")
    @objc public static let defaultLabel = "Teads"

    /// customEventExtra is a method used to create GADCustomEventExtras based on teadsAdSettings
    /// - Parameters:
    ///     - teadsAdSettings: the TeadsAdapterSettings that you will pass as extra parameters for the mediation.
    ///     - label: the same label as it registered on your Google dashboard, default value is Teads.
    ///
    /// - Important:
    ///
    ///  This method is deprecated if favor of registering directly ``TeadsSDK.TeadsAdapterSettings``
    ///  ```
    ///  import TeadsAdMobAdapter
    ///
    ///  let request = GADRequest()
    ///  let adSettings = TeadsAdapterSettings { (settings) in
    ///     settings.pageUrl("http://page.com/article1")
    ///     settings.registerAdView(admobAdView, delegate: self)
    ///  }
    ///  request.register(adSettings)
    ///  ```
    @available(*, unavailable, message: "customEventExtra is not available anymore, you can register TeadsAdapterSettings directly calling `GADRequest.register(_ )")
    @objc public class func customEventExtra(with teadsAdSettings: TeadsAdapterSettings, for label: String) -> GADCustomEventExtras {
        let customEventExtras = CustomEventExtras()
        if let parameters = try? teadsAdSettings.toDictionary() {
            customEventExtras.setExtras(parameters, forLabel: label)
        }
        return customEventExtras
    }
}

extension TeadsAdapterSettings: AdNetworkExtras {}
