//
//  NativeAdView.swift
//
//  Copyright 2018-2020 Twitter, Inc.
//  Licensed under the MoPub SDK License Agreement
//  http://www.mopub.com/legal/sdk-license-agreement/
//

import UIKit
import AppLovinSDK
import MoPubSDK

/**
 Provides a common native ad view.
 */
@IBDesignable
class AppLovinNativeAdView: MANativeAdView {
    
}

extension UIView {
    static func loadNib(nibName name: String? = nil) -> Self? {
        let nibName = name ?? String(describing: Self.self)
        let bundle = Bundle(for: Self.self)
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? Self
    }
}
