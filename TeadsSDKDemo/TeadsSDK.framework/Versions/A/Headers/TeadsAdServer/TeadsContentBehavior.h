//
//  TeadsContentBehavior.h
//  TeadsSDK
//
//  Created by Bastien Lefrant on 16/07/2015.
//  Copyright (c) 2015 Teads. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TeadsContentSettings.h"

typedef enum {
    TeadsPlayerLaunchAuto,
    TeadsPlayerLaunchThreshold
}TeadsPlayerLaunchBehavior;

typedef enum {
    TeadsPlayerVideoStartAuto,
    TeadsPlayerVideoStartThreshold,
    TeadsPlayerVideoStartClick
}TeadsPlayerVideoStartBehavior;

typedef enum {
    TeadsPlayerSoundStartMute,
    TeadsPlayerSoundStartUnMute,
    TeadsPlayerSoundStartCountdown
}TeadsPlayerSoundStartType;

typedef struct {
    TeadsPlayerSoundStartType type;
    int countdown;
}TeadsPlayerSoundStartBehavior;

typedef enum {
    TeadsPlayerVideoPauseNo,
    TeadsPlayerVideoPauseThreshold
}TeadsPlayerVideoPauseBehavior;

typedef enum {
    TeadsPlayerSoundMuteNo,
    TeadsPlayerSoundMuteThreshold
}TeadsPlayerSoundMuteBehavior;

typedef enum {
    TeadsPlayerClickFullscreen,
    TeadsPlayerClickOpenURL
}TeadsPlayerClickBehavior;

typedef enum {
    TeadsPlayerEndCollapse,
    TeadsPlayerEndEndscreen,
}TeadsPlayerEndBehavior;

@interface TeadsContentBehavior : NSObject <TeadsContentSettingsProtocol>

@property (nonatomic) TeadsPlayerLaunchBehavior launch;
@property (nonatomic) TeadsPlayerVideoStartBehavior videoStart;
@property (nonatomic) TeadsPlayerSoundStartBehavior soundStart;
@property (nonatomic) TeadsPlayerVideoPauseBehavior videoPause;
@property (nonatomic) TeadsPlayerSoundMuteBehavior soundMute;
@property (nonatomic) TeadsPlayerClickBehavior playerClick;
@property (nonatomic) TeadsPlayerEndBehavior end;

@end