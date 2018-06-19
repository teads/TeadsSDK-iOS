//
//  MPAdapterTeadsRewardedVideo.h
//  TeadsMoPubAdapter
//
//  Created by athomas on 29/05/2018.
//  Copyright © 2018 Teads. All rights reserved.
//

#import <Foundation/Foundation.h>

#if __has_include(<MoPub/MoPub.h>)
    #import <MoPub/MoPub.h>
#elif __has_include(<MoPubSDKFramework/MoPub.h>)
    #import <MoPubSDKFramework/MoPub.h>
#else
    #import "MPRewardedVideoCustomEvent.h"
#endif

NS_ASSUME_NONNULL_BEGIN

/// Class adapting Teads rewarded ad to work with MoPub mediation.
@interface MPAdapterTeadsRewardedVideo : MPRewardedVideoCustomEvent

@end

NS_ASSUME_NONNULL_END
