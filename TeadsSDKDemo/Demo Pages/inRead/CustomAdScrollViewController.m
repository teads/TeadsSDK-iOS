//
//  SimpleInReadScrollViewViewController.m
//  TeadsSDKDemo
//
//  Created by Nikolaï Roycourt on 28/07/2015.
//  Copyright (c) 2015 Teads. All rights reserved.
//

#import "CustomAdScrollViewController.h"

@interface CustomAdScrollViewController ()

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic) CGFloat adRatio; //Ad ratio provided by delegate callback -teadsAdCanExpand:withRatio:
@property (strong, nonatomic) TeadsAd *teadsAd;
@property (strong, nonatomic) IBOutlet UILabel *uiLabelForReference;
@property (strong, nonatomic) IBOutlet UILabel *bottomLabelForReference;

@end

@implementation CustomAdScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.scrollView.delegate = self;
    
    NSString *pid = [[NSUserDefaults standardUserDefaults] stringForKey:@"pid"];
    
    self.teadsAd = [[TeadsAd alloc] initWithPlacementId:pid delegate:self];
    
    //Set a collapsed frame to TeadsAd.videoView
    CGRect collapsedAdFrame = CGRectMake(CGRectGetMinX(self.uiLabelForReference.frame),
                                CGRectGetMaxY(self.uiLabelForReference.frame)+5,
                                CGRectGetWidth(self.uiLabelForReference.frame),
                                0);
    [self.teadsAd.videoView setFrame:collapsedAdFrame];
    [self.scrollView addSubview:self.teadsAd.videoView];
    [self.teadsAd videoViewWasAdded]; //Inform that you added TeadsAd.videoView to the scrolling element
    
    //Observer for device rotation (needed for you to potentially recompute TeadsAd.videoView frame size)
    [[NSNotificationCenter defaultCenter] addObserver: self selector:@selector(deviceOrientationDidChange:) name: UIDeviceOrientationDidChangeNotification object: nil];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.teadsAd.isLoaded) {
        [self.teadsAd viewControllerAppeared:self];
    } else {
        [self.teadsAd load];
    }
}

-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.teadsAd viewControllerDisappeared:self];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}

#pragma mark -
#pragma UIScrollView

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.teadsAd videoViewDidMove:scrollView];
}

#pragma mark Orientation change

-(void)deviceOrientationDidChange:(NSNotification *)notification {
    [self updateTeadsAdFrame];
    
    //Because of rotation, layout of the content of the scrollview changed with their respective positions.
    //Inform teadsAd that there was a move  (because of rotation)
    [self.teadsAd videoViewDidMove:self.scrollView];
}

#pragma mark -
#pragma mark - Your methods to calculate Custom Ad size

//Compute TeadsAd frame according the UI of you app
-(void)updateTeadsAdFrame {
   
    CGFloat adFrameHeight = CGRectGetMinY(self.bottomLabelForReference.frame) - 5 - CGRectGetMaxY(self.uiLabelForReference.frame) - 5;
    CGFloat adFrameWidth = adFrameHeight/self.adRatio;
    
    CGFloat adFrameOriginX = (CGRectGetMaxX(self.uiLabelForReference.frame)-adFrameWidth)/2;
    CGFloat adFrameOriginY = CGRectGetMaxY(self.uiLabelForReference.frame) + 5;
    
    CGRect adFrame = CGRectMake(adFrameOriginX,
                                adFrameOriginY,
                                adFrameWidth,
                                adFrameHeight);
    
    //If TeadsAd frame height is bigger than its container, size must be adjusted so that it fits in it
    if (adFrame.size.height > self.scrollView.bounds.size.height && self.adRatio > 0) {
        adFrame = CGRectMake(adFrame.origin.x,
                             adFrame.origin.y,
                             self.scrollView.bounds.size.height/self.adRatio,
                             self.scrollView.bounds.size.height);
    }
    
    [self.teadsAd.videoView setFrame:adFrame];
}


#pragma mark -
#pragma mark - TeadsAd delegate

/**
 * TeadsAd Did Load (loaded successfully)
 *
 * @param TeadsAd  : the TeadsAd object
 */
- (void)teadsAdDidLoad:(TeadsAd *)nativeVideo{
    
}

/**
 * Teads Ad is ready to be shown
 *
 * @param ad  : the TeadsAd object
 */
- (void)teadsAdCanExpand:(TeadsAd *)ad withRatio:(CGFloat)ratio {
    self.adRatio = ratio;
    
    CGFloat adFrameHeight = CGRectGetMinY(self.bottomLabelForReference.frame) - 5 - CGRectGetMaxY(self.uiLabelForReference.frame) - 5;
    CGFloat adFrameWidth = adFrameHeight/self.adRatio;
    
    CGFloat adFrameOriginX = (CGRectGetMaxX(self.uiLabelForReference.frame)-adFrameWidth)/2;
    CGFloat adFrameOriginY = CGRectGetMaxY(self.uiLabelForReference.frame) + 5;
    
    //Expand animation and duration are optional, choose what fits best for your app
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionTransitionFlipFromTop animations:^{
        [self.teadsAd.videoView setFrame:CGRectMake(adFrameOriginX,
                                                    adFrameOriginY,
                                                    adFrameWidth,
                                                    adFrameHeight)];
    } completion:^(BOOL finished) {
        [self.teadsAd videoViewDidExpand];
    }];
}

/**
 * Teads Ad can be collapsed
 *
 * @param ad  : the TeadsAd object
 */
- (void)teadsAdCanCollapse:(TeadsAd *)ad {
    
    CGRect collapsedFrame = CGRectMake(CGRectGetMinX(self.teadsAd.videoView.frame),
                                       CGRectGetMinY(self.teadsAd.videoView.frame)+5,
                                       CGRectGetWidth(self.teadsAd.videoView.frame),
                                       0);
    
    //Collapse animation and duration are optional, choose what fits best for your app
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionTransitionFlipFromTop animations:^{
        [self.teadsAd.videoView setFrame:collapsedFrame];
    } completion:^(BOOL finished) {
        [self.teadsAd videoViewDidCollapse];
    }];
    
}


@end
