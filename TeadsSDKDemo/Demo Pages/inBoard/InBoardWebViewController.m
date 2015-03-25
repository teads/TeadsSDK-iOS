//
//  InBoardWebViewController.m
//  TeadsSDKDemo
//
//  Created by Nikolaï Roycourt on 16/01/2015.
//  Copyright (c) 2015 Teads. All rights reserved.
//

#import "InBoardWebViewController.h"
#import <TeadsSDK/TeadsSDK.h>

@interface InBoardWebViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (strong, nonatomic) TeadsNativeVideo *teadsInBoard;
@property (strong, nonatomic) NSURL *startURL;
@property (nonatomic) BOOL firsTimeURLoad;

@end

@implementation InBoardWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"inBoard WebView";
    self.firsTimeURLoad = YES;
    
    self.webView.delegate = self;
    
    self.startURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"] isDirectory:NO];
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.startURL]];
    
    
    // Create the teadsInBoard
    self.teadsInBoard = [[TeadsNativeVideo alloc] initInBoardWithPlacementId:@"27695" uiWebView:self.webView rootViewController:self delegate:self];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.teadsInBoard.isLoaded) {
        [self.teadsInBoard viewControllerAppeared:self];
    } else {
        [self.teadsInBoard load];
    }
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.teadsInBoard viewControllerDisappeared:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [self.teadsInBoard clean];
}

-(void)dealloc {
    [self.teadsInBoard clean];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    [self.teadsInBoard loadWithRequest:request forStartUrl:[NSString stringWithFormat:@"%@",self.startURL]];
    
    return YES;
}


#pragma mark -
#pragma mark - TeadsNativeVideoDelegate

/**
 * NativeVideo Failed to Load
 *
 * @param interstitial  : the TeadsNativeVideo object
 * @param error         : the TeadsError object
 */
- (void)teadsNativeVideo:(TeadsNativeVideo *)nativeVideo didFailLoading:(TeadsError *)error {

}

/**
 * NativeVideo Will Load (loading)
 *
 * @param interstitial  : the TeadsNativeVideo object
 */
- (void)teadsNativeVideoWillLoad:(TeadsNativeVideo *)nativeVideo {
    
}

/**
 * NativeVideo Did Load (loaded successfully)
 *
 * @param interstitial  : the TeadsNativeVideo object
 */
- (void)teadsNativeVideoDidLoad:(TeadsNativeVideo *)nativeVideo {

}

/**
 * NativeVideo Will Start Playing (loading)
 *
 * @param nativeVideo  : the TeadsNativeVideo object
 */
- (void)teadsNativeVideoWillStart:(TeadsNativeVideo *)nativeVideo {
    
}

/**
 * NativeVideo Did Start Playing (playing)
 *
 * @param nativeVideo  : the TeadsNativeVideo object
 */
- (void)teadsNativeVideoDidStart:(TeadsNativeVideo *)nativeVideo {
    
}

/**
 * NativeVideo Will Stop Playing (stopping)
 *
 * @param nativeVideo  : the TeadsNativeVideo object
 */
- (void)teadsNativeVideoWillStop:(TeadsNativeVideo *)nativeVideo {
    
}

/**
 * NativeVideo Did Stop Playing (stopped)
 *
 * @param nativeVideo  : the TeadsNativeVideo object
 */
- (void)teadsNativeVideoDidStop:(TeadsNativeVideo *)nativeVideo {
    
}

/**
 * NativeVideo Did Pause (paused)
 *
 * @param nativeVideo  : the TeadsNativeVideo object
 */
- (void)teadsNativeVideoDidPause:(TeadsNativeVideo *)nativeVideo {
    
}

/**
 * NativeVideo Did Resume (playing)
 *
 * @param nativeVideo  : the TeadsNativeVideo object
 */
- (void)teadsNativeVideoDidResume:(TeadsNativeVideo *)nativeVideo {
    
}

/**
 * NativeVideo Did Mute Sound
 *
 * @param nativeVideo  : the TeadsNativeVideo object
 */
- (void)teadsNativeVideoDidMute:(TeadsNativeVideo *)nativeVideo {
    
}

/**
 * NativeVideo Did Unmute Sound
 *
 * @param nativeVideo  : the TeadsNativeVideo object
 */
- (void)teadsNativeVideoDidUnmute:(TeadsNativeVideo *)nativeVideo {
    
}

/**
 * NativeVideo Will expand
 *
 * @param nativeVideo  : the TeadsNativeVideo object
 */
- (void)teadsNativeVideoWillExpand:(TeadsNativeVideo *)nativeVideo {
    
}

/**
 * NativeVideo Did expand
 *
 * @param nativeVideo  : the TeadsNativeVideo object
 */
- (void)teadsNativeVideoDidExpand:(TeadsNativeVideo *)nativeVideo {
    
}

/**
 * NativeVideo Will collapse
 *
 * @param nativeVideo  : the TeadsNativeVideo object
 */
- (void)teadsNativeVideoWillCollapse:(TeadsNativeVideo *)nativeVideo {
    
}

/**
 * NativeVideo did collapse
 *
 * @param nativeVideo  : the TeadsNativeVideo object
 */
- (void)teadsNativeVideoDidCollapse:(TeadsNativeVideo *)nativeVideo {

}

/**
 * NativeVideo was clicked
 *
 * @param nativeVideo  : the TeadsNativeVideo object
 */
- (void)teadsNativeVideoWasClicked:(TeadsNativeVideo *)nativeVideo {
    
}

/**
 * NativeVideo Did Stop Playing (stopped)
 *
 * @param nativeVideo  : the TeadsNativeVideo object
 */
- (void)teadsNativeVideoDidClickBrowserClose:(TeadsNativeVideo *)nativeVideo {
    
}

/**
 * NativeVideo Will Take Over Fullscreen
 *
 * @param nativeVideo  : the TeadsNativeVideo object
 */
- (void)teadsNativeVideoWillTakeOverFullScreen:(TeadsNativeVideo *)nativeVideo {
    
}

/**
 * NativeVideo Did Take Over Fullscreen
 *
 * @param nativeVideo  : the TeadsNativeVideo object
 */
- (void)teadsNativeVideoDidTakeOverFullScreen:(TeadsNativeVideo *)nativeVideo {
    
}

/**
 * NativeVideo Will Dismiss Fullscreen
 *
 * @param nativeVideo  : the TeadsNativeVideo object
 */
- (void)teadsNativeVideoWillDismissFullscreen:(TeadsNativeVideo *)nativeVideo {
    
}

/**
 * NativeVideo Did Dismiss Fullscreen
 *
 * @param nativeVideo  : the TeadsNativeVideo object
 */
- (void)teadsNativeVideoDidDismissFullscreen:(TeadsNativeVideo *)nativeVideo {
    
}

/**
 * NativeVideo Skip Button Was Tapped (skip button pressed)
 *
 * @param nativeVideo  : the TeadsNativeVideo object
 */
- (void)teadsNativeVideoSkipButtonTapped:(TeadsNativeVideo *)nativeVideo {
    
}

/**
 * NativeVideo Skip Button Did Show (skip button appeared)
 *
 * @param nativeVideo  : the TeadsNativeVideo object
 */
- (void)teadsNativeVideoSkipButtonDidShow:(TeadsNativeVideo *)nativeVideo {
    
}

/**
 * NativeVideo did clean (all related resoures have been removed)
 *
 * @param nativeVideo  : the TeadsNativeVideo object
 */
- (void)teadsNativeVideoDidClean:(TeadsNativeVideo *)nativeVideo {
    
}

@end
