//
//  InReadTopScrollViewController.m
//  TeadsSDKDemo
//
//  Created by Nikolaï Roycourt on 16/01/2015.
//  Copyright (c) 2015 Teads. All rights reserved.
//

#import "InReadTopScrollViewController.h"

@interface InReadTopScrollViewController ()

@property (strong, nonatomic) TeadsVideo *teadsVideo;

@end

@implementation InReadTopScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.scrollView.delegate = self;
    
    self.navigationItem.title = @"inRead Top ScrollView";
    
    NSString *pid = [[NSUserDefaults standardUserDefaults] stringForKey:@"pid"];
    
    self.teadsVideo = [[TeadsVideo alloc] initInReadTopWithPlacementId:pid scrollView:self.scrollView delegate:self];
    //Set background color to match parent container
    [self.teadsVideo setBackgroundColor:[UIColor whiteColor]];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.teadsVideo.isLoaded) {
        [self.teadsVideo viewControllerAppeared:self];
    } else {
        [self.teadsVideo load];
    }
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.teadsVideo viewControllerDisappeared:self];
}

#pragma mark -
#pragma mark - TeadsVideoDelegate

/**
 * NativeVideo Failed to Load
 *
 * @param interstitial  : the TeadsVideo object
 * @param error         : the TeadsError object
 */
- (void)teadsVideo:(TeadsVideo *)video didFailLoading:(TeadsError *)error {
    
}

/**
 * NativeVideo Will Load (loading)
 *
 * @param interstitial  : the TeadsVideo object
 */
- (void)teadsVideoWillLoad:(TeadsVideo *)video {
    
}

/**
 * NativeVideo Did Load (loaded successfully)
 *
 * @param interstitial  : the TeadsVideo object
 */
- (void)teadsVideoDidLoad:(TeadsVideo *)video {
    
}

/**
 * NativeVideo Will Start Playing (loading)
 *
 * @param nativeVideo  : the TeadsVideo object
 */
- (void)teadsVideoWillStart:(TeadsVideo *)video {
    
}

/**
 * NativeVideo Did Start Playing (playing)
 *
 * @param nativeVideo  : the TeadsVideo object
 */
- (void)teadsVideoDidStart:(TeadsVideo *)video {
    
}

/**
 * NativeVideo Will Stop Playing (stopping)
 *
 * @param nativeVideo  : the TeadsVideo object
 */
- (void)teadsVideoWillStop:(TeadsVideo *)video {
    
}

/**
 * NativeVideo Did Stop Playing (stopped)
 *
 * @param nativeVideo  : the TeadsVideo object
 */
- (void)teadsVideoDidStop:(TeadsVideo *)video {
    
}

/**
 * NativeVideo Did Pause (paused)
 *
 * @param nativeVideo  : the TeadsVideo object
 */
- (void)teadsVideoDidPause:(TeadsVideo *)video {
    
}

/**
 * NativeVideo Did Resume (playing)
 *
 * @param nativeVideo  : the TeadsVideo object
 */
- (void)teadsVideoDidResume:(TeadsVideo *)video {
    
}

/**
 * NativeVideo Did Mute Sound
 *
 * @param nativeVideo  : the TeadsVideo object
 */
- (void)teadsVideoDidMute:(TeadsVideo *)video {
    
}

/**
 * NativeVideo Did Unmute Sound
 *
 * @param nativeVideo  : the TeadsVideo object
 */
- (void)teadsVideoDidUnmute:(TeadsVideo *)video {
    
}

/**
 * NativeVideo Will expand
 *
 * @param nativeVideo  : the TeadsVideo object
 */
- (void)teadsVideoCanExpand:(TeadsVideo *)video {
    
}

/**
 * NativeVideo Did expand
 *
 * @param nativeVideo  : the TeadsVideo object
 */
- (void)teadsVideoDidExpand:(TeadsVideo *)video {
    
}

/**
 * NativeVideo Will collapse
 *
 * @param nativeVideo  : the TeadsVideo object
 */
- (void)teadsVideoWillCollapse:(TeadsVideo *)video {
    
}

/**
 * NativeVideo did collapse
 *
 * @param nativeVideo  : the TeadsVideo object
 */
- (void)teadsVideoDidCollapse:(TeadsVideo *)video {
    
}

/**
 * NativeVideo was clicked
 *
 * @param nativeVideo  : the TeadsVideo object
 */
- (void)teadsVideoWasClicked:(TeadsVideo *)video {
    
}

/**
 * NativeVideo Did Stop Playing (stopped)
 *
 * @param nativeVideo  : the TeadsVideo object
 */
- (void)teadsVideoDidClickBrowserClose:(TeadsVideo *)video {
    
}

/**
 * NativeVideo Will Take Over Fullscreen
 *
 * @param nativeVideo  : the TeadsVideo object
 */
- (void)teadsVideoWillTakeOverFullScreen:(TeadsVideo *)video {
    
}

/**
 * NativeVideo Did Take Over Fullscreen
 *
 * @param nativeVideo  : the TeadsVideo object
 */
- (void)teadsVideoDidTakeOverFullScreen:(TeadsVideo *)video {
    
}

/**
 * NativeVideo Will Dismiss Fullscreen
 *
 * @param nativeVideo  : the TeadsVideo object
 */
- (void)teadsVideoWillDismissFullscreen:(TeadsVideo *)video {
    
}

/**
 * NativeVideo Did Dismiss Fullscreen
 *
 * @param nativeVideo  : the TeadsVideo object
 */
- (void)teadsVideoDidDismissFullscreen:(TeadsVideo *)video {
    
}

/**
 * NativeVideo Skip Button Was Tapped (skip button pressed)
 *
 * @param nativeVideo  : the TeadsVideo object
 */
- (void)teadsVideoSkipButtonTapped:(TeadsVideo *)video {
    
}

/**
 * NativeVideo Skip Button Did Show (skip button appeared)
 *
 * @param nativeVideo  : the TeadsVideo object
 */
- (void)teadsVideoSkipButtonDidShow:(TeadsVideo *)video {
    
}

/**
 * NativeVideo did clean (all related resoures have been removed)
 *
 * @param nativeVideo  : the TeadsVideo object
 */
- (void)teadsVideoDidClean:(TeadsVideo *)video {
    
}


@end
