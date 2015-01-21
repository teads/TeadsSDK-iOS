//
//  InReadWebViewController.m
//  TeadsSDKDemo
//
//  Created by Nikolaï Roycourt on 16/01/2015.
//  Copyright (c) 2015 Teads. All rights reserved.
//

#import "InReadWebViewController.h"

@interface InReadWebViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (strong, nonatomic) TeadsNativeVideo *teadsInRead;
@property (assign, nonatomic) BOOL adExperienceLoaded;

@end

@implementation InReadWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView.delegate = self;
    
    self.adExperienceLoaded = NO;
    
    self.navigationItem.title = @"inRead WebView";
    
    //Load a web page from an URL
    NSURL *webSiteURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"] isDirectory:NO];
    [self.webView loadRequest:[NSURLRequest requestWithURL:webSiteURL]];
    
    // inRead
    self.teadsInRead = [[TeadsNativeVideo alloc] initInReadWithPlacementId:@"27695" placeholderText:@"#my-placement-id" webView:self.webView rootViewController:self delegate:self];
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
