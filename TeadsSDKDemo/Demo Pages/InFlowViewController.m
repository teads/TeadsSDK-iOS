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

//Teads inFlow
@property (strong, nonatomic) TeadsInterstitial *teadsInterstitial;

@end

@implementation InFlowViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"inFlow";

    self.showInFlowButton.enabled = NO;
    self.activityIndicator.hidden = YES;
    
    NSString *pid = [[NSUserDefaults standardUserDefaults] stringForKey:@"pid"];
    //Init the inFlow
    self.teadsInterstitial = [[TeadsInterstitial alloc] initInFlowWithPlacementId:pid rootViewController:self delegate:self];
}

- (void)dealloc {
    [self.teadsInterstitial clean];
}

- (IBAction)loadInterstitial:(id)sender {
    if (!self.teadsInterstitial.isLoaded) {
        self.loadInFlowButton.enabled = NO;
        
        self.activityIndicator.hidden = NO;
        [self.activityIndicator startAnimating];
        [self.teadsInterstitial load];
    }
}

- (IBAction)showInterstitial:(id)sender {
    //inFlow is loaded ?
    if (self.teadsInterstitial.isLoaded) {
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
    self.activityIndicator.hidden = YES;
    self.showInFlowButton.enabled = NO;
    self.loadInFlowButton.enabled = YES;
}

/**
 * Interstitial Did Clean
 *
 * @param interstitial  : the TeadsInterstitial object
 */
- (void)teadsInterstitialDidClean:(TeadsInterstitial *)interstitial {
    
}

@end
