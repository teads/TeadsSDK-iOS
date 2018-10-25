//
//  GADMAdapterTeadsBanner.h
//  TeadsAdMobAdapter
//
//  Created by athomas on 29/05/2018.
//  Copyright © 2018 Teads. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GoogleMobileAds/GoogleMobileAds.h>

NS_ASSUME_NONNULL_BEGIN

/// Class adapting Teads banner to work with Google Mobile Ads mediation.
@interface GADMAdapterTeadsBanner : NSObject <GADCustomEventBanner>

@end

NS_ASSUME_NONNULL_END
