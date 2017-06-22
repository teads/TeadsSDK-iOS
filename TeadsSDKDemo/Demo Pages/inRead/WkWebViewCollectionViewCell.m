//
//  WkWebViewCollectionViewCell.m
//  TeadsSDKDemo
//
//  Created by Jérémy Grosjean on 04/05/2017.
//  Copyright © 2017 Teads. All rights reserved.
//

#import "WkWebViewCollectionViewCell.h"

@implementation WkWebViewCollectionViewCell

- (void) addWkWebView {
    if (!self.wkWebView){
        WKWebViewConfiguration *theConfiguration = [[WKWebViewConfiguration alloc] init];
        self.wkWebView = [[WKWebView alloc]initWithFrame:self.bounds configuration:theConfiguration];
        self.wkWebView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:self.wkWebView];
    }
}

- (void) dealloc {
    @try{
        [self.wkWebView.scrollView removeObserver:self.controller  forKeyPath:@"contentSize"];
    }@catch(id anException){
        //do nothing, obviously it wasn't attached because an exception was thrown
    }
}

@end
