//
//  InReadScrollViewController.h
//  TeadsSDKDemo
//
//  Created by Nikolaï Roycourt on 16/01/2015.
//  Copyright (c) 2015 Teads. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TeadsSDK/TeadsVideo.h>

@interface InReadScrollViewController : UIViewController <UIScrollViewDelegate, TeadsVideoDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) IBOutlet UIView *inReadView;

@end
