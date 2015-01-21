//
//  InBoardScrollViewController.h
//  TeadsSDKDemo
//
//  Created by Nikolaï Roycourt on 16/01/2015.
//  Copyright (c) 2015 Teads. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TeadsSDK/TeadsNativeVideo.h>

@interface InBoardScrollViewController : UIViewController <UIScrollViewDelegate, TeadsNativeVideoDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) IBOutlet UIView *inBoardView;

@end
