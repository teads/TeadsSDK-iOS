//
//  TeadsAd.h
//  TeadsSDK
//
//  Created by Bastien Lefrant on 17/05/2016.
//  Copyright © 2016 Teads. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "TeadsError.h"


@protocol TeadsAdDelegate;

typedef NS_ENUM(NSInteger, TeadsAdInReadTopPosition) {
    TeadsAdInReadTopPositionHeader,
    TeadsAdInReadTopPositionFooter
};

typedef NS_ENUM(NSInteger, TeadsAdPlayerColorMode) {
    TeadsAdPlayerColorModeDark,
    TeadsAdPlayerColorModeLight
};

@interface TeadsAd : NSObject

//////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Properties
#pragma mark -
/////////////////////////////////////////////////////////////

@property (nonatomic, readonly) BOOL isLoaded;  //returns YES if Teads Video is loaded
@property (nonatomic, readonly) BOOL isStarted; //returns YES if Teads Video has started playing
@property (nonatomic, readonly) BOOL isPlaying; //returns YES if Teads Video is playing

@property (nonatomic, readonly) BOOL isSoundEnabled; //returns YES if Teads Video player sound is active

@property (nonatomic, weak) id<TeadsAdDelegate> delegate;

@property (nonatomic) BOOL playbackActive;
@property (nonatomic) CGFloat maxContainerWidth;
@property (nonatomic) CGFloat maxContainerHeight;

@property (nonatomic) TeadsAdPlayerColorMode playerColorMode; // Color mode for start and end screens

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
 * @param teadsDelegate : the instance that implements TeadsAdDelegate
 */
- (id)initWithPlacementId:(NSString *)placement delegate:(id<TeadsAdDelegate>)teadsDelegate;

#pragma mark
#pragma mark inReadTop

/**
 * -initInReadTopWithPlacementId:scrollView:delegate:
 *
 * @param placement     : a placement ID string
 * @param scrollView       : a UIScrollView object
 * @param teadsDelegate : the instance that implements TeadsAdDelegate
 */
- (id)initInReadTopWithPlacementId:(NSString *)placement scrollView:(UIScrollView *)scrollView delegate:(id<TeadsAdDelegate>)teadsDelegate;

/**
 * -initInReadTopWithPlacementId:scrollView:delegate:
 *
 * @param placement     : a placement ID string
 * @param scrollView       : a UIScrollView object
 * @param TeadsInReadTopPosition : the position of the inReadTop
 * @param teadsDelegate : the instance that implements TeadsVideoDelegate
 */
- (id)initInReadTopWithPlacementId:(NSString *)placement position:(TeadsAdInReadTopPosition)position scrollView:(UIScrollView *)scrollView delegate:(id<TeadsAdDelegate>)teadsDelegate;


#pragma mark -
#pragma mark inRead

/**
 * -initInReadWithPlacementId:uiWebView:delegate:
 *
 * @param placement     : a placement ID string
 * @param webView       : a UIWebview object
 * @param teadsDelegate : the instance that implements TeadsAdDelegate
 */
- (id)initInReadWithPlacementId:(NSString*)placement uiWebView:(UIWebView*)webView delegate:(id<TeadsAdDelegate>)teadsDelegate;

/**
 * -initInReadWithPlacementId:wkWebView:delegate:
 *
 * @param placement     : a placement ID string
 * @param webView       : a WKWebview object
 * @param teadsDelegate : the instance that implements TeadsAdDelegate
 */
- (id)initInReadWithPlacementId:(NSString*)placement wkWebView:(WKWebView*)webView delegate:(id<TeadsAdDelegate>)teadsDelegate;

/**
 * -initInReadWithPlacementId:placeholderText:uiWebView:delegate:
 *
 * @param placement         : a placement ID string
 * @param placeholderText   : a DOM selector string
 * @param webView           : a UIWebview object
 * @param teadsDelegate     : the instance that implements TeadsAdDelegate
 */
- (id)initInReadWithPlacementId:(NSString*)placement placeholderText:(NSString *)placeholderText uiWebView:(UIWebView*)webView delegate:(id<TeadsAdDelegate>)teadsDelegate;

