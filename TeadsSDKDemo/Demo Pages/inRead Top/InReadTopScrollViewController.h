//
//  InReadTopScrollViewController.h
//  TeadsSDKDemo
//
//  Created by Nikolaï Roycourt on 16/01/2015.
//  Copyright (c) 2015 Teads. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TeadsSDK/TeadsSDK.h>

@interface InReadTopScrollViewController : UIViewController <UIScrollViewDelegate, TeadsAdDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@end
