//
//  TeadsInterstitial.h
//  TeadsSDKDev
//
//  Created by Emmanuel Digiaro on 5/13/14.
//  Copyright (c) 2014 Ebuzzing. All rights reserved.
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

@property (nonatomic) BOOL isLoaded;

@property (nonatomic, weak) id rootViewController;

@property (nonatomic, weak) id<TeadsInterstitialDelegate> delegate;

@property (nonatomic) BOOL playbackActive;

//////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Methods
#pragma mark -
/////////////////////////////////////////////////////////////

- (id)initInFlowWithPlacementId:(NSString*)placement rootViewController:(id)viewController delegate:(id<TeadsInterstitialDelegate>)teadsDelegate;

- (void)setPreDownLoad:(BOOL)preDownload;

- (void)load;
- (void)loadFromFactory;

- (void)show;

- (void)forceCreativeUrl:(NSString*)creativeUrl;

- (void)clean;

- (void)setRewardEnabled:(BOOL)enabled;

- (BOOL)isRewardEnabled;

- (void)setRewardInfo:(NSString*)userId withDebug:(BOOL)debug;

- (void)onLayoutChange;

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
 * Interstitial Unlocked Reward
 *
 * @param interstitial  : the TeadsInterstitial object
 */
- (void)teadsInterstitialRewardUnlocked:(TeadsInterstitial *)interstitial;

/**
 * Interstitial Did Clean
 *
 * @param interstitial  : the TeadsInterstitial object
 */
- (void)teadsInterstitialDidClean:(TeadsInterstitial *)interstitial;

@end