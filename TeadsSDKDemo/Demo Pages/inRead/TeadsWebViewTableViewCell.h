//
//  TeadsWebViewTableViewCell.h
//  TeadsSDKDemo
//
//  Created by Jérémy Grosjean on 03/05/2017.
//  Copyright © 2017 Teads. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TeadsSDK/TeadsSDK.h>

@interface TeadsWebViewTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property TeadsAd *teadsAd;
@end
