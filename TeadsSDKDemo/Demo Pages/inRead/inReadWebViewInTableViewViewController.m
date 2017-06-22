//
//  inReadWebViewInTableViewViewController.m
//  TeadsSDKDemo
//
//  Created by Jérémy Grosjean on 02/05/2017.
//  Copyright © 2017 Teads. All rights reserved.
//

#import "inReadWebViewInTableViewViewController.h"
#import <TeadsSDK/TeadsSDK.h>
#import "TeadsWebViewTableViewCell.h"
@interface inReadWebViewInTableViewViewController ()<UITableViewDataSource,UITableViewDelegate,TeadsAdDelegate,UIScrollViewDelegate>{
    UIWebView *webView;
    NSInteger teadsAdIndex;
    TeadsAd *teadsInRead;
}
@end

@implementation inReadWebViewInTableViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    teadsAdIndex = 13;
    self.navigationItem.title = @"inRead WebView in Table View";
}


//you need to do that even if you have this code in didEndDisplayingCell because sometimes you will quit the table view and don't call  didEndDisplayingCell
- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    //you need to tell the add that controller has disappeared
    [teadsInRead viewControllerDisappeared:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context){
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context){
        [self.tableView reloadData];
    }];
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}

//as the content size of the webview changes when the ad expand/collapse we need to change the size of the cell, in the case we use the kvo but
// you can think of other method like insert a js in the webview that call you when the size of the content in the webview change
- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentSize"]){
        if ([[change objectForKey:NSKeyValueChangeOldKey]CGSizeValue].height != [[change objectForKey:NSKeyValueChangeNewKey]CGSizeValue].height){
            [self.tableView beginUpdates];
            [self.tableView endUpdates];
        }
    }
}

- (void) dealloc {
    @try{
        [webView.scrollView removeObserver:self  forKeyPath:@"contentSize"];
    }@catch(id anException){
        //do nothing, obviously it wasn't attached because an exception was thrown
    }
}

#pragma mark - UIScrollViewDelegate

- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    //reroute the event
    [webView.scrollView.delegate scrollViewDidScroll:scrollView];
}

#pragma mark - UITableViewDelegate

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == teadsAdIndex){
        TeadsWebViewTableViewCell *currentCell = (TeadsWebViewTableViewCell*)cell;
        //you need to tell the add that cellView has appeared
        if (currentCell.teadsAd.isLoaded) {
            [currentCell.teadsAd viewControllerAppeared:self];
            
        } else {
            [currentCell.teadsAd load];
        }
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath{
    if (indexPath.row == teadsAdIndex){
        TeadsWebViewTableViewCell *currentCell = (TeadsWebViewTableViewCell*)cell;
        //you need to tell the ad that cell has disappeared
        [currentCell.teadsAd viewControllerDisappeared:self];
        @try{
            [webView.scrollView removeObserver:self  forKeyPath:@"contentSize"];
        }@catch(id anException){
            //do nothing, obviously it wasn't attached because an exception was thrown
        }
    }

}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 20;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *TeadsTextCellIdentifier = @"TeadsFirstCell";
    NSString *TeadsGrayedCell = @"TeadsGrayedCell";
    NSString *TeadsWebView = @"WebViewCell";
    UITableViewCell *cell;
    if (indexPath.row == 0){
        cell = [tableView dequeueReusableCellWithIdentifier:TeadsTextCellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TeadsTextCellIdentifier];
        }
    }
    else if (indexPath.row == teadsAdIndex){
        cell = [tableView dequeueReusableCellWithIdentifier:TeadsWebView];
        if (cell == nil) {
            cell = [[TeadsWebViewTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TeadsWebView];
        }
        NSString *pid = [[NSUserDefaults standardUserDefaults] stringForKey:@"pid"];
        TeadsWebViewTableViewCell *currentCell = (TeadsWebViewTableViewCell*)cell;
        //Load a web page from an URL
        NSURL *webSiteURL;
        NSString *urlToLoad = [[NSUserDefaults standardUserDefaults] stringForKey:@"website"];
        teadsInRead = nil;
        if ([[[NSUserDefaults standardUserDefaults] stringForKey:@"website"] isEqual:@"Default demo website"]) {
            //Here we specify in placeholderText an id for a HTML node to insert the inRead
            teadsInRead = [[TeadsAd alloc] initInReadWithPlacementId:pid
                                                     placeholderText:@"#my-placement-id"
                                                           uiWebView:currentCell.webView
                                                            delegate:self];
            webSiteURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"] isDirectory:NO];
        } else {
            // inRead
            teadsInRead = [[TeadsAd alloc] initInReadWithPlacementId:pid
                                                     placeholderText:[[NSUserDefaults standardUserDefaults] stringForKey:@"placeholderText"]
                                                           uiWebView:currentCell.webView
                                                            delegate:self];
            webSiteURL = [NSURL URLWithString:urlToLoad];
        }
        [currentCell.webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        currentCell.teadsAd = teadsInRead;
        teadsInRead.delegate = self;
        //because I don't want to scroll in the webview
        currentCell.webView.scrollView.scrollEnabled = NO;
        [currentCell.webView loadRequest:[NSURLRequest requestWithURL:webSiteURL]];
        webView = currentCell.webView;
        //don't forget to add this line if the controller that contains the ad is not the one that scroll
        [teadsInRead setAltScrollView:self.tableView];
    }
    else {
        cell = [tableView dequeueReusableCellWithIdentifier:TeadsGrayedCell];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TeadsGrayedCell];
        }
    }
        return cell;
    }

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == teadsAdIndex){
        return webView.scrollView.contentSize.height;
    }
    else {
        return 90.0;
    }
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
