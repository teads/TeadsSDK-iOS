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
    TeadsNetworkError,
    TeadsParseTimeout,
    TeadsNotFilled,
    TeadsVastError,
    TeadsSettingsError,
    TeadsServerBadResponse,
    TeadsInternalError,
    TeadsNoNetwork
} TeadsErrorType;

@interface TeadsError : NSObject

-(BOOL)isType:(TeadsErrorType)errorType;

@property (nonatomic) TeadsErrorType type;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *code;

+ (TeadsError *)noSlotAvailable;
+ (TeadsError *)serverError:(NSString *)code;
+ (TeadsError *)networkError;
+ (TeadsError *)noNetwork;
+ (TeadsError *)parseTimeout;
+ (TeadsError *)notFilled;
+ (TeadsError *)vastError:(NSString *)code;
+ (TeadsError *)settingsError;
+ (TeadsError *)jsonCorrupted;
+ (TeadsError *)serverBadResponse;
+ (TeadsError *)internalError;

@end
