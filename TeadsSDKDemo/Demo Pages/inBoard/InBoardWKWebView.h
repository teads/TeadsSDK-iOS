//
//  inBoardWKWebView.h
//  TeadsSDKDemo
//
//  Created by Nikolaï Roycourt on 17/12/2015.
//  Copyright © 2015 Teads. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import <TeadsSDK/TeadsVideo.h>

@interface InBoardWKWebView : UIViewController  <WKNavigationDelegate, UIScrollViewDelegate, TeadsVideoDelegate>

@end
