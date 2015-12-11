//
//  TeadsVideo.h
//  TeadsSDKDev
//
//  Created by Ibrahim Ennafaa on 5/6/14.
//  Copyright (c) 2014 Teads. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "TeadsError.h"

@protocol TeadsVideoDelegate;

@interface TeadsVideo : NSObject

//////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Properties
#pragma mark -
/////////////////////////////////////////////////////////////

@property (nonatomic, readonly) BOOL isLoaded;
@property (nonatomic, readonly) BOOL isStarted;
@property (nonatomic, readonly) BOOL isPlaying;

@property (nonatomic, readonly) BOOL isSoundEnabled;

@property (nonatomic, weak) id<TeadsVideoDelegate> delegate;

@property (nonatomic) BOOL playbackActive;
@property (nonatomic) CGFloat maxContainerWidth;

//////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Methods
#pragma mark -
/////////////////////////////////////////////////////////////

/* Simple */

- (id)initWithPlacementId:(NSString *)placement delegate:(id<TeadsVideoDelegate>)teadsDelegate;

/* In Board */

- (id)initInBoardWithPlacementId:(NSString*)placement uiWebView:(UIWebView*)webView delegate:(id<TeadsVideoDelegate>)teadsDelegate;

- (id)initInBoardWithPlacementId:(NSString*)placement wkWebView:(WKWebView*)webView delegate:(id<TeadsVideoDelegate>)teadsDelegate;

- (id)initInBoardWithPlacementId:(NSString*)placement referenceView:(UIView *)reference scrollView:(UIScrollView*)scrollView delegate:(id<TeadsVideoDelegate>)teadsDelegate;

- (id)initInBoardWithPlacementId:(NSString*)placement forPlaceHolder:(UIView *)inBoardView withHeightConstraint:(NSLayoutConstraint*)constraint scrollView:(UIScrollView*)scrollView delegate:(id<TeadsVideoDelegate>)teadsDelegate;

- (id)initInBoardWithPlacementId:(NSString*)placement tableView:(UITableView*)tableView delegate:(id<TeadsVideoDelegate>)teadsDelegate;

/* In Read */

- (id)initInReadWithPlacementId:(NSString*)placement placeholderText:(NSString *)placeholderText uiWebView:(UIWebView*)webView delegate:(id<TeadsVideoDelegate>)teadsDelegate;

- (id)initInReadWithPlacementId:(NSString*)placement placeholderText:(NSString *)placeholderText wkWebView:(WKWebView*)webView delegate:(id<TeadsVideoDelegate>)teadsDelegate;

- (id)initInReadWithPlacementId:(NSString*)placement afterView:(UIView *)afterView scrollView:(UIScrollView*)scrollView delegate:(id<TeadsVideoDelegate>)teadsDelegate;

- (id)initInReadWithPlacementId:(NSString*)placement placeholder:(UIView *)placeHolder heightConstraint:(NSLayoutConstraint*)constraints scrollView:(UIScrollView*)scrollView delegate:(id<TeadsVideoDelegate>)teadsDelegate;

- (id)initInReadWithPlacementId:(NSString*)placement insertionIndexPath:(NSIndexPath*)indexPath tableView:(UITableView*)tableView delegate:(id<TeadsVideoDelegate>)teadsDelegate;

- (id)initInReadWithPlacementId:(NSString*)placement insertionIndexPath:(NSIndexPath*)indexPath repeatMode:(BOOL)repeat tableView:(UITableView*)tableView delegate:(id<TeadsVideoDelegate>)teadsDelegate;

- (void)setInReadInsertionIndexPath:(NSIndexPath*)newIndexPath;

/* Common methods */

- (void)setAltScrollView:(UIScrollView *)scrollView;

- (void)load;
- (void)cancelLoad;

- (void)loadWithRequest:(NSURLRequest *)request forStartUrl:(NSString *)startUrl;

/*
  Reset : resets TeadsVideo
  If TeadsVideo is opened : it will close it
 
  After 'reset' call, you can do a new 'load' call (no need to init inRead/inBoard again)
*/
- (void)reset;

/*
  Clean : destroys everything related to TeadsVideo.
 
  You will need to do a new init inBoard/inRead + load if you want to display a TeadsVideo again
*/
- (void)clean;

- (void)onLayoutChange;

- (void)requestPause;

- (void)requestPlay;

- (void)viewControllerAppeared:(UIViewController *)viewController;
- (void)viewControllerDisappeared:(UIViewController *)viewController;

- (CGRect)expandedFrame;
- (float)expandAnimationDuration;
- (float)collapseAnimationDuration;

- (UIView *)videoView;
- (void)videoViewWasAdded;
- (void)videoViewDidMove:(UIView *)containerView;
- (void)videoViewDidExpand;
- (void)videoViewDidCollapse;

@end

//////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark TeadsVideoDelegate Delegate
#pragma mark -
/////////////////////////////////////////////////////////////

/**
 * Delegate about TeadsVastVideo object: set the viewController responsible of modal presentation
 * and gives information about TeadsVideo lifecycle
 */
