//
//  MPAdapterTeadsBanner.h
//  TeadsMoPubAdapter
//
//  Created by athomas on 30/05/2018.
//  Copyright © 2018 Teads. All rights reserved.
//

#import <Foundation/Foundation.h>

#if __has_include(<MoPub/MoPub.h>)
    #import <MoPub/MoPub.h>
#elif __has_include(<MoPubSDKFramework/MoPub.h>)
    #import <MoPubSDKFramework/MoPub.h>
#else
    #import "MPBannerCustomEvent.h"
#endif

NS_ASSUME_NONNULL_BEGIN

/// Class adapting Teads banner to work with MoPub mediation.
@interface MPAdapterTeadsBanner : MPBannerCustomEvent

@end

NS_ASSUME_NONNULL_END
