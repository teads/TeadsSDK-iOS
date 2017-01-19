//
//  TeadsSDK.h
//  TeadsSDK
//
//  Created by Ibrahim Ennafaa on 23/12/2015.
//  Copyright © 2015 Teads. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <TeadsSDK/TeadsError.h>
#import <TeadsSDK/TeadsAd.h>

/**
 * Possible log levels of Teads SDK
 *
 * @discussion Default level is TeadsDebugLevelError
 */
typedef enum {
    TeadsLogLevelInactive   = 0,
    TeadsLogLevelError      = 1,
    TeadsLogLevelInfo       = 2,
    TeadslogLevelVerbose    = 3,
} TeadsLogLevelType;

@interface TeadsSDK : NSObject

/**
 * Set the log level of Teads SDK
 *
 * @param level A TeadsLogLevelType value
 * @discussion Default level is TeadsDebugLevelError
 */
+(void)setLogLevel:(TeadsLogLevelType)level;
/**
 * Get Teads SDK version number
 */
+(NSString *)versionNumber;

@end
