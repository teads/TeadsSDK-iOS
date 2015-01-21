//
//  InReadScrollViewController.m
//  TeadsSDKDemo
//
//  Created by Nikolaï Roycourt on 16/01/2015.
//  Copyright (c) 2015 Teads. All rights reserved.
//

#import "InReadScrollViewController.h"

@interface InReadScrollViewController ()

@property (strong, nonatomic) TeadsNativeVideo *teadsInRead;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *inReadConstraint;

@property (assign, nonatomic) BOOL adExperienceLoaded;

@end

@implementation InReadScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.scrollView.delegate = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.navigationItem.title = @"inRead ScrollView";
    
    self.adExperienceLoaded = NO;
    self.teadsInRead = [[TeadsNativeVideo alloc] initInReadWithPlacementId:@"27675" placeholder:self.inReadView heightConstraint:self.inReadConstraint scrollView:self.scrollView rootViewController:self delegate:self];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.adExperienceLoaded) {
        [self.teadsInRead viewControllerAppeared:self];
    } else {
        [self.teadsInRead load];
    }
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    if (self.adExperienceLoaded) {
        [self.teadsInRead viewControllerDisappeared:self];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [self.teadsInRead clean];
}

#pragma mark - TeadsNativeVideoDelegate

- (void)teadsNativeVideoDidLoad:(TeadsNativeVideo *)nativeVideo {
    self.adExperienceLoaded = YES;
}

- (void)teadsNativeVideoDidDismiss:(TeadsNativeVideo *)nativeVideo {
    
}

- (void)teadsNativeVideoDidStart:(TeadsNativeVideo *)nativeVideo {
    
}

- (void)teadsNativeVideoDidStop:(TeadsNativeVideo *)nativeVideo {
}

- (void)teadsNativeVideoDidPause:(TeadsNativeVideo *)nativeVideo {
    
}

- (void)teadsNativeVideoDidResume:(TeadsNativeVideo *)nativeVideo {
    
}

- (void)teadsNativeVideoDidCollapse:(TeadsNativeVideo *)nativeVideo {
    self.adExperienceLoaded = NO;
}

@end
