//
//  GADMAdapterTeadsExtras.h
//  TeadsAdMobAdapter
//
//  Created by athomas on 29/05/2018.
//  Copyright © 2018 Teads. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GoogleMobileAds/GoogleMobileAds.h>
#import <TeadsSDK/TeadsSDK.h>

NS_ASSUME_NONNULL_BEGIN

/// Class encapsulating extra parameters for Teads custom events.
@interface GADMAdapterTeadsExtras : NSObject <GADAdNetworkExtras>

/// Enable test mode
@property (nonatomic, assign) BOOL debugMode;

/// Enable location reporting
@property (nonatomic, assign) BOOL reportLocation;

/// Enable light mode for endscreen
@property (nonatomic, assign) BOOL lightEndscreenMode;

/// Enable media preloading
@property (nonatomic, assign) BOOL mediaPreloadEnabled;

/// Brand safety url
@property (nonatomic, strong) NSString *pageUrl;

// GDPR consent
@property (nonatomic, strong) NSString *consent;

@property (nonatomic, strong) NSString *subjectToGDPR;

@property (nonatomic, assign) BOOL audioSessionIsApplicationManaged;

@property (nonatomic, weak) UIView *adContainer;

// MARK: - Initializers

/// Default initializer.
- (instancetype)init;

/// Convenient initializer creating an instance of `GADMAdapterTeadsExtras` from `GADRequest` `additionalParameters`.
///
/// + Doc for [GADRequest](https://developers.google.com/admob/ios/api/reference/Classes/GADRequest#-registeradnetworkextras)
///
/// - parameter parameters: `GADRequest` additional parameters.
- (instancetype)initWithRequestAdditionalParameters:(NSDictionary *)parameters;

// MARK: - Helpers

/// Creates an instance of `GADCustomEventExtras` used when sending ad network extras for
/// custom event requests (interstitial and banners) through `GADRequest`.
///
/// + Doc for [GADRequest](https://developers.google.com/admob/ios/api/reference/Classes/GADRequest#-registeradnetworkextras)
/// + Doc for [GADCustomEventExtras](https://developers.google.com/admob/ios/api/reference/Classes/GADCustomEventExtras#-setextrasforlabel)
///
/// - parameter label: Custom event label defined on AdMob dashboard used to identify the ad network.
/// - returns: A `GADCustomEventExtras` containing extra parameters.
- (GADCustomEventExtras *)getCustomEventExtrasForCustomEventLabel:(NSString *)label;

/// Creates an instance of `TeadsAdSettings` configured from ad network extra parameters.
///
/// + Doc for [GADRequest](https://developers.google.com/admob/ios/api/reference/Classes/GADRequest#-registeradnetworkextras)
///
/// - returns: A `TeadsAdSettings` containing settings to configure Teads ads.
- (TeadsAdSettings *)getTeadsAdSettings;

@end

NS_ASSUME_NONNULL_END
