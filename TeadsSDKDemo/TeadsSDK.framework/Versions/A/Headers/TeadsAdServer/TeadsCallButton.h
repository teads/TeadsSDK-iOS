//
//  TeadsCallButton.h
//  TeadsSDK
//
//  Created by Bastien Lefrant on 16/07/2015.
//  Copyright (c) 2015 Teads. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TeadsContentSettings.h"

@interface TeadsCallButton : NSObject <TeadsContentSettingsProtocol>

@property (nonatomic) BOOL display;
@property (nonatomic) int countdown;
@property (nonatomic, strong) NSString *text;

@end
