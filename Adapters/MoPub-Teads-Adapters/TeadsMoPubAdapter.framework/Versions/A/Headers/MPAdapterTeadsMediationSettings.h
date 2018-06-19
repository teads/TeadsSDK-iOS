//
//  MPAdapterTeadsMediationSettings.h
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
    #import "MPMediationSettingsProtocol.h"
#endif

NS_ASSUME_NONNULL_BEGIN

@class TeadsAdSettings;

/// Class encapsulating MoPub mediation settings for Teads custom events.
@interface MPAdapterTeadsMediationSettings : NSObject <MPMediationSettingsProtocol>

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

// MARK: - Helpers

/// Creates an instance of `TeadsAdSettings` configured from mediation settings.
/// - returns: A `TeadsAdSettings` containing settings to configure Teads ads.
- (TeadsAdSettings *)getTeadsAdSettings;

@end

NS_ASSUME_NONNULL_END
