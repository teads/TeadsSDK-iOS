//
//  TeadsContentSettings.h
//  TeadsSDK
//
//  Created by Bastien Lefrant on 16/07/2015.
//  Copyright (c) 2015 Teads. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol TeadsContentSettingsProtocol <NSObject>

@required
- (BOOL)loadDictionary:(NSDictionary *)propertiesDictionary;

@end

@interface TeadsContentSettings : NSObject

+ (NSNumber *)getNumberValue:(id)parameter;
+ (NSString *)getStringValue:(id)parameter;

+ (BOOL)isBase64Data:(NSString *)string;

@end