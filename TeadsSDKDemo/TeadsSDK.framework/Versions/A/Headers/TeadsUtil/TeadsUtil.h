//
//  TeadsInformation.h
//  TeadsSDK
//
//  Created by Ibrahim Ennafaa on 31/08/2015.
//  Copyright (c) 2015 Teads. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TeadsUtil : NSObject

+(NSString *)appId;
+(NSString *)appVersion;
+(NSString *)userAgent;

+(NSString *)carrier;
+(NSString *)country;
+(NSString *)locale;
+(NSString *)network;
+(NSString *)location;
+(NSString *)userId;
+(BOOL)hasNetwork;

+(NSString *)os;
+(NSString *)osVersion;

+(NSString *)deviceFamily;
+(NSString *)deviceType;
+(NSString *)deviceModel;

@end
