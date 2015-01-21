//
//  InBoardScrollViewController.m
//  TeadsSDKDemo
//
//  Created by Nikolaï Roycourt on 16/01/2015.
//  Copyright (c) 2015 Teads. All rights reserved.
//

#import "InBoardScrollViewController.h"

@interface InBoardScrollViewController ()

@property (strong, nonatomic) TeadsNativeVideo *teadsInBoard;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *inBoardConstraint;

@property (assign, nonatomic) BOOL adExperienceLoaded;

@end

@implementation InBoardScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.scrollView.delegate = self;
    self.automaticallyAdjustsScrollViewInsets = NO; 
    
    self.navigationItem.title = @"inBoard ScrollView";
    
    self.adExperienceLoaded = NO;
    self.teadsInBoard = [[TeadsNativeVideo alloc] initInReadWithPlacementId:@"27695" placeholder:self.inBoardView heightConstraint:self.inBoardConstraint scrollView:self.scrollView rootViewController:self delegate:self];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.adExperienceLoaded) {
        [self.teadsInBoard viewControllerAppeared:self];
    } else {
        [self.teadsInBoard load];
    }
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    if (self.adExperienceLoaded) {
        [self.teadsInBoard viewControllerDisappeared:self];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [self.teadsInBoard clean];
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
