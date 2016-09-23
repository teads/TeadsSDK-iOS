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

/**
 * The position for inReadTop
 * @discussion Default value is TeadsAdInReadTopPositionHeader
 */
typedef NS_ENUM(NSInteger, TeadsVideoInReadTopPosition) {
    TeadsVideoInReadTopPositionHeader,
    TeadsVideoInReadTopPositionFooter
};

/**
 * Player color mode for start and end screens
 * @discussion Default value is TeadsVideoPlayerColorModeLight
 */
typedef NS_ENUM(NSInteger, TeadsVideoPlayerColorMode) {
    TeadsVideoPlayerColorModeDark,
    TeadsVideoPlayerColorModeLight
};

/**
 * The object used for displaying ads
 * @warning TeadsVideo is deprecated and going to be removed soon. Please use TeadsAd.
 */
__attribute__((deprecated ("use TeadsAd")))
@interface TeadsVideo : NSObject

//////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Properties
#pragma mark -
/////////////////////////////////////////////////////////////

/**
* Whether or not Teads Video is loaded
*/
@property (nonatomic, readonly) BOOL isLoaded;
/**
 * Whether or not Teads Video has started playing
 */
@property (nonatomic, readonly) BOOL isStarted;
/**
 * Whether or not Teads Video is playing
 */
@property (nonatomic, readonly) BOOL isPlaying;
/**
 * Whether or not Teads Video player sound is active
 */
@property (nonatomic, readonly) BOOL isSoundEnabled;

/**
 * The object listening to TeadsVideo
 */
@property (nonatomic, weak) id<TeadsVideoDelegate> delegate;

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
@property (nonatomic) TeadsVideoPlayerColorMode playerColorMode;

//////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Methods
#pragma mark -
/////////////////////////////////////////////////////////////

#pragma mark Custom Video

/**
 * Class constructor
 *
 * @param placement A placement ID string
 * @param teadsDelegate The instance that implements TeadsVideoDelegate
 */
- (id)initWithPlacementId:(NSString *)placement delegate:(id<TeadsVideoDelegate>)teadsDelegate;

#pragma mark
#pragma mark inReadTop

/**
 * Class constructor
 *
 * @param placement A placement ID string
 * @param scrollView A UIScrollView object
 * @param teadsDelegate The instance that implements TeadsVideoDelegate
 */
- (id)initInReadTopWithPlacementId:(NSString *)placement scrollView:(UIScrollView *)scrollView delegate:(id<TeadsVideoDelegate>)teadsDelegate;

#pragma mark -
#pragma mark inRead

/**
 * Class constructor
 *
 * @param placement A placement ID string
 * @param webView A UIWebview object
 * @param teadsDelegate The instance that implements TeadsVideoDelegate
 */
- (id)initInReadWithPlacementId:(NSString*)placement uiWebView:(UIWebView*)webView delegate:(id<TeadsVideoDelegate>)teadsDelegate;

/**
 * Class constructor
 *
 * @param placement A placement ID string
 * @param webView A WKWebview object
 * @param teadsDelegate The instance that implements TeadsVideoDelegate
 */
- (id)initInReadWithPlacementId:(NSString*)placement wkWebView:(WKWebView*)webView delegate:(id<TeadsVideoDelegate>)teadsDelegate;

/**
 * Class constructor
 *
 * @param placement A placement ID string
 * @param placeholderText A  DOM selector string
 * @param webView A UIWebview object
 * @param teadsDelegate The instance that implements TeadsVideoDelegate
 */
- (id)initInReadWithPlacementId:(NSString*)placement placeholderText:(NSString *)placeholderText uiWebView:(UIWebView*)webView delegate:(id<TeadsVideoDelegate>)teadsDelegate;

/**
 * Class constructor
 *
 * @param placement A placement ID string
 * @param placeholderText A DOM selector string
 * @param webView A WKWebView object
 * @param teadsDelegate The instance that implements TeadsVideoDelegate
 */
- (id)initInReadWithPlacementId:(NSString*)placement placeholderText:(NSString *)placeholderText wkWebView:(WKWebView*)webView delegate:(id<TeadsVideoDelegate>)teadsDelegate;

/**
 * Class constructor
 *
 * @param placement A placement ID string
 * @param afterView A UIView element after which the inRead will be displayed
 * @param scrollView A scroll-view object
 * @param teadsDelegate The instance that implements TeadsVideoDelegate
 */
