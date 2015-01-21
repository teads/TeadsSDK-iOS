//
//  TeadsRewardInfo.h
//  
//
//  Created by Ibrahim Ennafaa on 10/03/2014.
//  Copyright (c) 2014 Ebuzzing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TeadsRewardInfo : NSObject

- (id)initWithUserId:(NSString*)userId andDebugEnabled:(BOOL)debugEnabled;

- (BOOL)isDebugEnabled;

- (NSString*)getUserId;

- (NSString*)toJsonString;

@end
