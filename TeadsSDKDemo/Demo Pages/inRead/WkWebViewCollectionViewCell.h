//
//  WkWebViewCollectionViewCell.h
//  TeadsSDKDemo
//
//  Created by Jérémy Grosjean on 04/05/2017.
//  Copyright © 2017 Teads. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import <TeadsSDK/TeadsSDK.h>

@interface WkWebViewCollectionViewCell : UICollectionViewCell
@property WKWebView *wkWebView;
@property TeadsAd *teadsAd;
@property UIViewController *controller;
- (void) addWkWebView;
@end
