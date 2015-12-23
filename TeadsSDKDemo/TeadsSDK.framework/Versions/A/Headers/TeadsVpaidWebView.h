//
//  TeadsVpaidWebView.h
//  TeadsSDK
//
//  Created by Ibrahim Ennafaa on 28/05/2015.
//  Copyright (c) 2015 Teads. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    TeadsCuePointStart,
    TeadsCuePointFirstQuartile,
    TeadsCuePointMidpoint,
    TeadsCuePointThirdQuartile,
    TeadsCuePointComplete,
} TeadsCuePointType;

typedef enum {
    TeadsVpaidAdLoaded,
    TeadsVpaidAdStarted,
    TeadsVpaidAdStopped,
} TeadsVpaidAdStatus;

typedef enum {
    TeadsVpaidAdVideoPlaying,
    TeadsVpaidAdVideoPaused,
    TeadsVpaidAdVideoStopped,
} TeadsVpaidAdVideoStatus;

#define VOLUME_STEP_COUNT 30

@protocol TeadsVpaidWebViewDelegate;

@interface TeadsVpaidWebView : UIView <UIWebViewDelegate>

//////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Properties
#pragma mark -
/////////////////////////////////////////////////////////////

@property (nonatomic) TeadsVpaidAdStatus adStatus;
@property (nonatomic) TeadsVpaidAdVideoStatus adVideoStatus;
@property (nonatomic, strong) NSNumber *adDuration;
@property (nonatomic, strong) NSNumber *adRemainingTime;
@property (nonatomic, strong) NSNumber *adVolume;
@property (nonatomic) float maxVolume;
@property (nonatomic) float volumeFadeDuration; // ms

@property (nonatomic) UIWebView *webView;

@property (nonatomic, weak) id<TeadsVpaidWebViewDelegate> delegate;

//////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Methods
#pragma mark -
/////////////////////////////////////////////////////////////

-(id)initWithFrame:(CGRect)frame andDelegate:(id<TeadsVpaidWebViewDelegate>)delegate;

-(void)loadVpaid:(NSURL *)url adParameters:(NSString *)adParameters;

-(void)resume;
-(void)pause;
-(void)stop;
-(void)skip;
-(void)mute:(BOOL)muted;

@end

@protocol TeadsVpaidWebViewDelegate <NSObject>

- (void)vpaidWebViewDidLoad:(TeadsVpaidWebView *)vpaidWebView;

- (void)vpaidWebViewDidStart:(TeadsVpaidWebView *)vpaidWebView;
- (void)vpaidWebViewDidStop:(TeadsVpaidWebView *)vpaidWebView;
- (void)vpaidWebViewDidRaiseError:(TeadsVpaidWebView *)vpaidWebView;
- (void)vpaidWebViewDidRaiseImpression:(TeadsVpaidWebView *)vpaidWebView;

- (void)vpaidWebViewDidResumeVideo:(TeadsVpaidWebView *)vpaidWebView;
- (void)vpaidWebViewDidPauseVideo:(TeadsVpaidWebView *)vpaidWebView;

- (void)vpaidWebViewDidSkip:(TeadsVpaidWebView *)vpaidWebView;
- (void)vpaidWebViewDidEnableSkipButton:(TeadsVpaidWebView *)vpaidWebView;
- (void)vpaidWebViewDidMute:(TeadsVpaidWebView *)vpaidWebView;
- (void)vpaidWebViewDidUnmute:(TeadsVpaidWebView *)vpaidWebView;

- (void)vpaidWebViewDidChangeCurrentTime:(TeadsVpaidWebView *)vpaidWebView;
- (void)vpaidWebView:(TeadsVpaidWebView *)vpaidWebView didReachCuePoint:(TeadsCuePointType)cuePointType;

- (void)vpaidWebViewDidClick:(TeadsVpaidWebView *)vpaidWebView;
- (void)vpaidWebView:(TeadsVpaidWebView *)vpaidWebView requestOpenUrl:(NSString *)urlString;

@end
