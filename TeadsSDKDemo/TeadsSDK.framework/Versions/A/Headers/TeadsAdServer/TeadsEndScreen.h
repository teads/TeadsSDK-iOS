//
//  TeadsEndScreen.h
//  TeadsSDK
//
//  Created by Bastien Lefrant on 16/07/2015.
//  Copyright (c) 2015 Teads. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TeadsContentSettings.h"

typedef enum {
    TeadsEndScreenCallButtonLearnMore,
    TeadsEndScreenCallButtonDownload,
    TeadsEndScreenCallButtonShopNow,
    TeadsEndScreenCallButtonWatchMore,
    TeadsEndScreenCallButtonContactUs,
    TeadsEndScreenCallButtonSubscribe,
    TeadsEndScreenCallButtonBookNow
}TeadsEndScreenCallButtonType;

typedef enum {
    TeadsEndScreenSimple
}TeadsEndscreenType;

@interface TeadsEndScreen : NSObject <TeadsContentSettingsProtocol>

@property (nonatomic, strong) NSString *replayButtonText;
@property (nonatomic, strong) NSString *callButtonText;
@property (nonatomic) TeadsEndScreenCallButtonType callButtonType;
@property (nonatomic) BOOL autoclose;
@property (nonatomic) int countdown;
@property (nonatomic) TeadsEndscreenType type;

@end
