//
//  InFlowViewController.m
//  TeadsSDKDemo
//
//  Created by Nikolaï Roycourt on 16/01/2015.
//  Copyright (c) 2015 Teads. All rights reserved.
//

#import "InFlowViewController.h"

@interface InFlowViewController ()
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) IBOutlet UIButton *loadInFlowButton;
@property (strong, nonatomic) IBOutlet UIButton *showInFlowButton;

//Your boolean : will be used to track load status of the ad
@property (assign, nonatomic) BOOL adExperienceLoaded;
//Teads inFlow
@property (strong, nonatomic) TeadsInterstitial *teadsInterstitial;

@end

@implementation InFlowViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"inFlow";

    self.showInFlowButton.enabled = NO;
    self.activityIndicator.hidden = YES;
    
    //Your custom ad tracking status : the ad is not loaded yet
    self.adExperienceLoaded = NO;
    //Init the inFlow
    self.teadsInterstitial = [[TeadsInterstitial alloc] initInFlowWithPlacementId:@"27695" rootViewController:self delegate:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loadInterstitial:(id)sender {
    if (!self.adExperienceLoaded) {
        self.loadInFlowButton.enabled = NO;
        
        self.activityIndicator.hidden = NO;
        [self.activityIndicator startAnimating];
        [self.teadsInterstitial load];
    }
}

- (IBAction)showInterstitial:(id)sender {
    //inFlow is loaded ?
    if (self.adExperienceLoaded) {
        //We show it
        [self.teadsInterstitial show];
    }
}

#pragma mark -
#pragma mark - TeadsInterstitialDelegate mandatory delegate methods


// Mandatory: return the viewController that will be used for modal presentation
-(UIViewController *)viewControllerForModalPresentation:(TeadsInterstitial *)interstitial {
    return self;
}


#pragma mark - TeadsInterstitialDelegate optional delegate methods

/**
 * Interstitial Failed to Load
 *
 * @param interstitial  : the TeadsInterstitial object
 * @param error         : the EbzError object
 */
- (void)teadsInterstitial:(TeadsInterstitial *)interstitial didFailLoading:(TeadsError *)error {
    [self.activityIndicator stopAnimating];
    self.activityIndicator.hidden = YES;
    self.adExperienceLoaded = NO;
    
    self.showInFlowButton.enabled = NO;
    self.loadInFlowButton.enabled = YES;
}

/**
 * Interstitial Will Load (loading)
 *
 * @param interstitial  : the TeadsInterstitial object
 */
- (void)teadsInterstitialWillLoad:(TeadsInterstitial *)interstitial {
    
}

/**
 * Interstitial Did Load (loaded successfully)
 *
 * @param interstitial  : the TeadsInterstitial object
 */
- (void)teadsInterstitialDidLoad:(TeadsInterstitial *)interstitial {
    [self.activityIndicator stopAnimating];
    self.activityIndicator.hidden = YES;
    self.adExperienceLoaded = YES;
    
    self.showInFlowButton.enabled = YES;
    self.loadInFlowButton.enabled = NO;
}

/**
 * Interstitial Will Take Over Fullscreen (showing)
 *
 * @param interstitial  : the TeadsInterstitial object
 */
- (void)teadsInterstitialWillTakeOverFullScreen:(TeadsInterstitial *)interstitial {

}

/**
 * Interstitial Did Take Over Fullscreen (shown)
 *
 * @param interstitial  : the TeadsInterstitial object
 */
- (void)teadsInterstitialDidTakeOverFullScreen:(TeadsInterstitial *)interstitial {

}

/**
 * Interstitial Will Dismiss Fullscreen (closing)
 *
 * @param interstitial  : the TeadsInterstitial object
 */
- (void)teadsInterstitialWillDismissFullScreen:(TeadsInterstitial *)interstitial {

}

/**
 * Interstitial Did Dismiss Fullscreen (closed)
 *
 * @param interstitial The TeadsInterstitial object
 */
- (void)teadsInterstitialDidDismissFullScreen:(TeadsInterstitial *)interstitial {
    //inFlow has been dismissed : ad is not loaded anymore
    self.adExperienceLoaded = NO;
    self.activityIndicator.hidden = YES;
    self.showInFlowButton.enabled = NO;
    self.loadInFlowButton.enabled = YES;
}

@end
