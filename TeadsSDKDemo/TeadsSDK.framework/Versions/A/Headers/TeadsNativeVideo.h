//
//  TeadsVastVideo.h
//  TeadsSDKDev
//
//  Created by Emmanuel Digiaro on 5/6/14.
//  Copyright (c) 2014 Ebuzzing. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "TeadsError.h"

@protocol TeadsNativeVideoDelegate;

@interface TeadsNativeVideo : NSObject

//////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Properties
#pragma mark -
/////////////////////////////////////////////////////////////

@property (nonatomic) BOOL isLoaded;
@property (nonatomic) BOOL isStarted;
@property (nonatomic) BOOL isPlaying;

@property (nonatomic, weak) id rootViewController;

@property (nonatomic, weak) id<TeadsNativeVideoDelegate> delegate;

@property (nonatomic) BOOL playbackActive;

@property (nonatomic) CGFloat maxContainerWidth;

//////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Methods
#pragma mark -
/////////////////////////////////////////////////////////////

/* Simple */

- (id)initWithPlacementId:(NSString *)placement delegate:(id<TeadsNativeVideoDelegate>)teadsDelegate;

/* In Board */

- (id)initInBoardWithPlacementId:(NSString*)placement webView:(UIWebView*)webView rootViewController:(id)viewController delegate:(id<TeadsNativeVideoDelegate>)teadsDelegate __deprecated_msg("use now initInBoardWithPlacementId:placeholderText:uiWebView:rootViewController:delegate:");

- (id)initInBoardWithPlacementId:(NSString*)placement uiWebView:(UIWebView*)webView rootViewController:(id)viewController delegate:(id<TeadsNativeVideoDelegate>)teadsDelegate;

- (id)initInBoardWithPlacementId:(NSString*)placement wkWebView:(WKWebView*)webView rootViewController:(id)viewController delegate:(id<TeadsNativeVideoDelegate>)teadsDelegate;

- (id)initInBoardWithPlacementId:(NSString*)placement referenceView:(UIView *)reference scrollView:(UIScrollView*)scrollView rootViewController:(id)viewController delegate:(id<TeadsNativeVideoDelegate>)teadsDelegate;

- (id)initInBoardWithPlacementId:(NSString*)placement forPlaceHolder:(UIView *)inBoardView withHeightConstraint:(NSLayoutConstraint*)constraint scrollView:(UIScrollView*)scrollView rootViewController:(id)viewController delegate:(id<TeadsNativeVideoDelegate>)teadsDelegate;

- (id)initInBoardWithPlacementId:(NSString*)placement tableView:(UITableView*)tableView rootViewController:(id)viewController delegate:(id<TeadsNativeVideoDelegate>)teadsDelegate;

/* In Read */

- (id)initInReadWithPlacementId:(NSString*)placement placeholderText:(NSString *)placeholderText webView:(UIWebView*)webView rootViewController:(id)viewController delegate:(id<TeadsNativeVideoDelegate>)teadsDelegate __deprecated_msg("use now initInReadWithPlacementId:placeholderText:uiWebView:rootViewController:delegate:");

- (id)initInReadWithPlacementId:(NSString*)placement placeholderText:(NSString *)placeholderText uiWebView:(UIWebView*)webView rootViewController:(id)viewController delegate:(id<TeadsNativeVideoDelegate>)teadsDelegate;

- (id)initInReadWithPlacementId:(NSString*)placement placeholderText:(NSString *)placeholderText wkWebView:(WKWebView*)webView rootViewController:(id)viewController delegate:(id<TeadsNativeVideoDelegate>)teadsDelegate;

- (id)initInReadWithPlacementId:(NSString*)placement afterView:(UIView *)afterView scrollView:(UIScrollView*)scrollView rootViewController:(id)viewController delegate:(id<TeadsNativeVideoDelegate>)teadsDelegate;

- (id)initInReadWithPlacementId:(NSString*)placement placeholder:(UIView *)placeHolder heightConstraint:(NSLayoutConstraint*)constraints scrollView:(UIScrollView*)scrollView rootViewController:(id)viewController delegate:(id<TeadsNativeVideoDelegate>)teadsDelegate;

- (id)initInReadWithPlacementId:(NSString*)placement insertionIndexPath:(NSIndexPath*)indexPath tableView:(UITableView*)tableView rootViewController:(id)viewController delegate:(id<TeadsNativeVideoDelegate>)teadsDelegate;

