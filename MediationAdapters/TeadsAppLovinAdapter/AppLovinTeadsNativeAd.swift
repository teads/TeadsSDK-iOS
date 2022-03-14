//
//  AppLovinTeadsNativeAd.swift
//  TeadsAppLovinAdapter
//
//  Created by Paul Nicolas on 14/03/2022.
//

import AppLovinSDK

@objc final class AppLovinTeadsNativeAd: MANativeAd {
    weak var parentAdatper: TeadsMediationAdapter?
    
    @objc init(parent: TeadsMediationAdapter, builderBlock: MANativeAdBuilderBlock) {
        super.init(format: .native, builderBlock: builderBlock)
        self.parentAdatper = parent
    }
    
    @objc override func prepareView(forInteraction maxNativeAdView: MANativeAdView) {
        guard let teadsNativeAd = parentAdatper?.nativeAd else {
            parentAdatper?.e("Failed to register native ad views: native ad is nil.", becauseOf: nil)
            return
        }
        teadsNativeAd.register(containerView: maxNativeAdView)
        maxNativeAdView.titleLabel?.bind(component: teadsNativeAd.title)
        maxNativeAdView.bodyLabel?.bind(component: teadsNativeAd.content)
        maxNativeAdView.callToActionButton?.bind(component: teadsNativeAd.callToAction)
        maxNativeAdView.iconImageView?.bind(component: teadsNativeAd.icon)
        maxNativeAdView.advertiserLabel?.bind(component: teadsNativeAd.sponsored)
        
        // mediaContentView and optionsContentView are already binded (subview)
    }
}
