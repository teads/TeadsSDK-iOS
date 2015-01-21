//
//  TeadsNativeBannerCell.h
//  TeadsSDK
//
//  Created by Ibrahim Ennafaa on 18/12/2014.
//  Copyright (c) 2014 Teads. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TeadsNativeBannerCellDelegate <NSObject>

@required

- (void)setTitle:(NSString *)title;
- (void)setCallback:(void (^)(void))callback;

@optional

- (void)setLogo:(UIImage *)image;
- (void)setImage:(UIImage *)image;
- (void)setText:(NSString *)text;

@end

