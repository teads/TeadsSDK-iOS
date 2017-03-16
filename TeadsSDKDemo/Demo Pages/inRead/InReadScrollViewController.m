//
//  InReadScrollViewController.m
//  TeadsSDKDemo
//
//  Created by Nikolaï Roycourt on 16/01/2015.
//  Copyright (c) 2015 Teads. All rights reserved.
//

#import "InReadScrollViewController.h"

@interface InReadScrollViewController ()

@property (strong, nonatomic) TeadsAd *teadsInRead;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *inReadConstraint;

@end

@implementation InReadScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.scrollView.delegate = self;
    
    self.navigationItem.title = @"inRead ScrollView";
    
    NSString *pid = [[NSUserDefaults standardUserDefaults] stringForKey:@"pid"];
    
    self.teadsInRead = [[TeadsAd alloc] initInReadWithPlacementId:pid placeholder:self.inReadView heightConstraint:self.inReadConstraint scrollView:self.scrollView delegate:self];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.teadsInRead.isLoaded) {
        [self.teadsInRead viewControllerAppeared:self];
    } else {
        [self.teadsInRead load];
    }
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.teadsInRead viewControllerDisappeared:self];
}

#pragma mark -
#pragma mark TeadsAd delegate

/**
 * NativeVideo Failed to Load
 *
 * @param ad            : the TeadsAd object
 * @param error         : the TeadsError object
 */
- (void)teadsAd:(TeadsAd *)ad didFailLoading:(TeadsError *)error {
    
}

/**
 * NativeVideo Will Load (loading)
 *
 * @param ad  : the TeadsAd object
 */
- (void)teadsAdWillLoad:(TeadsAd *)ad {
    
}

/**
 * NativeVideo Did Load (loaded successfully)
 *
 * @param ad  : the TeadsAd object
 */
- (void)teadsAdDidLoad:(TeadsAd *)ad {
    
}

/**
 * NativeVideo Will Start Playing (loading)
 *
 * @param ad  : the TeadsAd object
 */
- (void)teadsAdWillStart:(TeadsAd *)ad {
    
}

/**
 * NativeVideo Did Start Playing (playing)
 *
 * @param ad  : the TeadsAd object
 */
- (void)teadsAdDidStart:(TeadsAd *)ad {
    
}

/**
 * NativeVideo Will Stop Playing (stopping)
 *
 * @param ad  : the TeadsAd object
 */
- (void)teadsAdWillStop:(TeadsAd *)ad {
    
}

/**
 * NativeVideo Did Stop Playing (stopped)
 *
 * @param ad  : the TeadsAd object
 */
- (void)teadsAdDidStop:(TeadsAd *)ad {
    
}

/**
 * NativeVideo Did Pause (paused)
 *
 * @param ad  : the TeadsAd object
 */
- (void)teadsAdDidPause:(TeadsAd *)ad {
    
}

/**
 * NativeVideo Did Resume (playing)
 *
 * @param ad  : the TeadsAd object
 */
- (void)teadsAdDidResume:(TeadsAd *)ad {
    
}

/**
 * NativeVideo Did Mute Sound
 *
 * @param ad  : the TeadsAd object
 */
- (void)teadsAdDidMute:(TeadsAd *)ad {
    
}

/**
 * NativeVideo Did Unmute Sound
 *
 * @param ad  : the TeadsAd object
 */
- (void)teadsAdDidUnmute:(TeadsAd *)ad {
    
}

/**
 * NativeVideo Will expand
 *
 * @param ad  : the TeadsAd object
 */
- (void)teadsAdWillExpand:(TeadsAd *)ad {
    
}

/**
 * NativeVideo Did expand
 *
 * @param ad  : the TeadsAd object
 */
-(void)teadsAdDidExpand:(TeadsAd *)ad {
    
}

/**
 * NativeVideo Will collapse
 *
 * @param ad  : the TeadsAd object
 */
- (void)teadsAdWillCollapse:(TeadsAd *)ad {
    
}

/**
 * NativeVideo did collapse
 *
 * @param ad  : the TeadsAd object
 */
- (void)teadsAdDidCollapse:(TeadsAd *)ad {
    
}

/**
 * NativeVideo was clicked
 *
 * @param ad  : the TeadsAd object
 */
- (void)teadsAdWasClicked:(TeadsAd *)ad {
    
}

/**
 * NativeVideo Did Stop Playing (stopped)
 *
 * @param ad  : the TeadsAd object
 */
- (void)teadsAdDidClickBrowserClose:(TeadsAd *)ad {
    
}

/**
 * NativeVideo Will Take Over Fullscreen
 *
 * @param ad  : the TeadsAd object
 */
- (void)teadsAdWillTakeOverFullScreen:(TeadsAd *)ad {
    
}

/**
 * NativeVideo Did Take Over Fullscreen
 *
 * @param ad  : the TeadsAd object
 */
- (void)teadsAdDidTakeOverFullScreen:(TeadsAd *)ad {
    
}

/**
 * NativeVideo Will Dismiss Fullscreen
 *
 * @param ad  : the TeadsAd object
 */
- (void)teadsAdWillDismissFullscreen:(TeadsAd *)ad {
    
}

/**
 * NativeVideo Did Dismiss Fullscreen
 *
 * @param ad  : the TeadsAd object
 */
- (void)teadsAdDidDismissFullscreen:(TeadsAd *)ad {
    
}

/**
 * NativeVideo Skip Button Was Tapped (skip button pressed)
 *
 * @param ad  : the TeadsAd object
 */
- (void)teadsAdSkipButtonTapped:(TeadsAd *)ad {
    
}

/**
 * NativeVideo Skip Button Did Show (skip button appeared)
 *
 * @param ad  : the TeadsAd object
 */
- (void)teadsAdSkipButtonDidShow:(TeadsAd *)ad {
    
}

/**
 * NativeVideo did clean (all related resoures have been removed)
 *
 * @param ad  : the TeadsAd object
 */
- (void)teadsAdDidClean:(TeadsAd *)ad {
    
}

@end
