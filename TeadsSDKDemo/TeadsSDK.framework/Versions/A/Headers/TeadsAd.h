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

/**
 * The position for inReadTop
 * @discussion Default value is TeadsAdInReadTopPositionHeader
 */
typedef NS_ENUM(NSInteger, TeadsAdInReadTopPosition) {
    TeadsAdInReadTopPositionHeader,
    TeadsAdInReadTopPositionFooter
};

/**
 * Player color mode for start and end screens
 * @discussion Default value is TeadsAdPlayerColorModeLight
 */
typedef NS_ENUM(NSInteger, TeadsAdPlayerColorMode) {
    TeadsAdPlayerColorModeDark,
    TeadsAdPlayerColorModeLight
};

/**
 * The object used for displaying ads
 */
@interface TeadsAd : NSObject

//////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Properties
#pragma mark -
/////////////////////////////////////////////////////////////

/**
 * Whether or not Teads Ad is loaded
 */
@property (nonatomic, readonly) BOOL isLoaded;
/**
 * Whether or not Teads Ad has started playing
 */
@property (nonatomic, readonly) BOOL isStarted;
/**
 * Whether or not Teads Ad is playing
 */
@property (nonatomic, readonly) BOOL isPlaying;
/**
 * Whether or not Teads Ad player sound is active
 */
@property (nonatomic, readonly) BOOL isSoundEnabled;


/**
 * The object listening to TeadsAd
 */
@property (nonatomic, weak) id<TeadsAdDelegate> delegate;


/**
 * Whether or not playback is active
 */
@property (nonatomic) BOOL playbackActive;
/**
 * Set a max width for the ad container
 * @discussion Setting this value is optionnal
 */
@property (nonatomic) CGFloat maxContainerWidth;
/**
 * Set a max height for the ad container
 * @discussion Setting this value is optionnal
 */
@property (nonatomic) CGFloat maxContainerHeight;

/**
 * Set a player color mode for start and end screens
 * @discussion Setting this value is optionnal
 */
@property (nonatomic) TeadsAdPlayerColorMode playerColorMode;

//////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Methods
#pragma mark -
/////////////////////////////////////////////////////////////

#pragma mark Custom Ad

/**
 * Class constructor
 *
 * @param placement A placement ID string
 * @param teadsDelegate The instance that implements TeadsAdDelegate
 */
- (id)initWithPlacementId:(NSString *)placement delegate:(id<TeadsAdDelegate>)teadsDelegate;

#pragma mark
#pragma mark inReadTop

/**
 * Class constructor
 *
 * @param placement A placement ID string
 * @param scrollView A UIScrollView object
 * @param teadsDelegate The instance that implements TeadsAdDelegate
 */
- (id)initInReadTopWithPlacementId:(NSString *)placement scrollView:(UIScrollView *)scrollView delegate:(id<TeadsAdDelegate>)teadsDelegate;

/**
 * Class constructor
 *
 * @param placement A placement ID string
 * @param scrollView A UIScrollView object
 * @param position The position of the inReadTop
 * @param teadsDelegate The instance that implements TeadsAdDelegate
 * @discussion Default position is TeadsAdInReadTopPositionHeader
 */
- (id)initInReadTopWithPlacementId:(NSString *)placement position:(TeadsAdInReadTopPosition)position scrollView:(UIScrollView *)scrollView delegate:(id<TeadsAdDelegate>)teadsDelegate;


#pragma mark -
#pragma mark inRead

/**
 * Class constructor
 *
 * @param placement A placement ID string
 * @param webView A UIWebview object
 * @param teadsDelegate The instance that implements TeadsAdDelegate
 */
- (id)initInReadWithPlacementId:(NSString*)placement uiWebView:(UIWebView*)webView delegate:(id<TeadsAdDelegate>)teadsDelegate;

/**
 * Class constructor
 *
 * @param placement A placement ID string
 * @param webView A WKWebview object
 * @param teadsDelegate The instance that implements TeadsAdDelegate
 */
- (id)initInReadWithPlacementId:(NSString*)placement wkWebView:(WKWebView*)webView delegate:(id<TeadsAdDelegate>)teadsDelegate;

