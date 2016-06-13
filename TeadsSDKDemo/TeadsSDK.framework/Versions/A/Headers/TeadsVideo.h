//
//  TeadsVideo.h
//  TeadsSDK
//
//  Created by Ibrahim Ennafaa on 5/6/14.
//  Copyright (c) 2016 Teads. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "TeadsError.h"

__attribute__((deprecated  ("use TeadsAdDelegate")))
@protocol TeadsVideoDelegate;

typedef NS_ENUM(NSInteger, TeadsVideoInReadTopPosition) {
    TeadsVideoInReadTopPositionHeader,
    TeadsVideoInReadTopPositionFooter
};

typedef NS_ENUM(NSInteger, TeadsVideoPlayerColorMode) {
    TeadsVideoPlayerColorModeDark,
    TeadsVideoPlayerColorModeLight
};

__attribute__((deprecated ("use TeadsAd")))
@interface TeadsVideo : NSObject //TeadsVideo is deprecated and going to be removed soon. Please use TeadsAd.

//////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Properties
#pragma mark -
/////////////////////////////////////////////////////////////

@property (nonatomic, readonly) BOOL isLoaded;  //returns YES if Teads Video is loaded
@property (nonatomic, readonly) BOOL isStarted; //returns YES if Teads Video has started playing
@property (nonatomic, readonly) BOOL isPlaying; //returns YES if Teads Video is playing

@property (nonatomic, readonly) BOOL isSoundEnabled; //returns YES if Teads Video player sound is active

@property (nonatomic, weak) id<TeadsVideoDelegate> delegate;

@property (nonatomic) BOOL playbackActive;
@property (nonatomic) CGFloat maxContainerWidth;
@property (nonatomic) CGFloat maxContainerHeight;

@property (nonatomic) TeadsVideoPlayerColorMode playerColorMode; // Color mode for start and end screens

//////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Methods
#pragma mark -
/////////////////////////////////////////////////////////////

#pragma mark Custom Video

/**
 * -initWithPlacementId:delegate:
 *
 * @param placement     : a placement ID string
 * @param teadsDelegate : the instance that implements TeadsVideoDelegate
 */
- (id)initWithPlacementId:(NSString *)placement delegate:(id<TeadsVideoDelegate>)teadsDelegate;

#pragma mark
#pragma mark inReadTop

/**
* -initInReadTopWithPlacementId:scrollView:delegate:
*
* @param placement     : a placement ID string
* @param scrollView       : a UIScrollView object
* @param teadsDelegate : the instance that implements TeadsVideoDelegate
*/
- (id)initInReadTopWithPlacementId:(NSString *)placement scrollView:(UIScrollView *)scrollView delegate:(id<TeadsVideoDelegate>)teadsDelegate;

#pragma mark -
#pragma mark inRead

/**
 * -initInReadWithPlacementId:uiWebView:delegate:
 *
 * @param placement     : a placement ID string
 * @param webView       : a UIWebview object
 * @param teadsDelegate : the instance that implements TeadsVideoDelegate
 */
- (id)initInReadWithPlacementId:(NSString*)placement uiWebView:(UIWebView*)webView delegate:(id<TeadsVideoDelegate>)teadsDelegate;

/**
 * -initInReadWithPlacementId:wkWebView:delegate:
 *
 * @param placement     : a placement ID string
 * @param webView       : a WKWebview object
 * @param teadsDelegate : the instance that implements TeadsVideoDelegate
 */
- (id)initInReadWithPlacementId:(NSString*)placement wkWebView:(WKWebView*)webView delegate:(id<TeadsVideoDelegate>)teadsDelegate;

/**
 * -initInReadWithPlacementId:placeholderText:uiWebView:delegate:
 *
 * @param placement         : a placement ID string
 * @param placeholderText   : a DOM selector string
 * @param webView           : a UIWebview object
 * @param teadsDelegate     : the instance that implements TeadsVideoDelegate
 */
- (id)initInReadWithPlacementId:(NSString*)placement placeholderText:(NSString *)placeholderText uiWebView:(UIWebView*)webView delegate:(id<TeadsVideoDelegate>)teadsDelegate;

/**
 * -initInReadWithPlacementId:placeholderText:wkWebView:delegate:
 *
 * @param placement         : a placement ID string
 * @param placeholderText   : a DOM selector string
 * @param webView           : a WKWebView object
 * @param teadsDelegate     : the instance that implements TeadsVideoDelegate
 */
- (id)initInReadWithPlacementId:(NSString*)placement placeholderText:(NSString *)placeholderText wkWebView:(WKWebView*)webView delegate:(id<TeadsVideoDelegate>)teadsDelegate;

/**
 * -initInReadWithPlacementId:afterView:scrollView:delegate:
 *
 * @param placement     : a placement ID string
 * @param afterView     : a UIView element after which the inRead will be displayed
 * @param scrollView    : a scroll-view object
 * @param teadsDelegate : the instance that implements TeadsVideoDelegate
 */
- (id)initInReadWithPlacementId:(NSString*)placement afterView:(UIView *)afterView scrollView:(UIScrollView*)scrollView delegate:(id<TeadsVideoDelegate>)teadsDelegate;

