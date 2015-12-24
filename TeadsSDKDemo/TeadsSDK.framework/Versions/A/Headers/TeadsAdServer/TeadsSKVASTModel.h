//
//  SKVASTModel.h
//  VAST
//
//  Created by Jay Tucker on 10/4/13.
//  Copyright (c) 2013 Nexage. All rights reserved.
//
//  VASTModel provides access to VAST document elements; the VAST2Parser result is stored here.

#import <Foundation/Foundation.h>

@class TeadsSKVASTUrlWithId;

@interface TeadsSKVASTModel : NSObject

// returns the version of the VAST document 
- (NSString *)vastVersion;

// returns an array of VASTUrlWithId objects (although the id will always be nil)
- (NSArray *)errors;

// returns an array of VASTUrlWithId objects
- (NSArray *)impressions;

- (NSString *)duration;

- (NSString *)skipOffset;

// returns a dictionary whose keys are the names of the event ("start", "midpoint", etc.)
// and whose values are arrays of NSURL objects
- (NSDictionary *)trackingEvents;

- (NSArray *)trackingEventsArray;

// returns the ClickThrough URL
- (TeadsSKVASTUrlWithId *)clickThrough;

// returns an array of VASTUrlWithId objects
- (NSArray *)clickTracking;

// returns an array of VASTMediaFile objects
- (NSArray *)mediaFiles;

// returns a string representing adParameters
- (NSString *)adParameters;

@end