- (id)initInReadWithPlacementId:(NSString*)placement afterView:(UIView *)afterView scrollView:(UIScrollView*)scrollView delegate:(id<TeadsVideoDelegate>)teadsDelegate;

/**
 * Class constructor
 *
 * @param placement A placement ID string
 * @param placeHolder A UIView that will contain Teads Video
 * @param constraint The height constraint of 'placeHolder' parameter
 * @param scrollView A scroll-view object
 * @param teadsDelegate The instance that implements TeadsVideoDelegate
 */
- (id)initInReadWithPlacementId:(NSString*)placement placeholder:(UIView *)placeHolder heightConstraint:(NSLayoutConstraint*)constraint scrollView:(UIScrollView*)scrollView delegate:(id<TeadsVideoDelegate>)teadsDelegate;

/**
 * Class constructor
 *
 * @param placement A placement ID string
 * @param indexPath The TeadsError object
 * @param tableView An index path locating a row in tableView where to insert Teads Video
 * @param teadsDelegate The instance that implements TeadsVideoDelegate
 */
- (id)initInReadWithPlacementId:(NSString*)placement insertionIndexPath:(NSIndexPath*)indexPath tableView:(UITableView*)tableView delegate:(id<TeadsVideoDelegate>)teadsDelegate;

/**
 * Class constructor
 *
 * @param placement A placement ID string
 * @param indexPath An index path locating a row in tableView where to insert Teads Video
 * @param repeat A boolean whether or not inRead should be repeated
 * @param tableView A tableView
 * @param teadsDelegate The instance that implements TeadsVideoDelegate
 */
- (id)initInReadWithPlacementId:(NSString*)placement insertionIndexPath:(NSIndexPath*)indexPath repeatMode:(BOOL)repeat tableView:(UITableView*)tableView delegate:(id<TeadsVideoDelegate>)teadsDelegate;

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
 * Load Teads Video
 */
- (void)load;
/**
 * Cancel  Teads Video load
 */
- (void)cancelLoad;

- (void)loadWithRequest:(NSURLRequest *)request forStartUrl:(NSString *)startUrl;

/*
 * Resets TeadsVideo
 *
 * @warning If TeadsVideo is opened : it will close it
 * @discussion After 'reset' call, you can do a new 'load' call (no need to init inRead/inReadTop again)
 *
*/
- (void)reset;

/*
 * Destroys everything related to TeadsVideo.
 *
 * @warning If TeadsVideo is opened : it will close it
 * @discussion You will need to do a new init inRead/inReadTop + load if you want to display a TeadsVideo again
*/
- (void)clean;

/**
 * Call when layout has changed to trigger a new size computer of our format
 */
- (void)onLayoutChange;

/**
 * Request to pause the ad
 *
 * @discussion If TeadsVideo can be paused : it will be paused, otherwise it won't
 */
- (void)requestPause;
/**
 * Request to resume the ad
 * @discussion If TeadsVideo can resume : it will resume, otherwise it won't
 */
- (void)requestPlay;

/*
 * Inform TeadsVideo that its parent view controller appeared
 *
 * @param viewController The view controller that will display the  Teads Video
 * @discussion This method has to be called in your view-controller -viewDidAppear: method
 *
 */
- (void)viewControllerAppeared:(UIViewController *)viewController;

/*
 * Inform TeadsVideo that its parent view controller did disappear
 *
 * @param viewController The view controller that will display the Teads Video
 * @discussion This method has to be called in your view controller -viewDidDisappear: method
 *
 */
- (void)viewControllerDisappeared:(UIViewController *)viewController;

/**
 * Get the expanded frame of Teads Video.
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


#pragma mark Methods for Custom Video

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
#pragma mark TeadsVideoDelegate Delegate
#pragma mark -
/////////////////////////////////////////////////////////////

/**
 * The protocol used for listening to TeadsVideo events and give information about TeadsVideo lifecycle
 * @warning TeadsVideo and TeadsVideoDelegate are deprecated and going to be removed soon. Please use TeadsAd and TeadsAdDelegate.
 */
__attribute__((deprecated ("use TeadsAdDelegate")))
@protocol TeadsVideoDelegate <NSObject>

@optional


/**
 * Video Failed to Load
 *
 * @param video The TeadsVideo object
 * @param error The TeadsError object
 */
- (void)teadsVideo:(TeadsVideo *)video didFailLoading:(TeadsError *)error;

/**
 * Video Will Load (loading)
 *
 * @param video The TeadsVideo object
 */
