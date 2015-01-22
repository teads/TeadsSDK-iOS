//
//  ContentPageViewController.h
//  TeadsSDKDemo
//
//  Created by Nikolaï Roycourt on 19/01/2015.
//  Copyright (c) 2015 Teads. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContentPageViewController : UIViewController

@property (nonatomic, strong) IBOutlet UIPageControl *pageControl;
@property (assign, nonatomic) NSInteger index;

@property (strong, nonatomic) IBOutlet UILabel *viewLabel;
@property (nonatomic, strong) IBOutlet UIImageView *arrowLeft;
@property (nonatomic, strong) IBOutlet UIImageView *arrowRight;

@end