- (id)initInReadWithPlacementId:(NSString*)placement insertionIndexPath:(NSIndexPath*)indexPath repeatMode:(BOOL)repeat tableView:(UITableView*)tableView rootViewController:(id)viewController delegate:(id<TeadsNativeVideoDelegate>)teadsDelegate;

- (id)initInReadWithPlacementId:(NSString*)placement insertionIndexPath:(NSIndexPath*)indexPath collectionView:(UICollectionView*)collectionView rootViewController:(id)viewController delegate:(id<TeadsNativeVideoDelegate>)teadsDelegate;

- (void)setInReadInsertionIndexPath:(NSIndexPath*)newIndexPath;

/* In Swipe */

- (id)initInSwipeWithPlacementId:(NSString*)placement pageViewController:(UIPageViewController*)pageViewController insertionIndex:(NSInteger)insertionIndex currentIndex:(NSInteger)currentIndex delegate:(id<TeadsNativeVideoDelegate>)teadsDelegate;

- (void)setInSwipeBackgroundColor:(UIColor *)color;

/* Common methods */

- (void)setPreDownLoad:(BOOL)preDownload;

- (void)setAltScrollView:(UIScrollView *)scrollView;

- (void)load;
- (void)cancelLoad;

- (void)loadFromFactory;

- (void)loadWithRequest:(NSURLRequest *)request forStartUrl:(NSString *)startUrl;

- (void)forceCreativeUrl:(NSString*)creativeURL;

- (void)clean;

- (void)onLayoutChange;

- (void)requestPause;

- (void)requestPlay;

- (void)viewControllerAppeared:(UIViewController *)viewController;
- (void)viewControllerDisappeared:(UIViewController *)viewController;

- (UIView *)getNativeVideoView;
- (void)setNativeVideoViewFrame:(CGRect)frame;
- (void)setNativeVideoViewFrameHeight:(float)height;
- (BOOL)isViewableInView:(id)rootView;
- (BOOL)isFrame:(CGRect)frame viewableInView:(id)rootView;

- (CGRect)getExpandedFrame;
- (float)getExpandAnimationDuration;
- (float)getCollapseAnimationDuration;

@end

//////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark TeadsNativeVideoDelegate Delegate
#pragma mark -
/////////////////////////////////////////////////////////////

/**
 * Delegate about TeadsVastVideo object: set the viewController responsible of modal presentation
 * and gives information about TeadsNativeVideo lifecycle
 */
@protocol TeadsNativeVideoDelegate <NSObject>

@optional


/**
 * NativeVideo Failed to Load
 *
 * @param interstitial  : the TeadsNativeVideo object
 * @param error         : the TeadsError object
 */
- (void)teadsNativeVideo:(TeadsNativeVideo *)nativeVideo didFailLoading:(TeadsError *)error;

/**
 * NativeVideo Will Load (loading)
 *
 * @param interstitial  : the TeadsNativeVideo object
 */
- (void)teadsNativeVideoWillLoad:(TeadsNativeVideo *)nativeVideo;

/**
 * NativeVideo Did Load (loaded successfully)
 *
 * @param interstitial  : the TeadsNativeVideo object
 */
- (void)teadsNativeVideoDidLoad:(TeadsNativeVideo *)nativeVideo;

/**
 * NativeVideo failed to find a slot in web view
 *
 * @param interstitial  : the TeadsNativeVideo object
 */
- (void)teadsNativeVideoFailedToFindAvailableSlot:(TeadsNativeVideo *)nativeVideo;

/**
 * NativeVideo Will Start Playing (loading)
 *
 * @param nativeVideo  : the TeadsNativeVideo object
 */
- (void)teadsNativeVideoWillStart:(TeadsNativeVideo *)nativeVideo;

/**
 * NativeVideo Did Start Playing (playing)
 *
 * @param nativeVideo  : the TeadsNativeVideo object
 */
- (void)teadsNativeVideoDidStart:(TeadsNativeVideo *)nativeVideo;

/**
 * NativeVideo Will Stop Playing (stopping)
 *
 * @param nativeVideo  : the TeadsNativeVideo object
 */
- (void)teadsNativeVideoWillStop:(TeadsNativeVideo *)nativeVideo;

