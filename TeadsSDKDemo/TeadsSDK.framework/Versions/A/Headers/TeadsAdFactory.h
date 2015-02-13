//
//  TeadsAdFactory.h
//  TeadsSDK
//
//  Created by Ibrahim Ennafaa on 05/02/2015.
//  Copyright (c) 2015 Teads. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TeadsError.h"

typedef enum {
    TeadsNativeVideoAdType,
    TeadsFullscreenAdType
} TeadsAdType;

@protocol TeadsAdFactoryDelegate;

@interface TeadsAdFactory : NSObject

+ (void)setDelegate:(id<TeadsAdFactoryDelegate>)delegate;

+ (void)loadNativeVideoAdWithPid:(NSString *)pid;
+ (void)loadFullscreenAdWithPid:(NSString *)pid;

+ (id)popNativeVideoAdWithPid:(NSString *)pid;
+ (id)popFullscreenAdWithPid:(NSString *)pid;

@end

@protocol TeadsAdFactoryDelegate <NSObject>

@optional

- (void)teadsAdType:(TeadsAdType)type withPid:(NSString *)pid didFailLoading:(TeadsError *)error;

- (void)teadsAdType:(TeadsAdType)type willLoad:(NSString *)pid;

- (void)teadsAdType:(TeadsAdType)type didLoad:(NSString *)pid;

- (void)teadsAdType:(TeadsAdType)type wasConsumed:(NSString *)pid;

- (void)teadsAdType:(TeadsAdType)type DidExpire:(NSString *)pid;

@end
