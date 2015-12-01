//
//  TeadsError.h
//  TeadsSDK
//
//  Created by Ibrahim Ennafaa on 10/03/2014.
//  Copyright (c) 2014 Ebuzzing. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum TeadsErrorEnum {
    TeadsNoSlotAvailable,
    TeadsServerError,
    TeadsConnectionError,
    TeadsParseTimeout,
    TeadsNoAdsAvailable,
    TeadsVastError,
    TeadsSettingsError,
    TeadsServerBadResponse,
    TeadsInternalError
} TeadsErrorType;

@interface TeadsError : NSObject

-(BOOL)isType:(TeadsErrorType)errorType;

@property (nonatomic) TeadsErrorType code;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *message;

+ (TeadsError *)noSlotAvailable;
+ (TeadsError *)serverError:(NSString *)code;
+ (TeadsError *)connectionTimeout;
+ (TeadsError *)noNetwork;
+ (TeadsError *)parseTimeout;
+ (TeadsError *)noAdsAvailable;
+ (TeadsError *)vastError:(NSString *)code;
+ (TeadsError *)settingsError;
+ (TeadsError *)jsonCorrupted;
+ (TeadsError *)serverBadResponse;
+ (TeadsError *)internalError;

@end
