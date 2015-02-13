//
//  AppDelegate.m
//  TeadsSDKDemo
//
//  Created by Nikolaï Roycourt on 15/01/2015.
//  Copyright (c) 2015 Teads. All rights reserved.
//

#import "AppDelegate.h"
#import <TeadsSDK/TeadsSDK.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [TeadsLog setLevelType:TeadsDebugLevelError];
    
    [TeadsAdFactory setDelegate:self];
    [TeadsAdFactory loadNativeVideoAdWithPid:@"27695"];
    
    // Set the debug level to verbose
    TeadsLogInfo(@"Framework has been set up correctly");
    
    // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - TeadsAdFactoryDelegate delegates

-(void)teadsAdType:(TeadsAdType)type withPid:(NSString *)pid didFailLoading:(TeadsError *)error {
    NSLog(@"Ad with pid %@ failed to load", pid);
    [TeadsAdFactory loadNativeVideoAdWithPid:@"27695"];
}

-(void)teadsAdType:(TeadsAdType)type willLoad:(NSString *)pid {
    
}

-(void)teadsAdType:(TeadsAdType)type didLoad:(NSString *)pid {
    NSLog(@"Ad with pid %@ did load", pid);
}

-(void)teadsAdType:(TeadsAdType)type wasConsumed:(NSString *)pid {
    NSLog(@"Ad with pid %@ was consumed", pid);
    [TeadsAdFactory loadNativeVideoAdWithPid:@"27695"];
}

- (void)teadsAdType:(TeadsAdType)type DidExpire:(NSString *)pid {
    NSLog(@"Ad with pid %@ expired", pid);
    [TeadsAdFactory loadNativeVideoAdWithPid:@"27695"];
}

@end