- (void)teadsVideoWillLoad:(TeadsVideo *)video;

/**
 * Video Did Load (loaded successfully)
 *
 * @param video The TeadsVideo object
 */
- (void)teadsVideoDidLoad:(TeadsVideo *)video;

/**
 * Video Will Start Playing (loading)
 *
 * @param video The TeadsVideo object
 */
- (void)teadsVideoWillStart:(TeadsVideo *)video;

/**
 * Video Did Start Playing (playing)
 *
 * @param video The TeadsVideo object
 */
- (void)teadsVideoDidStart:(TeadsVideo *)video;

/**
 * Video Will Stop Playing (stopping)
 *
 * @param video The TeadsVideo object
 */
- (void)teadsVideoWillStop:(TeadsVideo *)video;

/**
 * Video Did Stop Playing (stopped)
 *
 * @param video The TeadsVideo object
 */
- (void)teadsVideoDidStop:(TeadsVideo *)video;

/**
 * Video Did Pause (paused)
 *
 * @param video The TeadsVideo object
 */
- (void)teadsVideoDidPause:(TeadsVideo *)video;

/**
 * Video Did Resume (playing)
 *
 * @param video The TeadsVideo object
 */
- (void)teadsVideoDidResume:(TeadsVideo *)video;

/**
 * Video Did Mute Sound
 *
 * @param video The TeadsVideo object
 */
- (void)teadsVideoDidMute:(TeadsVideo *)video;

/**
 * Video Did Unmute Sound
 *
 * @param video The TeadsVideo object
 */
- (void)teadsVideoDidUnmute:(TeadsVideo *)video;

/**
 * Video Can expand
 *
 * @param video The TeadsVideo object
 */
- (void)teadsVideoCanExpand:(TeadsVideo *)video withRatio:(CGFloat)ratio;

/**
 * Video Will expand
 *
 * @param video The TeadsVideo object
 */
- (void)teadsVideoWillExpand:(TeadsVideo *)video;

/**
 * Video Did expand
 *
 * @param video The TeadsVideo object
 */
- (void)teadsVideoDidExpand:(TeadsVideo *)video;

/**
 * Video Can collapse
 *
 * @param video The TeadsVideo object
 */
- (void)teadsVideoCanCollapse:(TeadsVideo *)video;

/**
 * Video Will collapse
 *
 * @param video The TeadsVideo object
 */
- (void)teadsVideoWillCollapse:(TeadsVideo *)video;

/**
 * Video did collapse
 *
 * @param video The TeadsVideo object
 */
- (void)teadsVideoDidCollapse:(TeadsVideo *)video;

/**
 * Video was clicked
 *
 * @param video The TeadsVideo object
 */
- (void)teadsVideoWasClicked:(TeadsVideo *)video;

/**
 * Video Did Stop Playing (stopped)
 *
 * @param video The TeadsVideo object
 */
- (void)teadsVideoDidClickBrowserClose:(TeadsVideo *)video;

/**
 * Video Will Take Over Fullscreen
 *
 * @param video The TeadsVideo object
 */
- (void)teadsVideoWillTakeOverFullScreen:(TeadsVideo *)video;

/**
 * Video Did Take Over Fullscreen
 *
 * @param video The TeadsVideo object
 */
- (void)teadsVideoDidTakeOverFullScreen:(TeadsVideo *)video;

/**
 * Video Will Dismiss Fullscreen
 *
 * @param video The TeadsVideo object
 */
- (void)teadsVideoWillDismissFullscreen:(TeadsVideo *)video;

/**
 * Video Did Dismiss Fullscreen
 *
 * @param video The TeadsVideo object
 */
- (void)teadsVideoDidDismissFullscreen:(TeadsVideo *)video;

/**
 * Video Skip Button Was Tapped (skip button pressed)
 *
 * @param video The TeadsVideo object
 */
- (void)teadsVideoSkipButtonTapped:(TeadsVideo *)video;

/**
 * Video Skip Button Did Show (skip button appeared)
 *
 * @param video The TeadsVideo object
 */
- (void)teadsVideoSkipButtonDidShow:(TeadsVideo *)video;

/**
 * Video did reset (player is closed if open, new load can be made after)
 *
 * @param video The TeadsVideo object
 */
- (void)teadsVideoDidReset:(TeadsVideo *)video;

/**
 * Video did clean (all related resoures have been removed)
 *
 * @param video The TeadsVideo object
 */
- (void)teadsVideoDidClean:(TeadsVideo *)video;
@end
