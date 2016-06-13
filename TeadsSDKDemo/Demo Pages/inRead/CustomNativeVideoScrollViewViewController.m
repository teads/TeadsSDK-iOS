//
//  SimpleInReadScrollViewViewController.m
//  TeadsSDKDemo
//
//  Created by Nikolaï Roycourt on 28/07/2015.
//  Copyright (c) 2015 Teads. All rights reserved.
//

#import "CustomNativeVideoScrollViewViewController.h"

////Defines the Teads video frame before display
#define collapsedVideoViewFrame CGRectMake(8, 715, 359, 0)
//
////Defines the Teads video frame for display
//#define expandedVideoViewFrame CGRectMake(8, 715, 359, 220)

@interface CustomNativeVideoScrollViewViewController ()

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) TeadsAd *teadsAd;
@property (strong, nonatomic) IBOutlet UILabel *uiLabelForReference;

//Defines the Teads video frame for display
@property (nonatomic, assign) CGRect expandedVideoViewFrame;

@end

@implementation CustomNativeVideoScrollViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.scrollView.delegate = self;
    
    NSString *pid = [[NSUserDefaults standardUserDefaults] stringForKey:@"pid"];
    
    self.teadsAd = [[TeadsAd alloc] initWithPlacementId:pid delegate:self];
    
    [self.teadsAd.videoView setFrame:collapsedVideoViewFrame];
    [self.scrollView addSubview:self.teadsAd.videoView];
    [self.teadsAd videoViewWasAdded];
    [self.teadsAd load];
}

-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.teadsAd viewControllerDisappeared:self];
}

#pragma mark -
#pragma UIScrollView

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.teadsAd videoViewDidMove:scrollView];
}

#pragma mark -
#pragma mark Teads delegate

/**
 * NativeVideo Did Load (loaded successfully)
 *
 * @param interstitial  : the TeadsVideo object
 */
- (void)teadsAdDidLoad:(TeadsAd *)nativeVideo{
    
}

/**
 * Teads Video is ready to be shown
 *
 * @param video  : the TeadsVideo object
 */
- (void)teadsAdCanExpand:(TeadsAd *)video WithRatio:(CGFloat)ratio{
    
    CGFloat videoViewFrameWidth = CGRectGetMaxX(self.uiLabelForReference.frame) - CGRectGetMinX(self.uiLabelForReference.frame);
    
    [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionTransitionFlipFromTop animations:^{
        [self.teadsAd.videoView setFrame:CGRectMake(CGRectGetMinX(self.uiLabelForReference.frame),
                                                       CGRectGetMaxY(self.uiLabelForReference.frame),
                                                       videoViewFrameWidth,
                                                       videoViewFrameWidth * ratio)];
    } completion:^(BOOL finished) {
        [self.teadsAd videoViewDidExpand];
    }];
}

/**
 * Teads Video can be collapsed
 *
 * @param video  : the TeadsVideo object
 */
- (void)teadsAdCanCollapse:(TeadsAd *)video {
    
    CGRect collapsedFrame = CGRectMake(CGRectGetMinX(self.teadsAd.videoView.frame),
                                       CGRectGetMinY(self.teadsAd.videoView.frame),
                                       CGRectGetWidth(self.teadsAd.videoView.frame),
                                       0);
    
    [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionTransitionFlipFromTop animations:^{
        [self.teadsAd.videoView setFrame:collapsedFrame];
    } completion:^(BOOL finished) {
        [self.teadsAd videoViewDidCollapse];
    }];
    
}


@end