/**
 * NativeVideo Did Stop Playing (stopped)
 *
 * @param nativeVideo  : the TeadsNativeVideo object
 */
- (void)teadsNativeVideoDidStop:(TeadsNativeVideo *)nativeVideo;

/**
 * NativeVideo Did Pause (paused)
 *
 * @param nativeVideo  : the TeadsNativeVideo object
 */
- (void)teadsNativeVideoDidPause:(TeadsNativeVideo *)nativeVideo;

/**
 * NativeVideo Did Resume (playing)
 *
 * @param nativeVideo  : the TeadsNativeVideo object
 */
- (void)teadsNativeVideoDidResume:(TeadsNativeVideo *)nativeVideo;

/**
 * NativeVideo Did Mute Sound
 *
 * @param nativeVideo  : the TeadsNativeVideo object
 */
- (void)teadsNativeVideoDidMute:(TeadsNativeVideo *)nativeVideo;

/**
 * NativeVideo Did Unmute Sound
 *
 * @param nativeVideo  : the TeadsNativeVideo object
 */
- (void)teadsNativeVideoDidUnmute:(TeadsNativeVideo *)nativeVideo;

/**
 * NativeVideo Will expand
 *
 * @param nativeVideo  : the TeadsNativeVideo object
 */
- (void)teadsNativeVideoWillExpand:(TeadsNativeVideo *)nativeVideo;

/**
 * NativeVideo Did expand
 *
 * @param nativeVideo  : the TeadsNativeVideo object
 */
- (void)teadsNativeVideoDidExpand:(TeadsNativeVideo *)nativeVideo;

/**
 * NativeVideo Will collapse
 *
 * @param nativeVideo  : the TeadsNativeVideo object
 */
- (void)teadsNativeVideoWillCollapse:(TeadsNativeVideo *)nativeVideo;

/**
 * NativeVideo did collapse
 *
 * @param nativeVideo  : the TeadsNativeVideo object
 */
- (void)teadsNativeVideoDidCollapse:(TeadsNativeVideo *)nativeVideo;

/**
 * NativeVideo was clicked
 *
 * @param nativeVideo  : the TeadsNativeVideo object
 */
- (void)teadsNativeVideoWasClicked:(TeadsNativeVideo *)nativeVideo;

/**
 * NativeVideo Did Stop Playing (stopped)
 *
 * @param nativeVideo  : the TeadsNativeVideo object
 */
- (void)teadsNativeVideoDidClickBrowserClose:(TeadsNativeVideo *)nativeVideo;

/**
 * NativeVideo Will Take Over Fullscreen
 *
 * @param nativeVideo  : the TeadsNativeVideo object
 */
- (void)teadsNativeVideoWillTakeOverFullScreen:(TeadsNativeVideo *)nativeVideo;

/**
 * NativeVideo Did Take Over Fullscreen
 *
 * @param nativeVideo  : the TeadsNativeVideo object
 */
- (void)teadsNativeVideoDidTakeOverFullScreen:(TeadsNativeVideo *)nativeVideo;

/**
 * NativeVideo Will Dismiss Fullscreen
 *
 * @param nativeVideo  : the TeadsNativeVideo object
 */
- (void)teadsNativeVideoWillDismissFullscreen:(TeadsNativeVideo *)nativeVideo;

/**
 * NativeVideo Did Dismiss Fullscreen
 *
 * @param nativeVideo  : the TeadsNativeVideo object
 */
- (void)teadsNativeVideoDidDismissFullscreen:(TeadsNativeVideo *)nativeVideo;

/**
 * NativeVideo Skip Button Was Tapped (skip button pressed)
 *
 * @param nativeVideo  : the TeadsNativeVideo object
 */
- (void)teadsNativeVideoSkipButtonTapped:(TeadsNativeVideo *)nativeVideo;

/**
 * NativeVideo Skip Button Did Show (skip button appeared)
 *
 * @param nativeVideo  : the TeadsNativeVideo object
 */
- (void)teadsNativeVideoSkipButtonDidShow:(TeadsNativeVideo *)nativeVideo;

/**
 * NativeVideo did clean (all related resoures have been removed)
 *
 * @param nativeVideo  : the TeadsNativeVideo object
 */
- (void)teadsNativeVideoDidClean:(TeadsNativeVideo *)nativeVideo;
@end
