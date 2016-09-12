//
//  TeadsError.h
//  TeadsSDK
//
//  Created by Ibrahim Ennafaa on 10/03/2014.
//  Copyright (c) 2016 Teads. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum TeadsErrorEnum {
    TeadsNoSlotAvailable,
    TeadsServerError,
    TeadsNetworkError,
    TeadsParseTimeout,
    TeadsNotFilled,
    TeadsVastError,
    TeadsDisplayError,
    TeadsSettingsError,
    TeadsServerBadResponse,
    TeadsInternalError,
    TeadsNoNetwork
} TeadsErrorType;

/**
 * The object used for Teads errors
 */
@interface TeadsError : NSObject

-(BOOL)isType:(TeadsErrorType)errorType;

/**
 * Type of TeadsError
 */
@property (nonatomic) TeadsErrorType type;
/**
 * TeadsError name String
 */
@property (nonatomic, strong) NSString *name;
/**
 * TeadsError message String
 */
@property (nonatomic, strong) NSString *message;
/**
 * TeadsError code String
 */
@property (nonatomic, strong) NSString *code;

+ (TeadsError *)noSlotAvailable;
+ (TeadsError *)serverError:(NSString *)code;
+ (TeadsError *)networkError;
+ (TeadsError *)noNetwork;
+ (TeadsError *)parseTimeout;
+ (TeadsError *)notFilled;
+ (TeadsError *)vastError:(NSString *)code;
+ (TeadsError *)displayError;
+ (TeadsError *)settingsError;
+ (TeadsError *)jsonCorrupted;
+ (TeadsError *)serverBadResponse;
+ (TeadsError *)internalError;

@end
