//
//  TeadsContentComponents.h
//  TeadsSDK
//
//  Created by Bastien Lefrant on 21/08/2015.
//  Copyright (c) 2015 Teads. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TeadsCloseButton.h"
#import "TeadsSoundButton.h"
#import "TeadsCallButton.h"
#import "TeadsLabel.h"
#import "TeadsCredits.h"
#import "TeadsEndScreen.h"

@interface TeadsContentComponents : NSObject <TeadsContentSettingsProtocol>

@property (nonatomic, strong) TeadsCloseButton *closeButton;
@property (nonatomic, strong) TeadsSoundButton *soundButton;
@property (nonatomic, strong) TeadsCallButton *callButton;
@property (nonatomic, strong) TeadsLabel *label;
@property (nonatomic, strong) TeadsCredits *credits;
@property (nonatomic, strong) TeadsEndScreen *endScreen;
@property (nonatomic) BOOL timer;
@property (nonatomic) BOOL progressBar;

@end
