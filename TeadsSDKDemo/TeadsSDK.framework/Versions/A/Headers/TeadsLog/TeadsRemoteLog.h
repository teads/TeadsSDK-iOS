//
//  TeadsRemoteLog.h
//  TeadsSDK
//
//  Created by Ibrahim Ennafaa on 28/08/2015.
//  Copyright (c) 2015 Teads. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NSDictionary* (^BasicParamsBlock)();

@interface TeadsRemoteLog : NSObject {
    BOOL ready;
    
    BOOL shouldSendErrors;
    NSString *collectorUrl;
    float amount;
    NSArray *appsIds;
}

+ (id)sharedInstance;

-(void)sendErrorwithData:(NSDictionary *)data;
-(void)sendEvent:(NSString *)eventName withData:(NSDictionary *)data;

-(BOOL)isReady;

/* Configure */
+(void)configureWithHostAppId:(NSString *)appId settingsUrl:(NSString *)url andBasicParamsBlock:(BasicParamsBlock)paramsBlock;

@end