/**
 * -initInReadWithPlacementId:placeholder:heightConstraint:scrollView:
 *
 * @param placement     : a placement ID string
 * @param placeHolder   : a UIView that will contain Teads Video
 * @param constraint    : the height constraint of 'placeHolder' parameter
 * @param scrollView    : a scroll-view object
 * @param teadsDelegate : the instance that implements TeadsVideoDelegate
 */
- (id)initInReadWithPlacementId:(NSString*)placement placeholder:(UIView *)placeHolder heightConstraint:(NSLayoutConstraint*)constraint scrollView:(UIScrollView*)scrollView delegate:(id<TeadsVideoDelegate>)teadsDelegate;

/**
 * -initInReadWithPlacementId:insertionIndexPath:tableView:delegate:
 *
 * @param placement     : a placement ID string
 * @param indexPath     : the TeadsError object
 * @param tableView     : an index path locating a row in tableView where to insert Teads Video
 * @param teadsDelegate : the instance that implements TeadsVideoDelegate
 */
- (id)initInReadWithPlacementId:(NSString*)placement insertionIndexPath:(NSIndexPath*)indexPath tableView:(UITableView*)tableView delegate:(id<TeadsVideoDelegate>)teadsDelegate;

/**
 * -initInReadWithPlacementId:insertionIndexPath:repeatMode:tableView:delegate:
 *
 * @param placement     : a placement ID string
 * @param indexPath     : an index path locating a row in tableView where to insert Teads Video
 * @param repeat        : a boolean whether or not inRead should be repeated
 * @param tableView     : a table-view
 * @param teadsDelegate : the instance that implements TeadsVideoDelegate
 */
- (id)initInReadWithPlacementId:(NSString*)placement insertionIndexPath:(NSIndexPath*)indexPath repeatMode:(BOOL)repeat tableView:(UITableView*)tableView delegate:(id<TeadsVideoDelegate>)teadsDelegate;

#pragma mark Common methods

/*
 * -setBackgroundColor:
 *
 * @param backgroundColor : Set the wanted color for the inReadTop background only
 *
 */
- (void)setBackgroundColor:(UIColor *)backgroundColor;


/*
 * -setAltScrollView:
 *
 * @param scrollView     : set the real scroll-view of your interface that in the end contains the inRead
 *
 * Eg : 
 * You have a webview in which you want to display an inRead.
 * The webView.scrollView.scrollEnabled is set to NO
 * The webview is embedded in a scroll-view or table-view, which is the scrolling element
 * You have then to call -setAltScrollView:  providing the scrolling UI-element
 *
 */
- (void)setAltScrollView:(UIScrollView *)scrollView;

- (void)load;       //Load the Teads Video
- (void)cancelLoad; //Cancel Teads Video load

- (void)loadWithRequest:(NSURLRequest *)request forStartUrl:(NSString *)startUrl;

/*
 * -reset
 *
 * Resets TeadsVideo
 * If TeadsVideo is opened : it will close it
 * After 'reset' call, you can do a new 'load' call (no need to init inRead/inReadTop again)
 *
*/
- (void)reset;

/*
 * -clean
 *
 * destroys everything related to TeadsVideo.
 * You will need to do a new init inRead/inReadTop + load if you want to display a TeadsVideo again
*/
- (void)clean;

- (void)onLayoutChange; //Call when layout has changed

- (void)requestPause;   //If TeadsVideo can be paused : it will be paused
- (void)requestPlay;    //If TeadsVideo can resume : it will resume

/*
 * -viewControllerAppeared:
 *
 * @param viewController : the view-controller that will display the Teads Video
 *
 * This method has to be called in your view-controller -viewDidAppear: method
 *
 */
- (void)viewControllerAppeared:(UIViewController *)viewController;

/*
 * -viewControllerDisappeared:
 *
 * @param viewController : the view-controller that will display the Teads Video
 *
 * This method has to be called in your view-controller -viewDidDisappear: method
 *
 */
- (void)viewControllerDisappeared:(UIViewController *)viewController;

- (CGRect)expandedFrame;            //Get the expanded frame of Teads Video
- (float)expandAnimationDuration;   //Get expand animation duration
- (float)collapseAnimationDuration; //Get collapse animation duration

#pragma mark Method for inRead in TableView

/**
 * -setInReadInsertionIndexPath:newIndexPath
 *
 * @param newIndexPath     : set a new index path for inRead in table-view BEFORE load
 */
- (void)setInReadInsertionIndexPath:(NSIndexPath*)newIndexPath;


#pragma mark Methods for Custom Video

- (UIView *)videoView;      //Get the UIView for Custom Video which contains the player
- (void)videoViewWasAdded;  //Call to inform that videoView was added
/**
 * -videoViewDidMove:
 *
 * @param containerView : the container view in which the video has moved
 *
 * Eg : A ScrollView is the top UI component, we have to call -videoViewDidMove: when user scrolls that the Video will still be viewable
 */
- (void)videoViewDidMove:(UIView *)containerView; //Call to inform that
- (void)videoViewDidExpand;     //Call to inform that videoView frame has been expanded
- (void)videoViewDidCollapse;   //Call to inform that videoView frame has been collapsed

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
__attribute__((deprecated ("use TeadsAdDelegate")))
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
- (void)teadsVideoCanExpand:(TeadsVideo *)video withRatio:(CGFloat)ratio;

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
