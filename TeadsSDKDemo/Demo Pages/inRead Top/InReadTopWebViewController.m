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
#pragma mark - TeadsAd delegate

/**
 * Ad failed to load
 *
 * @param ad The TeadsAd object
 * @param error The TeadsError object
 */
- (void)teadsAd:(TeadsAd *)ad didFailLoading:(TeadsError *)error {
    
}

/**
 * Ad will load (loading)
 *
 * @param ad The TeadsAd object
 */
- (void)teadsAdWillLoad:(TeadsAd *)ad {
    
}

/**
 * Ad did load (loaded successfully)
 *
 * @param ad The TeadsAd object
 */
- (void)teadsAdDidLoad:(TeadsAd *)ad {
    
}

/**
 * Ad experience will start
 *
 * @param ad The TeadsAd object
 */
- (void)teadsAdWillStart:(TeadsAd *)ad {
    
}

/**
 * Ad experience did start
 *
 * @param ad The TeadsAd object
 */
- (void)teadsAdDidStart:(TeadsAd *)ad {
    
}

/**
 * Ad experience stop
 *
 * @param ad The TeadsAd object
 */
- (void)teadsAdWillStop:(TeadsAd *)ad {
    
}

/**
 * Ad experience did stop
 *
 * @param ad The TeadsAd object
 */
- (void)teadsAdDidStop:(TeadsAd *)ad {
    
}

/**
 * Ad experience did pause
 *
 * @param ad The TeadsAd object
 */
- (void)teadsAdDidPause:(TeadsAd *)ad {
    
}

/**
 * Ad experience did resume
 *
 * @param ad The TeadsAd object
 */
- (void)teadsAdDidResume:(TeadsAd *)ad {
    
}

/**
 * Ad did mute sound
 *
 * @param ad The TeadsAd object
 */
- (void)teadsAdDidMute:(TeadsAd *)ad {
    
}

/**
 * Ad did unmute sound
 *
 * @param ad The TeadsAd object
 */
- (void)teadsAdDidUnmute:(TeadsAd *)ad {
    
}

/**
 * Ad will expand
 *
 * @param ad The TeadsAd object
 */
- (void)teadsAdWillExpand:(TeadsAd *)ad {
    
}

/**
 * Ad did expand
 *
 * @param ad The TeadsAd object
 */
- (void)teadsAdDidExpand:(TeadsAd *)ad {
    
}

/**
 * Ad will collapse
 *
 * @param ad The TeadsAd object
 */
- (void)teadsAdWillCollapse:(TeadsAd *)ad {
    
}

/**
 * Ad did collapse
 *
 * @param ad The TeadsAd object
 */
- (void)teadsAdDidCollapse:(TeadsAd *)ad {
    
}

/**
 * Ad was clicked
 *
 * @param ad The TeadsAd object
 */
- (void)teadsAdWasClicked:(TeadsAd *)ad {
    
}

/**
 * Ad experience did stop
 *
 * @param ad The TeadsAd object
 */
- (void)teadsAdDidClickBrowserClose:(TeadsAd *)ad {
    
}

/**
 * Ad will take over fullscreen
 *
 * @param ad The TeadsAd object
 */
- (void)teadsAdWillTakeOverFullScreen:(TeadsAd *)ad {
    
}

/**
 * Ad did take over fullscreen
 *
 * @param ad The TeadsAd object
 */
- (void)teadsAdDidTakeOverFullScreen:(TeadsAd *)ad {
    
}

/**
 * Ad qill dismiss fullscreen
 *
 * @param ad The TeadsAd object
 */
- (void)teadsAdWillDismissFullscreen:(TeadsAd *)ad {
    
}

/**
 * Ad did dismiss fullscreen
 *
 * @param ad The TeadsAd object
 */
- (void)teadsAdDidDismissFullscreen:(TeadsAd *)ad {
    
}

/**
 * Ad Skip Button Was Tapped
 *
 * @param ad The TeadsAd object
 * @discussion Eg: skip button was pressed
 */
- (void)teadsAdSkipButtonTapped:(TeadsAd *)ad {
    
}

/**
 * Ad skip button appeared
 *
 * @param ad The TeadsAd object
 */
- (void)teadsAdSkipButtonDidShow:(TeadsAd *)ad {
    
}

/**
 * Ad did reset
 *
 * @param ad The TeadsAd object
 * @discussion Player is closed if open, new `load` call can be made after
 */
- (void)teadsAdDidReset:(TeadsAd *)ad {
    
}

/**
 * Ad did clean
 *
 * @param ad The TeadsAd object
 * @discussion All related resoures have been removed
 */
- (void)teadsAdDidClean:(TeadsAd *)ad {
    
}

@end