@protocol TeadsVideoDelegate <NSObject>

@optional


/**
 * Video Failed to Load
 *
 * @param video  : the TeadsVideo object
 * @param error         : the TeadsError object
 */
- (void)teadsVideo:(TeadsVideo *)video didFailLoading:(TeadsError *)error;

/**
 * Video Will Load (loading)
 *
 * @param video  : the TeadsVideo object
 */
- (void)teadsVideoWillLoad:(TeadsVideo *)video;

/**
 * Video Did Load (loaded successfully)
 *
 * @param video  : the TeadsVideo object
 */
- (void)teadsVideoDidLoad:(TeadsVideo *)video;

/**
 * Video Will Start Playing (loading)
 *
 * @param video  : the TeadsVideo object
 */
- (void)teadsVideoWillStart:(TeadsVideo *)video;

/**
 * Video Did Start Playing (playing)
 *
 * @param video  : the TeadsVideo object
 */
- (void)teadsVideoDidStart:(TeadsVideo *)video;

/**
 * Video Will Stop Playing (stopping)
 *
 * @param video  : the TeadsVideo object
 */
- (void)teadsVideoWillStop:(TeadsVideo *)video;

/**
 * Video Did Stop Playing (stopped)
 *
 * @param video  : the TeadsVideo object
 */
- (void)teadsVideoDidStop:(TeadsVideo *)video;

/**
 * Video Did Pause (paused)
 *
 * @param video  : the TeadsVideo object
 */
- (void)teadsVideoDidPause:(TeadsVideo *)video;

/**
 * Video Did Resume (playing)
 *
 * @param video  : the TeadsVideo object
 */
- (void)teadsVideoDidResume:(TeadsVideo *)video;

/**
 * Video Did Mute Sound
 *
 * @param video  : the TeadsVideo object
 */
- (void)teadsVideoDidMute:(TeadsVideo *)video;

/**
 * Video Did Unmute Sound
 *
 * @param video  : the TeadsVideo object
 */
- (void)teadsVideoDidUnmute:(TeadsVideo *)video;

/**
 * Video Can expand
 *
 * @param video  : the TeadsVideo object
 */
- (void)teadsVideoCanExpand:(TeadsVideo *)video WithRatio:(CGFloat)ratio;

/**
 * Video Will expand
 *
 * @param video  : the TeadsVideo object
 */
- (void)teadsVideoWillExpand:(TeadsVideo *)video;

/**
 * Video Did expand
 *
 * @param video  : the TeadsVideo object
 */
- (void)teadsVideoDidExpand:(TeadsVideo *)video;

/**
 * Video Can collapse
 *
 * @param video  : the TeadsVideo object
 */
- (void)teadsVideoCanCollapse:(TeadsVideo *)video;

/**
 * Video Will collapse
 *
 * @param video  : the TeadsVideo object
 */
- (void)teadsVideoWillCollapse:(TeadsVideo *)video;

/**
 * Video did collapse
 *
 * @param video  : the TeadsVideo object
 */
- (void)teadsVideoDidCollapse:(TeadsVideo *)video;

/**
 * Video was clicked
 *
 * @param video  : the TeadsVideo object
 */
- (void)teadsVideoWasClicked:(TeadsVideo *)video;

/**
 * Video Did Stop Playing (stopped)
 *
 * @param video  : the TeadsVideo object
 */
- (void)teadsVideoDidClickBrowserClose:(TeadsVideo *)video;

/**
 * Video Will Take Over Fullscreen
 *
 * @param video  : the TeadsVideo object
 */
- (void)teadsVideoWillTakeOverFullScreen:(TeadsVideo *)video;

/**
 * Video Did Take Over Fullscreen
 *
 * @param video  : the TeadsVideo object
 */
- (void)teadsVideoDidTakeOverFullScreen:(TeadsVideo *)video;

/**
 * Video Will Dismiss Fullscreen
 *
 * @param video  : the TeadsVideo object
 */
- (void)teadsVideoWillDismissFullscreen:(TeadsVideo *)video;

/**
 * Video Did Dismiss Fullscreen
 *
 * @param video  : the TeadsVideo object
 */
- (void)teadsVideoDidDismissFullscreen:(TeadsVideo *)video;

/**
 * Video Skip Button Was Tapped (skip button pressed)
 *
 * @param video  : the TeadsVideo object
 */
- (void)teadsVideoSkipButtonTapped:(TeadsVideo *)video;

/**
 * Video Skip Button Did Show (skip button appeared)
 *
 * @param video  : the TeadsVideo object
 */
- (void)teadsVideoSkipButtonDidShow:(TeadsVideo *)video;

/**
 * Video did reset (player is closed if open, new load can be made after)
 *
 * @param video  : the TeadsVideo object
 */
- (void)teadsVideoDidReset:(TeadsVideo *)video;

/**
 * Video did clean (all related resoures have been removed)
 *
 * @param video  : the TeadsVideo object
 */
- (void)teadsVideoDidClean:(TeadsVideo *)video;
@end
