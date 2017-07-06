//
//  TeadsWkWebViewTableViewCell.h
//  TeadsSDKDemo
//
//  Created by Jérémy Grosjean on 03/05/2017.
//  Copyright © 2017 Teads. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import <TeadsSDK/TeadsSDK.h>

@interface TeadsWkWebViewTableViewCell : UITableViewCell

@property WKWebView *wkWebView;
@property TeadsAd *teadsAd;

@end
