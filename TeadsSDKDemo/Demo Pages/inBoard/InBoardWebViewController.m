//
//  InBoardWebViewController.m
//  TeadsSDKDemo
//
//  Created by Nikolaï Roycourt on 16/01/2015.
//  Copyright (c) 2015 Teads. All rights reserved.
//

#import "InBoardWebViewController.h"
#import <TeadsSDK/TeadsSDK.h>

@interface InBoardWebViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (strong, nonatomic) TeadsNativeVideo *teadsInBoard;
@property (assign, nonatomic) BOOL adExperienceLoaded;

@end

@implementation InBoardWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"inBoard WebView";
    
    self.webView.delegate = self;
    
    NSURL *webSiteURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"] isDirectory:NO];
    [self.webView loadRequest:[NSURLRequest requestWithURL:webSiteURL]];
    
    self.adExperienceLoaded = NO;
    // inRead
    self.teadsInBoard = [[TeadsNativeVideo alloc] initInBoardWithPlacementId:@"27675" webView:self.webView rootViewController:self delegate:self];
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

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
}

#pragma mark - TeadsNativeVideoDelegate

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

-(void)teadsNativeVideoDidCollapse:(TeadsNativeVideo *)nativeVideo {
    self.adExperienceLoaded = NO;
}

@end