/**
 * -initInReadWithPlacementId:placeholderText:wkWebView:delegate:
 *
 * @param placement         : a placement ID string
 * @param placeholderText   : a DOM selector string
 * @param webView           : a WKWebView object
 * @param teadsDelegate     : the instance that implements TeadsAdDelegate
 */
- (id)initInReadWithPlacementId:(NSString*)placement placeholderText:(NSString *)placeholderText wkWebView:(WKWebView*)webView delegate:(id<TeadsAdDelegate>)teadsDelegate;

/**
 * -initInReadWithPlacementId:afterView:scrollView:delegate:
 *
 * @param placement     : a placement ID string
 * @param afterView     : a UIView element after which the inRead will be displayed
 * @param scrollView    : a scroll-view object
 * @param teadsDelegate : the instance that implements TeadsAdDelegate
 */
- (id)initInReadWithPlacementId:(NSString*)placement afterView:(UIView *)afterView scrollView:(UIScrollView*)scrollView delegate:(id<TeadsAdDelegate>)teadsDelegate;

/**
 * -initInReadWithPlacementId:placeholder:heightConstraint:scrollView:
 *
 * @param placement     : a placement ID string
 * @param placeHolder   : a UIView that will contain Teads Video
 * @param constraint    : the height constraint of 'placeHolder' parameter
 * @param scrollView    : a scroll-view object
 * @param teadsDelegate : the instance that implements TeadsAdDelegate
 */
- (id)initInReadWithPlacementId:(NSString*)placement placeholder:(UIView *)placeHolder heightConstraint:(NSLayoutConstraint*)constraint scrollView:(UIScrollView*)scrollView delegate:(id<TeadsAdDelegate>)teadsDelegate;

/**
 * -initInReadWithPlacementId:insertionIndexPath:tableView:delegate:
 *
 * @param placement     : a placement ID string
 * @param indexPath     : the TeadsError object
 * @param tableView     : an index path locating a row in tableView where to insert Teads Video
 * @param teadsDelegate : the instance that implements TeadsAdDelegate
 */
- (id)initInReadWithPlacementId:(NSString*)placement insertionIndexPath:(NSIndexPath*)indexPath tableView:(UITableView*)tableView delegate:(id<TeadsAdDelegate>)teadsDelegate;

/**
 * -initInReadWithPlacementId:insertionIndexPath:repeatMode:tableView:delegate:
 *
 * @param placement     : a placement ID string
 * @param indexPath     : an index path locating a row in tableView where to insert Teads Video
 * @param repeat        : a boolean whether or not inRead should be repeated
 * @param tableView     : a table-view
 * @param teadsDelegate : the instance that implements TeadsAdDelegate
 */
- (id)initInReadWithPlacementId:(NSString*)placement insertionIndexPath:(NSIndexPath*)indexPath repeatMode:(BOOL)repeat tableView:(UITableView*)tableView delegate:(id<TeadsAdDelegate>)teadsDelegate;

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
 * Resets TeadsAd
 * If TeadsAd is opened : it will close it
 * After 'reset' call, you can do a new 'load' call (no need to init inRead/inReadTop again)
 *
 */
- (void)reset;

/*
 * -clean
 *
 * destroys everything related to TeadsAd.
 * You will need to do a new init inRead/inReadTop + load if you want to display a TeadsAd again
 */
- (void)clean;

- (void)onLayoutChange; //Call when layout has changed

- (void)requestPause;   //If TeadsAd can be paused : it will be paused
- (void)requestPlay;    //If TeadsAd can resume : it will resume

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
#pragma mark TeadsAdDelegate Delegate
#pragma mark -
/////////////////////////////////////////////////////////////

/**
 * Delegate about TeadsVastVideo object: set the viewController responsible of modal presentation
 * and gives information about TeadsAd lifecycle
 */
@protocol TeadsAdDelegate <NSObject>

@optional


/**
 * Video Failed to Load
 *
 * @param video  : the TeadsAd object
 * @param error         : the TeadsError object
 */
- (void)teadsAd:(TeadsAd *)ad didFailLoading:(TeadsError *)error;

/**
 * Video Will Load (loading)
 *
 * @param video  : the TeadsAd object
 */
- (void)teadsAdWillLoad:(TeadsAd *)ad;

/**
 * Video Did Load (loaded successfully)
 *
 * @param video  : the TeadsAd object
 */
- (void)teadsAdDidLoad:(TeadsAd *)ad;

