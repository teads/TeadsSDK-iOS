//
//  Helper.swift
//  Pods
//
//  Created by Thibaud Saint-Etienne on 21/07/2021.
//

import TeadsSDK
import UIKit

public enum Helper {
    public static func bannerSize(for width: CGFloat) -> CGSize {
        CGSize(width: width > 0 ? width : 300, height: width / (16 / 9))
    }
}

/// Convenience closure typealias for ``TeadsAdSettings``
///
/// Has been renamed in favor of TeadsAdapterSettings
@available(*, deprecated, renamed: "TeadsAdapterSettings", message: "Only relevant when using TeadsAdMobAdapter, TeadsAppLovinAdapter, TeadsSmartAdapter")
public typealias TeadsAdSettings = TeadsAdapterSettings
