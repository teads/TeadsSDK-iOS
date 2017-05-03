//
//  InReadWebViewEmbededInScrollViewViewController.m
//  TeadsSDKDemo
//
//  Created by Jérémy Grosjean on 02/05/2017.
//  Copyright © 2017 Teads. All rights reserved.
//

#import "InReadWebViewEmbededInScrollViewViewController.h"
#import <TeadsSDK/TeadsSDK.h>
#import <WebKit/WebKit.h>

@interface InReadWebViewEmbededInScrollViewViewController ()<UIWebViewDelegate, TeadsAdDelegate, UIScrollViewDelegate,WKNavigationDelegate>
@property UIWebView *webView;
@property (strong, nonatomic) TeadsAd *teadsInRead;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *topView;

@end

@implementation InReadWebViewEmbededInScrollViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect webViewFrame = CGRectMake(0, self.topView.frame.size.height, self.scrollView.frame.size.width, self.scrollView.frame.size.height-self.topView.frame.size.height);
    
    self.webView = [[UIWebView alloc]initWithFrame:webViewFrame];
    [self.scrollView addSubview:self.webView];
    self.webView.delegate = self;
    
    [self.webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    self.navigationItem.title = @"inRead WebView embeded in Scroll View";
    //VERY IMPORTANT : if you want to set this delegate set them before instantiate the teadsAd
    self.scrollView.delegate = self;
    
    //Load a web page from an URL
    NSURL *webSiteURL;
    NSString *pid = [[NSUserDefaults standardUserDefaults] stringForKey:@"pid"];
    NSString *urlToLoad = [[NSUserDefaults standardUserDefaults] stringForKey:@"website"];
    
    if ([[[NSUserDefaults standardUserDefaults] stringForKey:@"website"] isEqual:@"Default demo website"]) {
        //Here we specify in placeholderText an id for a HTML node to insert the inRead
        self.teadsInRead = [[TeadsAd alloc] initInReadWithPlacementId:pid
                                                      placeholderText:@"#my-placement-id"
                                                            uiWebView:self.webView
                                                             delegate:self];
        webSiteURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"] isDirectory:NO];
    } else {
        // inRead
        self.teadsInRead = [[TeadsAd alloc] initInReadWithPlacementId:pid
                                                      placeholderText:[[NSUserDefaults standardUserDefaults] stringForKey:@"placeholderText"]
                                                            uiWebView:self.webView
                                                             delegate:self];
        webSiteURL = [NSURL URLWithString:urlToLoad];
    }
    [self.webView loadRequest:[NSURLRequest requestWithURL:webSiteURL]];
    //don't forget to add this line if the controller that contains the ad is not the one that scroll
    [self.teadsInRead setAltScrollView:self.scrollView];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //you need to tell the ad that controller has appeared
    if (self.teadsInRead.isLoaded) {
        [self.teadsInRead viewControllerAppeared:self];
    } else {
        [self.teadsInRead load];
    }
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    //you need to tell the ad that controller has disappeared
    [self.teadsInRead viewControllerDisappeared:self];
}

//as the content size of the webview changes when the ad expand/collapse we need to change the content size of the scrollview, in the case we use the kvo but
// you can think of other method like insert a js in the webview that call you when the size of the content in the webview change
- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentSize"]){
        [self resizeEverything];
    }
}

- (void) viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context){
     } completion:^(id<UIViewControllerTransitionCoordinatorContext> context){
             [self resizeEverything];
     }];
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];

}

- (void) resizeEverything{
    self.webView.frame = CGRectMake(0, self.topView.frame.size.height, self.scrollView.frame.size.width, self.webView.scrollView.contentSize.height);
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, self.topView.frame.size.height+self.webView.scrollView.contentSize.height);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc {
    @try{
        [self.webView.scrollView removeObserver:self  forKeyPath:@"contentSize"];
    }@catch(id anException){
        //do nothing, obviously it wasn't attached because an exception was thrown
    }
}

#pragma mark -
#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
}

#pragma mark -
#pragma mark - UIScrollViewDelegate

- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    //reroute the event
    [self.webView.scrollView.delegate scrollViewDidScroll:scrollView];
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
