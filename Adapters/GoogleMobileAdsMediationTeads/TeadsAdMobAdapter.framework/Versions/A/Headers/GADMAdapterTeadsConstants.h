//
//  GADMAdapterTeadsConstants.h
//  TeadsAdMobAdapter
//
//  Created by athomas on 29/05/2018.
//  Copyright © 2018 Teads. All rights reserved.
//

#ifndef GADMAdapterTeadsConstants_h
#define GADMAdapterTeadsConstants_h

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// Constants defined for Teads Adapter

static NSString * const TeadsAdapterErrorDomain = @"tv.teads.adapter.admob";

enum {
    PIDNotFound,
    LoadingFailure
};
typedef NSInteger TeadsAdapterErrorCode;

NS_ASSUME_NONNULL_END

#endif /* GADMAdapterTeadsConstants_h */
