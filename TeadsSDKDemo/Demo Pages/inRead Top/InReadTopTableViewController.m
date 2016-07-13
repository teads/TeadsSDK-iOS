//
//  InReadTopTableViewController.m
//  TeadsSDKDemo
//
//  Created by Nikolaï Roycourt on 16/01/2015.
//  Copyright (c) 2015 Teads. All rights reserved.
//

#import "InReadTopTableViewController.h"

@interface InReadTopTableViewController ()

@property (nonatomic, strong) TeadsAd *teadsAd;

@end

@implementation InReadTopTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"inRead Top TableView";
    
    NSString *pid = [[NSUserDefaults standardUserDefaults] stringForKey:@"pid"];
    
    self.teadsAd = [[TeadsAd alloc] initInReadTopWithPlacementId:pid scrollView:self.tableView delegate:self];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.teadsAd.isLoaded) {
        [self.teadsAd viewControllerAppeared:self];
        
    } else {
        [self.teadsAd load];
    }
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.teadsAd viewControllerDisappeared:self];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 20;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *TeadsTextCellIdentifier = @"TeadsFirstCell";
    static NSString *CellIdentifier = @"TeadsGrayedCell";
    
    if (indexPath.row == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TeadsTextCellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TeadsTextCellIdentifier];
        }
        
        return cell;
        
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90.0;
}

#pragma mark -
#pragma mark - TeadsAdDelegate

/**
 * NativeVideo Failed to Load
 *
 * @param interstitial  : the TeadsAd object
 * @param error         : the TeadsError object
 */
- (void)teadsAd:(TeadsAd *)nativeVideo didFailLoading:(TeadsError *)error {
    
}

/**
 * NativeVideo Will Load (loading)
 *
 * @param interstitial  : the TeadsAd object
 */
- (void)teadsAdWillLoad:(TeadsAd *)nativeVideo {
    
}

/**
 * NativeVideo Did Load (loaded successfully)
 *
 * @param interstitial  : the TeadsAd object
 */
- (void)teadsAdDidLoad:(TeadsAd *)nativeVideo {
    
}

/**
 * NativeVideo Will Start Playing (loading)
 *
 * @param nativeVideo  : the TeadsAd object
 */
- (void)teadsAdWillStart:(TeadsAd *)nativeVideo {
    
}

/**
 * NativeVideo Did Start Playing (playing)
 *
 * @param nativeVideo  : the TeadsAd object
 */
- (void)teadsAdDidStart:(TeadsAd *)nativeVideo {
    
}

/**
 * NativeVideo Will Stop Playing (stopping)
 *
 * @param nativeVideo  : the TeadsAd object
 */
- (void)teadsAdWillStop:(TeadsAd *)nativeVideo {
    
}

/**
 * NativeVideo Did Stop Playing (stopped)
 *
 * @param nativeVideo  : the TeadsAd object
 */
- (void)teadsAdDidStop:(TeadsAd *)nativeVideo {
    
}

/**
 * NativeVideo Did Pause (paused)
 *
 * @param nativeVideo  : the TeadsAd object
 */
- (void)teadsAdDidPause:(TeadsAd *)nativeVideo {
    
}

/**
 * NativeVideo Did Resume (playing)
 *
 * @param nativeVideo  : the TeadsAd object
 */
- (void)teadsAdDidResume:(TeadsAd *)nativeVideo {
    
}

/**
 * NativeVideo Did Mute Sound
 *
 * @param nativeVideo  : the TeadsAd object
 */
- (void)teadsAdDidMute:(TeadsAd *)nativeVideo {
    
}

/**
 * NativeVideo Did Unmute Sound
 *
 * @param nativeVideo  : the TeadsAd object
 */
- (void)teadsAdDidUnmute:(TeadsAd *)nativeVideo {
    
}

/**
 * NativeVideo Will expand
 *
 * @param nativeVideo  : the TeadsAd object
 */
- (void)teadsAdDidExpand:(TeadsAd *)video {
    
}

/**
 * NativeVideo Will collapse
 *
 * @param nativeVideo  : the TeadsAd object
 */
- (void)teadsAdWillCollapse:(TeadsAd *)video {
    
}

/**
 * NativeVideo did collapse
 *
 * @param nativeVideo  : the TeadsAd object
 */
- (void)teadsAdDidCollapse:(TeadsAd *)video {
    
}

/**
 * NativeVideo was clicked
 *
 * @param nativeVideo  : the TeadsAd object
 */
- (void)teadsAdWasClicked:(TeadsAd *)nativeVideo {
    
}

/**
 * NativeVideo Did Stop Playing (stopped)
 *
 * @param nativeVideo  : the TeadsAd object
 */
- (void)teadsAdDidClickBrowserClose:(TeadsAd *)nativeVideo {
    
}

/**
 * NativeVideo Will Take Over Fullscreen
 *
 * @param nativeVideo  : the TeadsAd object
 */
- (void)teadsAdWillTakeOverFullScreen:(TeadsAd *)nativeVideo {
    
}

/**
 * NativeVideo Did Take Over Fullscreen
 *
 * @param nativeVideo  : the TeadsAd object
 */
- (void)teadsAdDidTakeOverFullScreen:(TeadsAd *)nativeVideo {
    
}

/**
 * NativeVideo Will Dismiss Fullscreen
 *
 * @param nativeVideo  : the TeadsAd object
 */
- (void)teadsAdWillDismissFullscreen:(TeadsAd *)nativeVideo {
    
}

/**
 * NativeVideo Did Dismiss Fullscreen
 *
 * @param nativeVideo  : the TeadsAd object
 */
- (void)teadsAdDidDismissFullscreen:(TeadsAd *)nativeVideo {
    
}

/**
 * NativeVideo Skip Button Was Tapped (skip button pressed)
 *
 * @param nativeVideo  : the TeadsAd object
 */
- (void)teadsAdSkipButtonTapped:(TeadsAd *)nativeVideo {
    
}

/**
 * NativeVideo Skip Button Did Show (skip button appeared)
 *
 * @param nativeVideo  : the TeadsAd object
 */
- (void)teadsAdSkipButtonDidShow:(TeadsAd *)nativeVideo {
    
}

/**
 * NativeVideo did clean (all related resoures have been removed)
 *
 * @param nativeVideo  : the TeadsAd object
 */
- (void)teadsAdDidClean:(TeadsAd *)nativeVideo {
    
}

@end
