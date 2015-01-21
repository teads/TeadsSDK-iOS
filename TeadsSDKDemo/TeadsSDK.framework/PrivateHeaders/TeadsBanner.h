//
//  TeadsBanner.h
//  TeadsSDKDev
//
//  Created by Emmanuel Digiaro on 5/6/14.
//  Copyright (c) 2014 Ebuzzing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TeadsError.h"

#define IPHONE_BANNER_320x50             CGSizeMake(320, 50)
#define IPAD_BANNER_728x90               CGSizeMake(728, 90)

@protocol TeadsBannerDelegate;

@interface TeadsBanner : NSObject

//////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Properties
#pragma mark -
/////////////////////////////////////////////////////////////

@property (nonatomic) BOOL isLoaded;

@property (nonatomic) BOOL isExpanded;

@property (nonatomic, weak) id rootViewController;

@property (nonatomic, weak) id<TeadsBannerDelegate> delegate;

//////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Methods
#pragma mark -
/////////////////////////////////////////////////////////////

- (id)initInlineWithPlacementId:(NSString*)placement placeholderView:(UIView*)placeholder rootViewController:(id)viewController delegate:(id<TeadsBannerDelegate>)teadsDelegate;

- (void)load;

- (void)forceCreativeUrl:(NSString*)creativeUrl;

- (void)clean;

- (void)onLayoutChange;

@end

//////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark teadsBanner Delegate
#pragma mark -
/////////////////////////////////////////////////////////////

/**
 * Delegate about teadsBanner object: gives information about teadsBanner lifecycle
 */
@protocol TeadsBannerDelegate <NSObject>


@optional

/**
 * Banner Failed to Load
 *
 * @param banner    : the teadsBanner object
 * @param error     : the teadsError object
 */
- (void)teadsBanner:(TeadsBanner *)banner didFailLoading:(TeadsError *)error;

/**
 * Banner Will Load (loading)
 *
 * @param banner    : the teadsBanner object
 */
- (void)teadsBannerWillLoad:(TeadsBanner *)banner;

/**
 * Banner Did Load (loaded successfully)
 *
 * @param banner    : the teadsBanner object
 */
- (void)teadsBannerDidLoad:(TeadsBanner *)banner;

/**
 * Banner Will Take Over Fullscreen (expanding)
 *
 * @param banner    : the teadsBanner object
 */
- (void)teadsBannerWillTakeOverFullScreen:(TeadsBanner *)banner;

/**
 * Banner Did Take Over Fullscreen (expanded)
 *
 * @param banner    : the teadsBanner object
 */
- (void)teadsBannerDidTakeOverFullScreen:(TeadsBanner *)banner;

/**
 * Banner Will Dismiss Fullscreen (closing)
 *
 * @param banner    : the teadsBanner object
 */
- (void)teadsBannerWillDismissFullScreen:(TeadsBanner *)banner;

/**
 * Banner Did Dismiss Fullscreen (closed)
 *
 * @param banner    : the teadsBanner object
 */
- (void)teadsBannerDidDismissFullScreen:(TeadsBanner *)banner;

@end
