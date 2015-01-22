//
//  ContentPageViewController.m
//  TeadsSDKDemo
//
//  Created by Nikolaï Roycourt on 19/01/2015.
//  Copyright (c) 2015 Teads. All rights reserved.
//

#import "ContentPageViewController.h"

@interface ContentPageViewController ()

@end

@implementation ContentPageViewController
@synthesize viewLabel, arrowLeft, arrowRight;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
    }
    
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.viewLabel.text = [NSString stringWithFormat:@"%ld", (long)self.index+1];
    if (self.index >= 2) {
        self.arrowRight.hidden = YES;
        self.arrowLeft.hidden = NO;
    } else {
        self.arrowRight.hidden = NO;
        self.arrowLeft.hidden = YES;
    }
    
    self.pageControl.currentPage = self.index;
}


@end
