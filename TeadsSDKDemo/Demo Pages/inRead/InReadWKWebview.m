//
//  inRead.m
//  TeadsSDKDemo
//
//  Created by Nikolaï Roycourt on 17/12/2015.
//  Copyright © 2015 Teads. All rights reserved.
//

#import "InReadWKWebview.h"

@interface InReadWKWebview ()

@property (strong, nonatomic) WKWebView *wkWwebView;

@property (strong, nonatomic) TeadsVideo *teadsInRead;

@end

@implementation InReadWKWebview

- (void)viewDidLoad {
    [super viewDidLoad];
    
    WKWebViewConfiguration *theConfiguration = [[WKWebViewConfiguration alloc] init];
    self.wkWwebView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:theConfiguration];
    self.wkWwebView.navigationDelegate = self;
    
    [self.view addSubview:self.wkWwebView];
    
    [self.wkWwebView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_wkWwebView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_wkWwebView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_wkWwebView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_wkWwebView)]];
    
    self.navigationItem.title = @"inRead WKWebView";
    
    NSString *pid = [[NSUserDefaults standardUserDefaults] stringForKey:@"pid"];
    
    //Load a web page from an URL
    NSURL *webSiteURL;
    NSString *urlToLoad = [[NSUserDefaults standardUserDefaults] stringForKey:@"website"];
    
    if ([[[NSUserDefaults standardUserDefaults] stringForKey:@"website"] isEqual:@"Default demo website"]) {
        //Here we specify in placeholderText an id for a HTML node to insert the inRead
        self.teadsInRead = [[TeadsVideo alloc] initInReadWithPlacementId:pid
                                                         placeholderText:@"#my-placement-id"
                                                               wkWebView:self.wkWwebView
                                                                delegate:self];
        webSiteURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"] isDirectory:NO];
    } else {
        // inRead
        self.teadsInRead = [[TeadsVideo alloc] initInReadWithPlacementId:pid
                                                         placeholderText:[[NSUserDefaults standardUserDefaults] stringForKey:@"placeholderText"]
                                                               wkWebView:self.wkWwebView
                                                                delegate:self];
        webSiteURL = [NSURL URLWithString:urlToLoad];
    }
    [self.wkWwebView loadRequest:[NSURLRequest requestWithURL:webSiteURL]];

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

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    decisionHandler(WKNavigationResponsePolicyAllow);
}

-(void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler {
    completionHandler(NSURLSessionAuthChallengePerformDefaultHandling, NSURLCredentialPersistenceNone);
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
 * NativeVideo failed to find a slot in web view
 *
 * @param interstitial  : the TeadsVideo object
 */
- (void)teadsVideoFailedToFindAvailableSlot:(TeadsVideo *)video {
    
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
- (void)teadsVideoWillExpand:(TeadsVideo *)video {
    
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
