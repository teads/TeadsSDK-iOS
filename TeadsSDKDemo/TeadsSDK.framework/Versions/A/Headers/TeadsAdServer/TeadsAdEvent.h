//
//  TeadsAdEvent.h
//  TeadsSDKDev
//
//  Created by Ibrahim Ennafaa on 24/06/2014.
//  Copyright (c) 2014 Ebuzzing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define TEADS_IMPRESSION_TRACKING         @"impression"
#define TEADS_CREATIVE_VIEW_TRACKING      @"creativeView"
#define TEADS_START_TRACKING              @"start"
#define TEADS_RESUME_TRACKING             @"resume"
#define TEADS_PAUSE_TRACKING              @"pause"
#define TEADS_REWIND_TRACKING             @"rewind"
#define TEADS_FIRST_QUARTILE_TRACKING     @"firstQuartile"
#define TEADS_MID_POINT_TRACKING          @"midpoint"
#define TEADS_THIRD_QUARTILE_TRACKING     @"thirdQuartile"
#define TEADS_COMPLETE_TRACKING           @"complete"
#define TEADS_MUTE_TRACKING               @"mute"
#define TEADS_CLOSE_TRACKING              @"close"
#define TEADS_UNMUTE_TRACKING             @"unmute"
#define TEADS_SKIP_TRACKING               @"skip"
#define TEADS_EXPAND_TRACKING             @"expand"
#define TEADS_FULLSCREEN_TRACKING         @"fullscreen"
#define TEADS_EXIT_FULLSCREEN_TRACKING    @"exitFullscreen"
#define TEADS_COLLAPSE_TRACKING           @"collapse"
#define TEADS_CLICK_TRACKING              @"clickTracking"
#define TEADS_CUSTOM_CLICK_TRACKING       @"customClick"
#define TEADS_PROGRESS_TRACKING           @"progress"
#define TEADS_REWARD_TRACKING             @"reward"

#define TIME_EVENTS @[TEADS_FIRST_QUARTILE_TRACKING, TEADS_MID_POINT_TRACKING, TEADS_THIRD_QUARTILE_TRACKING, TEADS_COMPLETE_TRACKING]

@interface TeadsAdEvent : NSObject

@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) NSMutableArray *urls;

@property (nonatomic) BOOL isProgress;

@property (nonatomic) BOOL isReward;

@property (nonatomic) BOOL isProcessed;

@property (nonatomic) BOOL isTime;

@property (nonatomic, strong) NSString *offset;
@property (nonatomic) NSTimeInterval offsetInterval;

-(void)setOffset:(NSString *)offset duration:(NSString *)duration;

- (void)addUrl:(NSString*)url;
- (void)addUrls:(NSArray*)urls;

@end