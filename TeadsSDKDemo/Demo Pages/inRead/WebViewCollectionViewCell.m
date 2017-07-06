//
//  WebViewCollectionViewCell.m
//  TeadsSDKDemo
//
//  Created by Jérémy Grosjean on 04/05/2017.
//  Copyright © 2017 Teads. All rights reserved.
//

#import "WebViewCollectionViewCell.h"

@implementation WebViewCollectionViewCell

- (void) addWebView {
    if (!self.webView){
        self.webView = [[UIWebView alloc]initWithFrame:self.bounds];
        self.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:self.webView];
    }
}

@end