/**
 * Class constructor
 *
 * @param placement A placement ID string
 * @param placeholderText A DOM selector string
 * @param webView A UIWebview object
 * @param teadsDelegate The instance that implements TeadsAdDelegate
 */
- (id)initInReadWithPlacementId:(NSString*)placement placeholderText:(NSString *)placeholderText uiWebView:(UIWebView*)webView delegate:(id<TeadsAdDelegate>)teadsDelegate;

/**
 * Class constructor
 *
 * @param placement A placement ID string
 * @param placeholderText A DOM selector string
 * @param webView A WKWebView object
 * @param teadsDelegate The instance that implements TeadsAdDelegate
 */
- (id)initInReadWithPlacementId:(NSString*)placement placeholderText:(NSString *)placeholderText wkWebView:(WKWebView*)webView delegate:(id<TeadsAdDelegate>)teadsDelegate;

/**
 * Class constructor
 *
 * @param placement A placement ID string
 * @param afterView A UIView element after which the inRead will be displayed
 * @param scrollView A scroll-view object
 * @param teadsDelegate The instance that implements TeadsAdDelegate
 */
- (id)initInReadWithPlacementId:(NSString*)placement afterView:(UIView *)afterView scrollView:(UIScrollView*)scrollView delegate:(id<TeadsAdDelegate>)teadsDelegate;

/**
 * Class constructor
 *
 * @param placement   A placement ID string
 * @param placeHolder A UIView that will contain Teads Ad
 * @param constraint The height constraint of 'placeHolder' parameter
 * @param scrollView  A scroll-view object
 * @param teadsDelegate The instance that implements TeadsAdDelegate
 */
- (id)initInReadWithPlacementId:(NSString*)placement placeholder:(UIView *)placeHolder heightConstraint:(NSLayoutConstraint*)constraint scrollView:(UIScrollView*)scrollView delegate:(id<TeadsAdDelegate>)teadsDelegate;

/**
 * Class constructor
 *
 * @param placement A placement ID string
 * @param indexPath An index path locating a row in tableView where to insert Teads Ad
 * @param tableView A UITableView object
 * @param teadsDelegate The instance that implements TeadsAdDelegate
 */
- (id)initInReadWithPlacementId:(NSString*)placement insertionIndexPath:(NSIndexPath*)indexPath tableView:(UITableView*)tableView delegate:(id<TeadsAdDelegate>)teadsDelegate;

/**
 * -initInReadWithPlacementId:insertionIndexPath:repeatMode:tableView:delegate:
 *
 * @param placement A placement ID string
 * @param indexPath An index path locating a row in tableView where to insert Teads Ad
 * @param repeat A boolean whether or not inRead should be repeated
 * @param tableView A UITableView object
 * @param teadsDelegate The instance that implements TeadsAdDelegate
 */
- (id)initInReadWithPlacementId:(NSString*)placement insertionIndexPath:(NSIndexPath*)indexPath repeatMode:(BOOL)repeat tableView:(UITableView*)tableView delegate:(id<TeadsAdDelegate>)teadsDelegate;

#pragma mark Common methods

/*
 * Set the wanted color for the inReadTop background only
 *
 * @param backgroundColor A UIColor
 *
 */
- (void)setBackgroundColor:(UIColor *)backgroundColor;

/*
 * Set the real scrollView of your interface that in the end contains the inRead
 *
 * @param scrollView A UIScrollView
 * @discussion Eg: You have a webview in which you want to display an inRead. The webView.scrollView.scrollEnabled is set to NO, and your webview is embedded in a scrollView or tableView which is the scrolling element. You have then to call -setAltScrollView:  providing the scrolling UI-element
 *
 */
- (void)setAltScrollView:(UIScrollView *)scrollView;

/**
 * Load Teads Ad
 */
- (void)load;
/**
 * Cancel Teads Ad load
 */
- (void)cancelLoad;


- (void)loadWithRequest:(NSURLRequest *)request forStartUrl:(NSString *)startUrl;

