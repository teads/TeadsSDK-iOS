//
//  TeadsWkWebViewTableViewCell.m
//  TeadsSDKDemo
//
//  Created by Jérémy Grosjean on 03/05/2017.
//  Copyright © 2017 Teads. All rights reserved.
//

#import "TeadsWkWebViewTableViewCell.h"

@implementation TeadsWkWebViewTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    WKWebViewConfiguration *theConfiguration = [[WKWebViewConfiguration alloc] init];
    self.wkWebView = [[WKWebView alloc] initWithFrame:self.frame configuration:theConfiguration];
    self.wkWebView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.wkWebView];
    
    self.wkWebView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
