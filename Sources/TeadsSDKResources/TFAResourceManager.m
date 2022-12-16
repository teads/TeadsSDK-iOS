//
//  TFAResourceManager.m
//  TeadsSDK
//
//  Created by Paul Nicolas on 15/12/2022.
//

#import "TFAResourceManager.h"

@implementation TFAResourceManager

static NSURL *TFAResourceBundleURL;

+ (void)initialize
{
    [super initialize];
    
    TFAResourceBundleURL = [SWIFTPM_MODULE_BUNDLE URLForResource: @"TeadsSDKResources" withExtension: @"bundle"];

    return self;
}

+ (NSURL *)resourceBundleURL
{
    return TFAResourceBundleURL;
}

@end