/*
 *
 * Resets TeadsAd
 *
 * @warning If TeadsAd is opened : it will close it
 * @discussion After 'reset' call, you can do a new 'load' call (no need to init inRead/inReadTop again)
 *
 */
- (void)reset;

/*
 * Destroys everything related to TeadsAd.
 *
 * @warning If TeadsAd is opened : it will close it
 * @discussion You will need to do a new init inRead/inReadTop + load if you want to display a TeadsAd again
 */
- (void)clean;

/**
 * Call when layout has changed to trigger a new size computer of our format
 */
- (void)onLayoutChange;

/**
 * Request to pause the ad
 *
 * @discussion If TeadsAd can be paused : it will be paused, otherwise it won't
 */
- (void)requestPause;
/**
 * Request to resume the ad
 * @discussion If TeadsAd can resume : it will resume, otherwise it won't
 */
- (void)requestPlay;

/*
 * Inform TeadsAd that its parent view controller appeared
 *
 * @param viewController : the view controller that will display the Teads Ad
 * @discussion This method has to be called in your view-controller -viewDidAppear: method
 *
 */
- (void)viewControllerAppeared:(UIViewController *)viewController;

/*
 * Inform TeadsAd that its parent view controller did disappear
 *
 * @param viewController : the view controller that will display the Teads Ad
 * @discussion This method has to be called in your view controller -viewDidDisappear: method
 *
 */
- (void)viewControllerDisappeared:(UIViewController *)viewController;

/**
 * Get the expanded frame of Teads Ad.
 */
- (CGRect)expandedFrame;
/**
 * Get expand animation duration
 */
- (float)expandAnimationDuration;
/**
 * Get collapse animation duration
 */
- (float)collapseAnimationDuration;

#pragma mark Method for inRead in TableView

/**
 * Set a new index path for inRead in tableView
 *
 * @param newIndexPath A NSIndexPath s
 * @warning This has to be set BEFORE calling `load` method
 * @discussion Can be used when TableView data is loaded asynchronously or chunk by chunk
 */
- (void)setInReadInsertionIndexPath:(NSIndexPath*)newIndexPath;


#pragma mark Methods for Custom Ad

/**
 * Get the UIView for Custom Ad which contains the player
 *
 * @discussion To be used only for Custom Ad type instance
 */
- (UIView *)videoView;
/**
 * Call to inform that videoView was added to your user interface
 *
 * @discussion To be used only for Custom Video type instance
 */
- (void)videoViewWasAdded;
/**
 * Call to inform that the container view did move
 *
 * @param containerView The container view in which the video has moved
 * @discussion Eg: A ScrollView is the top UI component, we have to call -videoViewDidMove: when user scrolls that the Video will still be viewable
 */
- (void)videoViewDidMove:(UIView *)containerView;
/**
 * Call to inform that videoView frame has been expanded
 * @discussion To be used only for Custom Video type instance
 */
- (void)videoViewDidExpand;
/**
 * Call to inform that videoView frame has been collapsed
 * @discussion To be used only for Custom Video type instance
 */
- (void)videoViewDidCollapse;

@end

//////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark TeadsAdDelegate Delegate
#pragma mark -
/////////////////////////////////////////////////////////////

/**
 * The protocol used for listening to TeadsAd events and give information about TeadsAd lifecycle
 */
@protocol TeadsAdDelegate <NSObject>

@optional


/**
 * Ad failed to load
 *
 * @param ad The TeadsAd object
 * @param error The TeadsError object
 */
- (void)teadsAd:(TeadsAd *)ad didFailLoading:(TeadsError *)error;

/**
 * Ad will load (loading)
 *
 * @param ad The TeadsAd object
 */
- (void)teadsAdWillLoad:(TeadsAd *)ad;

/**
 * Ad did load (loaded successfully)
 *
 * @param ad The TeadsAd object
 */
- (void)teadsAdDidLoad:(TeadsAd *)ad;

/**
 * Ad experience will start
 *
 * @param ad The TeadsAd object
 */
- (void)teadsAdWillStart:(TeadsAd *)ad;

