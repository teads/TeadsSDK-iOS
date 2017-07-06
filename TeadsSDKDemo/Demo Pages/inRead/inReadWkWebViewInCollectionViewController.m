//
//  inReadWkWebViewInCollectionViewController.m
//  TeadsSDKDemo
//
//  Created by Jérémy Grosjean on 04/05/2017.
//  Copyright © 2017 Teads. All rights reserved.
//

#import "inReadWkWebViewInCollectionViewController.h"
#import "RandomCollectionViewCell.h"
#import "WkWebViewCollectionViewCell.h"
#import <TeadsSDK/TeadsSDK.h>
@interface inReadWkWebViewInCollectionViewController ()<TeadsAdDelegate, UIScrollViewDelegate>{

NSIndexPath *teadsIntegrationIndex;
}
@end

@implementation inReadWkWebViewInCollectionViewController

static NSString * const reuseIdentifier = @"collectionViewCell2";
static NSString * const reuseIdentifier2 = @"webViewcollectionViewCell";


- (void)viewDidLoad {
    [super viewDidLoad];
    //the index where we will add the ad
    teadsIntegrationIndex = [NSIndexPath indexPathForRow:10 inSection:0];
    self.navigationItem.title = @"inRead WkWebView in Collection View";
    // Register cell classes
    [self.collectionView registerClass:[WkWebViewCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier2];
    self.collectionView.delegate = self;
}

//you need to do that even if you have this code in didEndDisplayingCell because sometimes you will quit the collection view and don't call  didEndDisplayingCell
- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    //you need to tell the ad that controller has disappeared
    if ([self.collectionView.indexPathsForVisibleItems containsObject:teadsIntegrationIndex]){
        WkWebViewCollectionViewCell *cell = (WkWebViewCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:teadsIntegrationIndex];
        [cell.teadsAd viewControllerDisappeared:self];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context){
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context){
        [self.collectionView reloadData];
    }];
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}

//as the content size of the webview changes when the ad expand/collapse we need to change the size of the cell, in the case we use the kvo but
// you can think of other method like insert a js in the webview that call you when the size of the content in the webview change
- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentSize"]){
        if ([[change objectForKey:NSKeyValueChangeOldKey]CGSizeValue].height != [[change objectForKey:NSKeyValueChangeNewKey]CGSizeValue].height){
            [self.collectionView performBatchUpdates:^{
                [self.collectionView.collectionViewLayout invalidateLayout];
            } completion:nil];
        }
    }
}

#pragma mark UIScrollViewDelegate

- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    //reroute the event
    if ([self.collectionView.indexPathsForVisibleItems containsObject:teadsIntegrationIndex]){
        WkWebViewCollectionViewCell *cell = (WkWebViewCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:teadsIntegrationIndex];
        [cell.wkWebView.scrollView.delegate scrollViewDidScroll:scrollView];
    }
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 40;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *currentCell;
    if (indexPath.row != teadsIntegrationIndex.row) {
        RandomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
        cell.titleLabel2.text = [NSString stringWithFormat:@"section %ld - row %lu", (long)indexPath.section, (unsigned long)indexPath.row];
        currentCell = cell;
    }
    else {
        WkWebViewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier2 forIndexPath:indexPath];
        NSString *pid = [[NSUserDefaults standardUserDefaults] stringForKey:@"pid"];
        //Load a web page from an URL
        NSURL *webSiteURL;
        NSString *urlToLoad = [[NSUserDefaults standardUserDefaults] stringForKey:@"website"];
        [cell addWkWebView];
        if ([[[NSUserDefaults standardUserDefaults] stringForKey:@"website"] isEqual:@"Default demo website"]) {
            //Here we specify in placeholderText an id for a HTML node to insert the inRead
            cell.teadsAd = [[TeadsAd alloc] initInReadWithPlacementId:pid
                                                 placeholderText:@"#my-placement-id"
                                                       wkWebView:cell.wkWebView
                                                        delegate:self];
            webSiteURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"] isDirectory:NO];
        } else {
            // inRead
            cell.teadsAd = [[TeadsAd alloc] initInReadWithPlacementId:pid
                                                 placeholderText:[[NSUserDefaults standardUserDefaults] stringForKey:@"placeholderText"]
                                                       wkWebView:cell.wkWebView
                                                        delegate:self];
            webSiteURL = [NSURL URLWithString:urlToLoad];
        }
        cell.controller = self;
        [cell.wkWebView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        //because I don't want to scroll in the webview
        cell.wkWebView.scrollView.scrollEnabled = NO;
        [cell.wkWebView loadRequest:[NSURLRequest requestWithURL:webSiteURL]];
        //don't forget to add this line if the controller that contains the ad is not the one that scroll
        [cell.teadsAd setAltScrollView:self.collectionView];
        currentCell = cell;
    }
    return currentCell;
}

#pragma mark - UICollectionView delegate

- (void) collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == teadsIntegrationIndex.row) {
        //you need to tell the ad that cellView has appeared
        WkWebViewCollectionViewCell *cellAd = (WkWebViewCollectionViewCell *)cell;
        if (cellAd.teadsAd.isLoaded) {
            [cellAd.teadsAd viewControllerAppeared:self];
        } else {
            [cellAd.teadsAd load];
        }
    }
}

- (void) collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == teadsIntegrationIndex.row) {
        //you need to tell the ad that cell has disappeared
         WkWebViewCollectionViewCell *cellAd = (WkWebViewCollectionViewCell *)cell;
        [cellAd.teadsAd viewControllerDisappeared:self];
        @try{
            [cellAd.wkWebView.scrollView removeObserver:self  forKeyPath:@"contentSize"];
        }@catch(id anException){
            //do nothing, obviously it wasn't attached because an exception was thrown
        }
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row != teadsIntegrationIndex.row) {
        return CGSizeMake(([UIScreen mainScreen].bounds.size.width-30)/2 , 200);
    }
    else {
        //if the webview is not yet load its content size will be zero and the cell will never be created
         WkWebViewCollectionViewCell *cell = (WkWebViewCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
        return cell.wkWebView.scrollView.contentSize.height > 0 ? cell.wkWebView.scrollView.contentSize : CGSizeMake([UIScreen mainScreen].bounds.size.width, 200);
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
