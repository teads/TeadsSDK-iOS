//
//  TeadsError.h
//  TeadsSDK
//
//  Created by Ibrahim Ennafaa on 10/03/2014.
//  Copyright (c) 2014 Ebuzzing. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum TeadsErrorEnum {
	TeadsNetworkError = 0,
	TeadsAdServerError = 1,
	TeadsAdServerBadResponse = 2,
	TeadsAdFailsToLoad = 3,
    TeadsNoAdsAvailable = 4,
    TeadsTimeoutError = 5,
    TeadsLoadOperationCancelled = 6
} TeadsErrorType;

@interface TeadsError : NSObject

-(BOOL)isType:(TeadsErrorType)errorType;

@property (nonatomic) TeadsErrorType code;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *message;

+(TeadsError*)networkError;
+(TeadsError*)timeoutError;
+(TeadsError*)adServerError;
+(TeadsError*)adServerBadResponse;
+(TeadsError*)adFailsToLoad;
+(TeadsError*)noAdsAvailable;
+(TeadsError*)loadOperationCancelled;

@end
