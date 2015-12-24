//
//  TeadsCredits.h
//  TeadsSDK
//
//  Created by Bastien Lefrant on 16/07/2015.
//  Copyright (c) 2015 Teads. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TeadsContentSettings.h"
#import "TeadsContentValues.h"

@interface TeadsCredits : NSObject <TeadsContentSettingsProtocol>

@property (nonatomic) BOOL display;
@property (nonatomic, retain) NSString *text;
@property (nonatomic, retain) NSURL *link;

-(void)setDefaultValuesIfNecessary:(TeadsFormatType)formatType;

@end
