//
//  TeadsContentValues.h
//  TeadsSDK
//
//  Created by Bastien Lefrant on 21/08/2015.
//  Copyright (c) 2015 Teads. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TeadsContentSettings.h"

typedef struct {
    double main;
    int fadeDuration;
}TeadsVolume;

typedef enum {
    TeadsFormatTypeInRead,
    TeadsFormatTypeInBoard,
    TeadsFormatTypeInFlow,
} TeadsFormatType;

@interface TeadsContentValues : NSObject <TeadsContentSettingsProtocol>

@property (nonatomic) int threshold;
@property (nonatomic) TeadsVolume volume;
@property (nonatomic) TeadsFormatType formatType;

@end
