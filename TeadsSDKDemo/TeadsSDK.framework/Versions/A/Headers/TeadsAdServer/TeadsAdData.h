//
//  TeadsAdData.h
//  TeadsSDKDev
//
//  Created by Ibrahim Ennafaa on 23/05/2014.
//  Copyright (c) 2014 Ebuzzing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TeadsSKVASTModel.h"
#import <UIKit/UIKit.h>
#import "TeadsContentValues.h"
#import "TeadsContentBehavior.h"
#import "TeadsContentComponents.h"
#import "TeadsContentBehavior.h"
#import "TeadsCloseButton.h"
#import "TeadsSoundButton.h"
#import "TeadsCallButton.h"
#import "TeadsLabel.h"
#import "TeadsCredits.h"
#import "TeadsEndScreen.h"

typedef enum : NSUInteger {
    TeadsCreativeDataVast,
    TeadsCreativeDataUrl
} TeadsCreativeDataType;

typedef enum {
    TeadsNativeVideoClickModeBrowser,
    TeadsNativeVideoClickModeFullscreen,
    TeadsNativeVideoClickModePlayPause,
} TeadsNativeVideoClickMode;

typedef enum {
    TeadsNativeVideoStartModeViewToPlay,
    TeadsNativeVideoStartModeClickToPlay,
} TeadsNativeVideoStartMode;

typedef enum {
    TeadsNativeVideoEndscreenTypeNone,
    TeadsNativeVideoEndscreenTypeImage,
    TeadsNativeVideoEndscreenTypeWebsite,
    TeadsNativeVideoEndscreenTypePlaylist,
} TeadsNativeVideoEndscreenType;

typedef enum {
    TeadsNativeVideoSoundModeOnWithControl,
    TeadsNativeVideoSoundModeOnWithoutControl,
    TeadsNativeVideoSoundModeOffWithControl,
} TeadsNativeVideoSoundMode;

typedef enum {
    TeadsVideoApiFrameworkVpaid,
    TeadsVideoApiFrameworkMraid,
    TeadsVideoApiFrameworkNative,
} TeadsVideoApiFrameworkType;

@interface TeadsAdData : NSObject

@property (nonatomic) TeadsCreativeDataType typeCreativeData;

/* ad content */
@property (nonatomic, strong) NSString *html;
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) TeadsSKVASTModel *vast;

// VAST properties
@property (nonatomic) TeadsVideoApiFrameworkType apiFrameWorkType;
@property (nonatomic, strong) NSURL *mediaFileUrl;
@property (nonatomic, strong) NSString *adParameters;
@property (nonatomic, strong) NSURL *clickThroughUrl;
@property (nonatomic, strong) NSArray *impressions;
@property (nonatomic, strong) NSArray *errors;
@property (nonatomic, strong) NSArray *clickTrackings;
@property (nonatomic, strong) NSString *duration;

@property (nonatomic, copy) NSDictionary *headers;

- (TeadsAdData*)initWithUrl:(NSURL*)url;
- (TeadsAdData*)initWithVast:(TeadsSKVASTModel*)vast;

/* ad info */
@property (nonatomic, strong) NSString* pid;
@property (nonatomic) BOOL hasAd;
@property (nonatomic) NSInteger contentPlayHead;

/* ad settings */
@property (nonatomic, strong) TeadsContentValues *values;
@property (nonatomic, strong) TeadsContentBehavior *behavior;
@property (nonatomic, strong) TeadsContentComponents *components;

/* ad events */
@property (nonatomic, strong) NSMutableDictionary *events;

- (void)loadEvents:(NSArray*)events;
- (void)resetEventProcessedStatus;
- (BOOL)loadSettings:(NSDictionary *)settings;

- (void)trackError:(NSString *)code;
- (void)trackImpression;
- (void)trackCreativeView;
- (void)trackStart;
- (void)trackResume;
- (void)trackPause;
- (void)trackRewind;

- (void)trackFirstQuartile;
- (void)trackMidPoint;
- (void)trackThirdQuartile;
- (void)trackComplete;

- (void)trackMute;
- (void)trackUnmute;
- (void)trackSkip;

- (void)trackExpand;
- (void)trackFullscreen;
- (void)trackCollapse;
- (void)trackExitFullscreen;
- (void)trackClose;

- (void)trackClickTracking;
- (void)trackCustomClick;
- (void)trackProgressEvent:(NSTimeInterval)playbackTime;
- (BOOL)trackRewardEvent:(NSTimeInterval)playbackTime;

- (NSArray*)getProgressEvents;
- (NSArray*)getRewardEvents;

@end
