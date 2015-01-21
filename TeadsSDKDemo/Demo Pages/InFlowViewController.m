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

//Your boolean : will be used to track load status of the ad
@property (assign, nonatomic) BOOL teadsInterstitialIsLoaded;

@end

@implementation InFlowViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"inFlow";

    self.showInFlowButton.enabled = NO;
    
    self.teadsInterstitialIsLoaded = NO;
    //Init the inFlow
    self.teadsInterstitial = [[TeadsInterstitial alloc] initInFlowWithPlacementId:@"27695" rootViewController:self delegate:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loadInterstitial:(id)sender {
    if (!self.teadsInterstitialIsLoaded) {
        self.loadInFlowButton.enabled = NO;
        
        [self.activityIndicator startAnimating];
        [self.teadsInterstitial load];
    }
}

- (IBAction)showInterstitial:(id)sender {
    //inFlow is loaded ?
    if (self.teadsInterstitialIsLoaded) {
        //We show it
        [self.teadsInterstitial show];
    }
}

#pragma mark - TeadsInterstitialDelegate mandatory delegate methods


// Mandatory: return the viewController that will be used for modal presentation
-(UIViewController *)viewControllerForModalPresentation:(TeadsInterstitial *)interstitial {
    return self;
}


#pragma mark - TeadsInterstitialDelegate optional delegate methods

// Interstitial Failed to Load
- (void)teadsInterstitial:(TeadsInterstitial *)interstitial didFailLoading:(TeadsError *)error {
    [self.activityIndicator stopAnimating];
    
    self.teadsInterstitialIsLoaded = NO;
    
    self.loadInFlowButton.enabled = YES;
}

// Interstitial Will Load (loading)
- (void)teadsInterstitialWillLoad:(TeadsInterstitial *)interstitial {

}

// Interstitial Did Load (loaded successfully)
- (void)teadsInterstitialDidLoad:(TeadsInterstitial *)interstitial {
    [self.activityIndicator stopAnimating];
    //Boolean to keep track of load status
    self.teadsInterstitialIsLoaded = YES;
    
    self.showInFlowButton.enabled = YES;
    
}

// Interstitial Will Take Over Fullscreen (showing)
- (void)teadsInterstitialWillTakeOverFullScreen:(TeadsInterstitial *)interstitial {
    
}

// Interstitial Did Take Over Fullscreen (shown)
- (void)teadsInterstitialDidTakeOverFullScreen:(TeadsInterstitial *)interstitial {
    
}

// Interstitial Will Dismiss Fullscreen (closing)
- (void)teadsInterstitialWillDismissFullScreen:(TeadsInterstitial *)interstitial {
}

// Interstitial Did Dismiss Fullscreen (closed)
- (void)teadsInterstitialDidDismissFullScreen:(TeadsInterstitial *)interstitial {
    //inFlow has been dismissed : ad is not loaded anymore
    self.teadsInterstitialIsLoaded = NO;
    
    self.showInFlowButton.enabled = NO;
    self.loadInFlowButton.enabled = YES;
}

// Interstitial Unlocked Reward
- (void)teadsInterstitialRewardUnlocked:(TeadsInterstitial *)interstitial {
    
}

@end
