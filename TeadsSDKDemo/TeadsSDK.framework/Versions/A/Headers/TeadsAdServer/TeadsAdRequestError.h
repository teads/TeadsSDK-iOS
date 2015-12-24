//
//  TeadsAdRequestError.h
//  TeadsSDK
//
//  Created by Ibrahim Ennafaa on 18/12/2015.
//  Copyright (c) 2014 Teads. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum TeadsAdRequestErrorEnum {
    TeadsAdRequestServerError,
    TeadsAdRequestNetworkError,
    TeadsAdRequestParseTimeout,
    TeadsAdRequestNotFilled,
    TeadsAdRequestVastError,
    TeadsAdRequestSettingsError,
    TeadsAdRequestServerBadResponse,
} TeadsAdRequestErrorType;

@interface TeadsAdRequestError : NSObject

-(BOOL)isType:(TeadsAdRequestErrorType)errorType;

@property (nonatomic) TeadsAdRequestErrorType type;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *code;

+ (TeadsAdRequestError *)serverError:(NSString *)code;
+ (TeadsAdRequestError *)connectionTimeout;
+ (TeadsAdRequestError *)parseTimeout;
+ (TeadsAdRequestError *)notFilled;
+ (TeadsAdRequestError *)vastError:(NSString *)code;
+ (TeadsAdRequestError *)settingsError;
+ (TeadsAdRequestError *)jsonCorrupted;
+ (TeadsAdRequestError *)serverBadResponse;

@end
