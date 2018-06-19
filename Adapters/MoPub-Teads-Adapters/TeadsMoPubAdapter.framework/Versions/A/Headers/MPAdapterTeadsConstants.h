//
//  MPAdapterTeadsConstants.h
//  TeadsMoPubAdapter
//
//  Created by athomas on 29/05/2018.
//  Copyright © 2018 Teads. All rights reserved.
//

#ifndef MPAdapterTeadsConstants_h
#define MPAdapterTeadsConstants_h

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// Constants defined for Teads Adapter

static NSString * const kTeadsPIDKey = @"PID";
static NSString * const TeadsAdapterErrorDomain = @"tv.teads.adapter.mopub";

enum {
    PIDNotFound,
    LoadingFailure
};
typedef NSInteger TeadsAdapterErrorCode;

NS_ASSUME_NONNULL_END

#endif /* MPAdapterTeadsConstants_h */
