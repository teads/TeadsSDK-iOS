//
//  TeadsAdServer.h
//  TeadsSDKDev
//
//  Created by Emmanuel Digiaro on 5/6/14.
//  Copyright (c) 2014 Ebuzzing. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TeadsAdRequestError.h"
#import "TeadsAdData.h"

#define TEADS_AD_SERVER_URL @"http://r.teads.tv/rich/%@?responseSerialization=%@" // version string
#define TEADS_TRACKING_URL  @"http://t.teads.tv/track?action=%@&pid=%@&%f" // eventName, PID, timestamp

#define VAST_XML_TYPE       @"VastXml"

typedef void (^SendEventBlock)(NSString *url);
typedef NSDictionary* (^RequestParamsBlock)();

typedef enum {
    TeadsAdServerResponseVersion1,
    TeadsAdServerResponseVersion2,
} TeadsAdServerResponseVersion;

typedef enum {
    TeadsAdServerResponseVastXml,
    TeadsAdServerResponseVastUrl,
    TeadsAdServerResponseHtml,
} TeadsAdServerResponseType;


@interface TeadsAdServer : NSObject

// Placement
@property (nonatomic, retain) NSString *placementId;

/* Ad Server */
@property (nonatomic) TeadsAdServerResponseType responseType;
- (NSString *)adServerUrl;

- (id)initWithPlacementId:(NSString *)placementId;

- (void)getAdWithCompletionHandler:(void (^)(TeadsAdData *adData))completionSuccess failure: (void (^)(TeadsAdRequestError *error))completionFailure ;
- (void)cancelLoad;
- (void)forceUrl:(NSString *)url;

+ (NSData *)sendSynchronousRequestWithURL:(NSURL *)url returningResponse:(NSURLResponse **)response error:(NSError **)error;

- (void)trackPlacementCall;
- (void)trackNoSlot;
- (void)trackAdAvailable;
- (void)trackAdNotAvailable:(TeadsAdRequestError *)error;
- (void)trackAd;
- (void)trackNoAd:(TeadsAdRequestError *)error;
- (void)trackAdCall;

+ (void)trackUrl:(NSString *)url;

+ (NSString *)userAgent;

+ (void)configureWithResponseVersion:(TeadsAdServerResponseVersion)version hostUserAgent:(NSString*)userAgent sendEventBlock:(SendEventBlock)sendEvent andRequestParamsBlock:(RequestParamsBlock)requestParams;

@end