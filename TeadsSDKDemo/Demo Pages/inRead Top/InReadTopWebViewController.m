//
//  InReadTopWebViewController.m
//  TeadsSDKDemo
//
//  Created by Nikolaï Roycourt on 16/01/2015.
//  Copyright (c) 2015 Teads. All rights reserved.
//

#import "InReadTopWebViewController.h"
#import <TeadsSDK/TeadsSDK.h>

@interface InReadTopWebViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (strong, nonatomic) TeadsAd *teadsAd;
@property (strong, nonatomic) NSURL *startURL;
@property (nonatomic) BOOL firsTimeURLoad;

@end

@implementation InReadTopWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"inRead Top WebView";
    self.firsTimeURLoad = YES;
        
    NSString *pid = [[NSUserDefaults standardUserDefaults] stringForKey:@"pid"];
    // Create the teadsAd
    self.teadsAd = [[TeadsAd alloc] initInReadTopWithPlacementId:pid scrollView:self.webView.scrollView delegate:self];
    //Set background color to match parent container
    [self.teadsAd setBackgroundColor:[UIColor whiteColor]];
    
    NSString *urlToLoad = [[NSUserDefaults standardUserDefaults] stringForKey:@"website"];
    
    if ([[[NSUserDefaults standardUserDefaults] stringForKey:@"website"] isEqual:@"Default demo website"]) {
        self.startURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"] isDirectory:NO];
    } else {
        self.startURL = [NSURL URLWithString:urlToLoad];
    }
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.startURL]];
    
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

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {   
    return YES;
}


#pragma mark -
#pragma mark - TeadsAdDelegate

/**
 * NativeVideo Failed to Load
 *
 * @param interstitial  : the TeadsAd object
 * @param error         : the TeadsError object
 */
- (void)teadsAd:(TeadsAd *)video didFailLoading:(TeadsError *)error {
    
}

/**
 * NativeVideo Will Load (loading)
 *
 * @param interstitial  : the TeadsAd object
 */
- (void)teadsAdWillLoad:(TeadsAd *)video {
    
}

/**
 * NativeVideo Did Load (loaded successfully)
 *
 * @param interstitial  : the TeadsAd object
 */
- (void)teadsAdDidLoad:(TeadsAd *)video {
    
}

/**
 * NativeVideo failed to find a slot in web view
 *
 * @param interstitial  : the TeadsAd object
 */
- (void)teadsAdFailedToFindAvailableSlot:(TeadsAd *)video {
    
}

/**
 * NativeVideo Will Start Playing (loading)
 *
 * @param nativeVideo  : the TeadsAd object
 */
- (void)teadsAdWillStart:(TeadsAd *)video {
    
}

/**
 * NativeVideo Did Start Playing (playing)
 *
 * @param nativeVideo  : the TeadsAd object
 */
- (void)teadsAdDidStart:(TeadsAd *)video {
    
}

/**
 * NativeVideo Will Stop Playing (stopping)
 *
 * @param nativeVideo  : the TeadsAd object
 */
- (void)teadsAdWillStop:(TeadsAd *)video {
    
}

/**
 * NativeVideo Did Stop Playing (stopped)
 *
 * @param nativeVideo  : the TeadsAd object
 */
- (void)teadsAdDidStop:(TeadsAd *)video {
    
}

/**
 * NativeVideo Did Pause (paused)
 *
 * @param nativeVideo  : the TeadsAd object
 */
- (void)teadsAdDidPause:(TeadsAd *)video {
    
}

/**
 * NativeVideo Did Resume (playing)
 *
 * @param nativeVideo  : the TeadsAd object
 */
- (void)teadsAdDidResume:(TeadsAd *)video {
    
}

/**
 * NativeVideo Did Mute Sound
 *
 * @param nativeVideo  : the TeadsAd object
 */
- (void)teadsAdDidMute:(TeadsAd *)video {
    
}

/**
 * NativeVideo Did Unmute Sound
 *
 * @param nativeVideo  : the TeadsAd object
 */
- (void)teadsAdDidUnmute:(TeadsAd *)video {
    
}

/**
 * NativeVideo Will expand
 *
 * @param nativeVideo  : the TeadsAd object
 */
- (void)teadsAdWillExpand:(TeadsAd *)video {
    
}

/**
 * NativeVideo Did expand
 *
 * @param nativeVideo  : the TeadsAd object
 */
- (void)teadsAdDidExpand:(TeadsAd *)video {
}

/**
 * NativeVideo Will collapse
 *
 * @param nativeVideo  : the TeadsAd object
 */
- (void)teadsAdWillCollapse:(TeadsAd *)video {
    
}

/**
 * NativeVideo did collapse
 *
 * @param nativeVideo  : the TeadsAd object
 */
- (void)teadsAdDidCollapse:(TeadsAd *)video {
    
}

/**
 * NativeVideo was clicked
 *
 * @param nativeVideo  : the TeadsAd object
 */
- (void)teadsAdWasClicked:(TeadsAd *)video {
    
}

/**
 * NativeVideo Did Stop Playing (stopped)
 *
 * @param nativeVideo  : the TeadsAd object
 */
- (void)teadsAdDidClickBrowserClose:(TeadsAd *)video {
    
}

/**
 * NativeVideo Will Take Over Fullscreen
 *
 * @param nativeVideo  : the TeadsAd object
 */
- (void)teadsAdWillTakeOverFullScreen:(TeadsAd *)video {
    
}

/**
 * NativeVideo Did Take Over Fullscreen
 *
 * @param nativeVideo  : the TeadsAd object
 */
- (void)teadsAdDidTakeOverFullScreen:(TeadsAd *)video {
    
}

/**
 * NativeVideo Will Dismiss Fullscreen
 *
 * @param nativeVideo  : the TeadsAd object
 */
- (void)teadsAdWillDismissFullscreen:(TeadsAd *)video {
    
}

/**
 * NativeVideo Did Dismiss Fullscreen
 *
 * @param nativeVideo  : the TeadsAd object
 */
- (void)teadsAdDidDismissFullscreen:(TeadsAd *)video {
    
}

/**
 * NativeVideo Skip Button Was Tapped (skip button pressed)
 *
 * @param nativeVideo  : the TeadsAd object
 */
- (void)teadsAdSkipButtonTapped:(TeadsAd *)video {
    
}

/**
 * NativeVideo Skip Button Did Show (skip button appeared)
 *
 * @param nativeVideo  : the TeadsAd object
 */
- (void)teadsAdSkipButtonDidShow:(TeadsAd *)video {
    
}

/**
 * NativeVideo did clean (all related resoures have been removed)
 *
 * @param nativeVideo  : the TeadsAd object
 */
- (void)teadsAdDidClean:(TeadsAd *)video {
    
}

@end
