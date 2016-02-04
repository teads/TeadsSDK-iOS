//
//  TeadsInterstitial.h
//  TeadsSDK
//
//  Created by Ibrahim Ennafaa on 5/13/14.
//  Copyright (c) 2016 Teads. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TeadsError.h"

@protocol TeadsInterstitialDelegate;

@interface TeadsInterstitial : NSObject


//////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Properties
#pragma mark -
/////////////////////////////////////////////////////////////

@property (nonatomic) BOOL isLoaded; //returns YES if Teads Interstitial is loaded

@property (nonatomic, weak) id rootViewController;

@property (nonatomic, weak) id<TeadsInterstitialDelegate> delegate;

@property (nonatomic) BOOL playbackActive;

//////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Methods
#pragma mark -
/////////////////////////////////////////////////////////////

/**
 * -initInFlowWithPlacementId:rootViewController:delegate:
 *
 * @param placement         : a placement ID string
 * @param viewController    : the parent view-controller from which Teads Interstitial will be presented
 * @param teadsDelegate     : the instance that implements TeadsVideoDelegate
 */
- (id)initInFlowWithPlacementId:(NSString*)placement rootViewController:(id)viewController delegate:(id<TeadsInterstitialDelegate>)teadsDelegate;

- (void)load;       //Load the Teads Interstitial
- (void)cancelLoad; //Cancel Teads Interstitial load

- (void)show;       //Show the Teads Interstitial

/*
 * -clean
 *
 * destroys everything related to Teads Interstitial.
 * You will need to do a new init + load if you want to display a TeadsVideo again
 */
- (void)clean;

- (void)onLayoutChange; //Call when layout has changed

@end

//////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark TeadsInterstitialDelegate Delegate
#pragma mark -
/////////////////////////////////////////////////////////////

/**
 * Delegate about TeadsInterstitial object: set the viewController responsible of modal presentation
 * and gives information about TeadsInterstitial lifecycle
 */
@protocol TeadsInterstitialDelegate <NSObject>

@optional

/**
 * Interstitial Failed to Load
 *
 * @param interstitial  : the TeadsInterstitial object
 * @param error         : the EbzError object
 */
- (void)teadsInterstitial:(TeadsInterstitial *)interstitial didFailLoading:(TeadsError *)error;

/**
 * Interstitial Will Load (loading)
 *
 * @param interstitial  : the TeadsInterstitial object
 */
- (void)teadsInterstitialWillLoad:(TeadsInterstitial *)interstitial;

/**
 * Interstitial Did Load (loaded successfully)
 *
 * @param interstitial  : the TeadsInterstitial object
 */
- (void)teadsInterstitialDidLoad:(TeadsInterstitial *)interstitial;

/**
 * Video was clicked
 *
 * @param video  : the TeadsVideo object
 */
- (void)teadsInterstitialWasClicked:(TeadsInterstitial *)interstitial;

/**
 * Video Did Stop Playing (stopped)
 *
 * @param video  : the TeadsVideo object
 */
- (void)teadsInterstitialDidClickBrowserClose:(TeadsInterstitial *)interstitial;

/**
 * Interstitial Will Take Over Fullscreen (showing)
 *
 * @param interstitial  : the TeadsInterstitial object
 */
- (void)teadsInterstitialWillTakeOverFullScreen:(TeadsInterstitial *)interstitial;

/**
 * Interstitial Did Take Over Fullscreen (shown)
 *
 * @param interstitial  : the TeadsInterstitial object
 */
- (void)teadsInterstitialDidTakeOverFullScreen:(TeadsInterstitial *)interstitial;

/**
 * Interstitial Did mute Sound
 *
 * @param interstitial  : the TeadsInterstitial object
 */
- (void)teadsInterstitialDidMute:(TeadsInterstitial *)interstitial;

/**
 * Interstitial Did unmute Sound
 *
 * @param interstitial  : the TeadsInterstitial object
 */
- (void)teadsInterstitialDidUnmute:(TeadsInterstitial *)interstitial;

/**
 * Interstitial Will Dismiss Fullscreen (closing)
 *
 * @param interstitial  : the TeadsInterstitial object
 */
- (void)teadsInterstitialWillDismissFullScreen:(TeadsInterstitial *)interstitial;

/**
 * Interstitial Did Dismiss Fullscreen (closed)
 *
 * @param interstitial The TeadsInterstitial object
 */
- (void)teadsInterstitialDidDismissFullScreen:(TeadsInterstitial *)interstitial;

/**
 * Interstitial Did Clean
 *
 * @param interstitial  : the TeadsInterstitial object
 */
- (void)teadsInterstitialDidClean:(TeadsInterstitial *)interstitial;

@end