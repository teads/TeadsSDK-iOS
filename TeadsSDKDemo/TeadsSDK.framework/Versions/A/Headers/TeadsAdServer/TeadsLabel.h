//
//  TeadsLabel.h
//  TeadsSDK
//
//  Created by Bastien Lefrant on 16/07/2015.
//  Copyright (c) 2015 Teads. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TeadsContentSettings.h"

@interface TeadsLabel : NSObject <TeadsContentSettingsProtocol>

@property (nonatomic) BOOL display;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *html;

@end