/**
 * Video Will Start Playing (loading)
 *
 * @param video  : the TeadsAd object
 */
- (void)teadsAdWillStart:(TeadsAd *)ad;

/**
 * Video Did Start Playing (playing)
 *
 * @param video  : the TeadsAd object
 */
- (void)teadsAdDidStart:(TeadsAd *)ad;

/**
 * Video Will Stop Playing (stopping)
 *
 * @param video  : the TeadsAd object
 */
- (void)teadsAdWillStop:(TeadsAd *)ad;

/**
 * Video Did Stop Playing (stopped)
 *
 * @param video  : the TeadsAd object
 */
- (void)teadsAdDidStop:(TeadsAd *)ad;

/**
 * Video Did Pause (paused)
 *
 * @param video  : the TeadsAd object
 */
- (void)teadsAdDidPause:(TeadsAd *)ad;

/**
 * Video Did Resume (playing)
 *
 * @param video  : the TeadsAd object
 */
- (void)teadsAdDidResume:(TeadsAd *)ad;

/**
 * Video Did Mute Sound
 *
 * @param video  : the TeadsAd object
 */
- (void)teadsAdDidMute:(TeadsAd *)ad;

/**
 * Video Did Unmute Sound
 *
 * @param video  : the TeadsAd object
 */
- (void)teadsAdDidUnmute:(TeadsAd *)ad;

/**
 * Video Can expand
 *
 * @param video  : the TeadsAd object
 */
- (void)teadsAdCanExpand:(TeadsAd *)ad withRatio:(CGFloat)ratio;

/**
 * Video Will expand
 *
 * @param video  : the TeadsAd object
 */
- (void)teadsAdWillExpand:(TeadsAd *)ad;

/**
 * Video Did expand
 *
 * @param video  : the TeadsAd object
 */
- (void)teadsAdDidExpand:(TeadsAd *)ad;

/**
 * Video Can collapse
 *
 * @param video  : the TeadsAd object
 */
- (void)teadsAdCanCollapse:(TeadsAd *)ad;

/**
 * Video Will collapse
 *
 * @param video  : the TeadsAd object
 */
- (void)teadsAdWillCollapse:(TeadsAd *)ad;

/**
 * Video did collapse
 *
 * @param video  : the TeadsAd object
 */
- (void)teadsAdDidCollapse:(TeadsAd *)ad;

/**
 * Video was clicked
 *
 * @param video  : the TeadsAd object
 */
- (void)teadsAdWasClicked:(TeadsAd *)ad;

/**
 * Video Did Stop Playing (stopped)
 *
 * @param video  : the TeadsAd object
 */
- (void)teadsAdDidClickBrowserClose:(TeadsAd *)ad;

/**
 * Video Will Take Over Fullscreen
 *
 * @param video  : the TeadsAd object
 */
- (void)teadsAdWillTakeOverFullScreen:(TeadsAd *)ad;

/**
 * Video Did Take Over Fullscreen
 *
 * @param video  : the TeadsAd object
 */
- (void)teadsAdDidTakeOverFullScreen:(TeadsAd *)ad;

/**
 * Video Will Dismiss Fullscreen
 *
 * @param video  : the TeadsAd object
 */
- (void)teadsAdWillDismissFullscreen:(TeadsAd *)ad;

/**
 * Video Did Dismiss Fullscreen
 *
 * @param video  : the TeadsAd object
 */
- (void)teadsAdDidDismissFullscreen:(TeadsAd *)ad;

/**
 * Video Skip Button Was Tapped (skip button pressed)
 *
 * @param video  : the TeadsAd object
 */
- (void)teadsAdSkipButtonTapped:(TeadsAd *)ad;

/**
 * Video Skip Button Did Show (skip button appeared)
 *
 * @param video  : the TeadsAd object
 */
- (void)teadsAdSkipButtonDidShow:(TeadsAd *)ad;

/**
 * Video did reset (player is closed if open, new load can be made after)
 *
 * @param video  : the TeadsAd object
 */
- (void)teadsAdDidReset:(TeadsAd *)ad;

/**
 * Video did clean (all related resoures have been removed)
 *
 * @param video  : the TeadsAd object
 */
- (void)teadsAdDidClean:(TeadsAd *)ad;
@end
