//
//  MPAdapterTeadsNativeAdRendererSettings.swift
//  TeadsMoPubAdapter
//
//  Created by Jérémy Grosjean on 24/06/2021.
//

import MoPubSDK

@objc public final class MPAdapterTeadsNativeAdRendererSettings: NSObject, MPNativeAdRendererSettings {
    @objc public var viewSizeHandler: MPNativeViewSizeHandler!
    @objc public var renderingViewClass: (UIView & MPNativeAdRendering).Type?
}
