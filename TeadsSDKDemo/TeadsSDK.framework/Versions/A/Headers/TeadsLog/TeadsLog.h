//  TeadsLog.h
//  TeadsSDK
//
//  Created by Ibrahim Ennafaa on 05/19/14.
//  Copyright (c) 2014 Ebuzzing. All rights reserved.
//

#import <Foundation/Foundation.h>

#define PREFIX_LOG_ERROR    @"Teads_Error"
#define PREFIX_LOG_INFO     @"Teads_Info"
#define PREFIX_LOG_VERBOSE  @"Teads_Verbose"

//Log functions
#define TeadsLogError(fmt, ...)       [TeadsLog logErrorWithFunctionName:[NSString stringWithFormat:@"%s", __PRETTY_FUNCTION__] forLine:[NSString stringWithFormat:@"%d", __LINE__] format:fmt, ##__VA_ARGS__ ];
#define TeadsLogInfo(fmt, ...)        [TeadsLog logInfoWithFunctionName:[NSString stringWithFormat:@"%s", __PRETTY_FUNCTION__] forLine:[NSString stringWithFormat:@"%d", __LINE__] format:fmt, ##__VA_ARGS__ ];
#define TeadsLogVerbose(fmt, ...)     [TeadsLog logVerboseWithFunctionName:[NSString stringWithFormat:@"%s", __PRETTY_FUNCTION__] forLine:[NSString stringWithFormat:@"%d", __LINE__] format:fmt, ##__VA_ARGS__ ];

typedef enum {
    TeadsDebugLevelInactive   = 0,
    TeadsDebugLevelError      = 1,
    TeadsDebugLevelInfo       = 2,
    TeadsDebugLevelVerbose    = 3,
} TeadsDebugLevelType;

@interface TeadsLog : NSObject

@property TeadsDebugLevelType debugLevel;

+(TeadsLog *)sharedInstance;

+(void)logErrorWithFunctionName:(NSString*)functionName forLine:(NSString *)line format:(NSString *)format, ...;
+(void)logInfoWithFunctionName:(NSString*)functionName forLine:(NSString *)line format:(NSString *)format, ...;
+(void)logVerboseWithFunctionName:(NSString*)functionName forLine:(NSString *)line format:(NSString *)format, ...;

+(void) setLevelType:(TeadsDebugLevelType)levelType;

@end
