//
//  WebViewCollectionViewCell.h
//  TeadsSDKDemo
//
//  Created by Jérémy Grosjean on 04/05/2017.
//  Copyright © 2017 Teads. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewCollectionViewCell : UICollectionViewCell

@property UIWebView *webView;
- (void) addWebView;
@end
