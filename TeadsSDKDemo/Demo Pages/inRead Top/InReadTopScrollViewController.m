//
//  InReadTopScrollViewController.m
//  TeadsSDKDemo
//
//  Created by Nikolaï Roycourt on 16/01/2015.
//  Copyright (c) 2015 Teads. All rights reserved.
//

#import "InReadTopScrollViewController.h"

@interface InReadTopScrollViewController ()

@property (strong, nonatomic) TeadsAd *teadsAd;

@end

@implementation InReadTopScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.scrollView.delegate = self;
    
    self.navigationItem.title = @"inRead Top ScrollView";
    
    NSString *pid = [[NSUserDefaults standardUserDefaults] stringForKey:@"pid"];
    
    self.teadsAd = [[TeadsAd alloc] initInReadTopWithPlacementId:pid scrollView:self.scrollView delegate:self];
    //Set background color to match parent container
    [self.teadsAd setBackgroundColor:[UIColor whiteColor]];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.teadsAd.isLoaded) {
        [self.teadsAd viewControllerAppeared:self];
    } else {
        [self.teadsAd load];
    }
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.teadsAd viewControllerDisappeared:self];
}

#pragma mark -
#pragma mark - TeadsVideoDelegate

/**
 * NativeVideo Failed to Load
 *
 * @param interstitial  : the TeadsVideo object
 * @param error         : the TeadsError object
 */
- (void)teadsAd:(TeadsAd *)video didFailLoading:(TeadsError *)error {
    
}

/**
 * NativeVideo Will Load (loading)
 *
 * @param interstitial  : the TeadsVideo object
 */
- (void)teadsAdWillLoad:(TeadsAd *)video {
    
}

/**
 * NativeVideo Did Load (loaded successfully)
 *
 * @param interstitial  : the TeadsVideo object
 */
- (void)teadsAdDidLoad:(TeadsAd *)video {
    
}

/**
 * NativeVideo Will Start Playing (loading)
 *
 * @param nativeVideo  : the TeadsVideo object
 */
- (void)teadsAdWillStart:(TeadsAd *)video {
    
}

/**
 * NativeVideo Did Start Playing (playing)
 *
 * @param nativeVideo  : the TeadsVideo object
 */
- (void)teadsAdDidStart:(TeadsAd *)video {
    
}

/**
 * NativeVideo Will Stop Playing (stopping)
 *
 * @param nativeVideo  : the TeadsVideo object
 */
- (void)teadsAdWillStop:(TeadsAd *)video {
    
}

/**
 * NativeVideo Did Stop Playing (stopped)
 *
 * @param nativeVideo  : the TeadsVideo object
 */
- (void)teadsAdDidStop:(TeadsAd *)video {
    
}

/**
 * NativeVideo Did Pause (paused)
 *
 * @param nativeVideo  : the TeadsVideo object
 */
- (void)teadsAdDidPause:(TeadsAd *)video {
    
}

/**
 * NativeVideo Did Resume (playing)
 *
 * @param nativeVideo  : the TeadsVideo object
 */
- (void)teadsAdDidResume:(TeadsAd *)video {
    
}

/**
 * NativeVideo Did Mute Sound
 *
 * @param nativeVideo  : the TeadsVideo object
 */
- (void)teadsAdDidMute:(TeadsAd *)video {
    
}

/**
 * NativeVideo Did Unmute Sound
 *
 * @param nativeVideo  : the TeadsVideo object
 */
- (void)teadsAdDidUnmute:(TeadsAd *)video {
    
}

/**
 * NativeVideo Will expand
 *
 * @param nativeVideo  : the TeadsVideo object
 */
- (void)teadsAdCanExpand:(TeadsAd *)video {
    
}

/**
 * NativeVideo Did expand
 *
 * @param nativeVideo  : the TeadsVideo object
 */
- (void)teadsAdDidExpand:(TeadsAd *)video {
    
}

/**
 * NativeVideo Will collapse
 *
 * @param nativeVideo  : the TeadsVideo object
 */
- (void)teadsAdWillCollapse:(TeadsAd *)video {
    
}

/**
 * NativeVideo did collapse
 *
 * @param nativeVideo  : the TeadsVideo object
 */
- (void)teadsAdDidCollapse:(TeadsAd *)video {
    
}

/**
 * NativeVideo was clicked
 *
 * @param nativeVideo  : the TeadsVideo object
 */
- (void)teadsAdWasClicked:(TeadsAd *)video {
    
}

/**
 * NativeVideo Did Stop Playing (stopped)
 *
 * @param nativeVideo  : the TeadsVideo object
 */
- (void)teadsAdDidClickBrowserClose:(TeadsAd *)video {
    
}

/**
 * NativeVideo Will Take Over Fullscreen
 *
 * @param nativeVideo  : the TeadsVideo object
 */
- (void)teadsAdWillTakeOverFullScreen:(TeadsAd *)video {
    
}

/**
 * NativeVideo Did Take Over Fullscreen
 *
 * @param nativeVideo  : the TeadsVideo object
 */
- (void)teadsAdDidTakeOverFullScreen:(TeadsAd *)video {
    
}

/**
 * NativeVideo Will Dismiss Fullscreen
 *
 * @param nativeVideo  : the TeadsVideo object
 */
- (void)teadsAdWillDismissFullscreen:(TeadsAd *)video {
    
}

/**
 * NativeVideo Did Dismiss Fullscreen
 *
 * @param nativeVideo  : the TeadsVideo object
 */
- (void)teadsAdDidDismissFullscreen:(TeadsAd *)video {
    
}

/**
 * NativeVideo Skip Button Was Tapped (skip button pressed)
 *
 * @param nativeVideo  : the TeadsVideo object
 */
- (void)teadsAdSkipButtonTapped:(TeadsAd *)video {
    
}

/**
 * NativeVideo Skip Button Did Show (skip button appeared)
 *
 * @param nativeVideo  : the TeadsVideo object
 */
- (void)teadsAdSkipButtonDidShow:(TeadsAd *)video {
    
}

/**
 * NativeVideo did clean (all related resoures have been removed)
 *
 * @param nativeVideo  : the TeadsVideo object
 */
- (void)teadsAdDidClean:(TeadsAd *)video {
    
}


@end
