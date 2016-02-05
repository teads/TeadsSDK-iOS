//
//  TeadsSDK.h
//  TeadsSDK
//
//  Created by Ibrahim Ennafaa on 23/12/2015.
//  Copyright © 2015 Teads. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <TeadsSDK/TeadsError.h>
#import <TeadsSDK/TeadsVideo.h>
#import <TeadsSDK/TeadsInterstitial.h>

typedef enum {
    TeadsLogLevelInactive   = 0,
    TeadsLogLevelError      = 1,
    TeadsLogLevelInfo       = 2,
    TeadslogLevelVerbose    = 3,
} TeadsLogLevelType;

@interface TeadsSDK : NSObject

+(void)setLogLevel:(TeadsLogLevelType)level; //Set the log level of Teads SDK

@end