/**
 * Ad experience did start
 *
 * @param ad The TeadsAd object
 */
- (void)teadsAdDidStart:(TeadsAd *)ad;

/**
 * Ad experience stop
 *
 * @param ad The TeadsAd object
 */
- (void)teadsAdWillStop:(TeadsAd *)ad;

/**
 * Ad experience did stop
 *
 * @param ad The TeadsAd object
 */
- (void)teadsAdDidStop:(TeadsAd *)ad;

/**
 * Ad experience did pause
 *
 * @param ad The TeadsAd object
 */
- (void)teadsAdDidPause:(TeadsAd *)ad;

/**
 * Ad experience did resume
 *
 * @param ad The TeadsAd object
 */
- (void)teadsAdDidResume:(TeadsAd *)ad;

/**
 * Ad did mute sound
 *
 * @param ad The TeadsAd object
 */
- (void)teadsAdDidMute:(TeadsAd *)ad;

/**
 * Ad did unmute sound
 *
 * @param ad The TeadsAd object
 */
- (void)teadsAdDidUnmute:(TeadsAd *)ad;

/**
 * Ad can expand
 *
 * @param ad The TeadsAd object
 * @dicussion Triggered when using Custom Ad to inform you that you can expand your container view
 */
- (void)teadsAdCanExpand:(TeadsAd *)ad withRatio:(CGFloat)ratio;

/**
 * Ad will expand
 *
 * @param ad The TeadsAd object
 */
- (void)teadsAdWillExpand:(TeadsAd *)ad;

/**
 * Ad did expand
 *
 * @param ad The TeadsAd object
 */
- (void)teadsAdDidExpand:(TeadsAd *)ad;

/**
 * Ad can collapse
 *
 * @param ad The TeadsAd object
* @dicussion Triggered when using Custom Ad to inform you that you can collapse your container view
 */
- (void)teadsAdCanCollapse:(TeadsAd *)ad;

/**
 * Ad will collapse
 *
 * @param ad The TeadsAd object
 */
- (void)teadsAdWillCollapse:(TeadsAd *)ad;

/**
 * Ad did collapse
 *
 * @param ad The TeadsAd object
 */
- (void)teadsAdDidCollapse:(TeadsAd *)ad;

/**
 * Ad was clicked
 *
 * @param ad The TeadsAd object
 */
- (void)teadsAdWasClicked:(TeadsAd *)ad;

/**
 * Ad experience did stop
 *
 * @param ad The TeadsAd object
 */
- (void)teadsAdDidClickBrowserClose:(TeadsAd *)ad;

/**
 * Ad will take over fullscreen
 *
 * @param ad The TeadsAd object
 */
- (void)teadsAdWillTakeOverFullScreen:(TeadsAd *)ad;

/**
 * Ad did take over fullscreen
 *
 * @param ad The TeadsAd object
 */
- (void)teadsAdDidTakeOverFullScreen:(TeadsAd *)ad;

/**
 * Ad qill dismiss fullscreen
 *
 * @param ad The TeadsAd object
 */
- (void)teadsAdWillDismissFullscreen:(TeadsAd *)ad;

/**
 * Ad did dismiss fullscreen
 *
 * @param ad The TeadsAd object
 */
- (void)teadsAdDidDismissFullscreen:(TeadsAd *)ad;

/**
 * Ad Skip Button Was Tapped
 *
 * @param ad The TeadsAd object
 * @discussion Eg: skip button was pressed
 */
- (void)teadsAdSkipButtonTapped:(TeadsAd *)ad;

/**
 * Ad skip button appeared
 *
 * @param ad The TeadsAd object
 */
- (void)teadsAdSkipButtonDidShow:(TeadsAd *)ad;

/**
 * Ad did reset
 *
 * @param ad The TeadsAd object
 * @discussion Player is closed if open, new `load` call can be made after
 */
- (void)teadsAdDidReset:(TeadsAd *)ad;

/**
 * Ad did clean
 *
 * @param ad The TeadsAd object
 * @discussion All related resoures have been removed
 */
- (void)teadsAdDidClean:(TeadsAd *)ad;
@end
