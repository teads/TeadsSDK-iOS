//
//  CustomCollectionViewCell.m
//  TeadsSDKDemo
//
//  Created by Nikolaï Roycourt on 15/11/2016.
//  Copyright © 2016 Teads. All rights reserved.
//

#import "CustomCollectionViewCell.h"


@implementation CustomCollectionViewCell

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self.layer setShadowOffset:CGSizeMake(0.0, 1.0)];
        [self.layer setShadowColor:[[UIColor blackColor] CGColor]];
        [self.layer setShadowRadius:8.0];
        [self.layer setShadowOpacity:0.5];
        [self.layer setMasksToBounds:NO];
    }
    return self;
}

@end
