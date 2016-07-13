//
//  InReadTableViewController.m
//  TeadsSDKDemo
//
//  Created by Nikolaï Roycourt on 16/01/2015.
//  Copyright (c) 2015 Teads. All rights reserved.
//

#import "InReadTableViewController.h"

@interface InReadTableViewController ()

@property (nonatomic, strong) TeadsAd *teadsInRead;

@end

@implementation InReadTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"inRead TableView";
    
    NSInteger rowToDisplayInRead = 11;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        rowToDisplayInRead = 13;
    }
    
    //Create an NSIndexPath, it will be used to place the ad in the table view
    NSIndexPath *pathForTeadsInRead = [NSIndexPath indexPathForRow:rowToDisplayInRead inSection:0];
    
    NSString *pid = [[NSUserDefaults standardUserDefaults] stringForKey:@"pid"];
    //Create the teadsInRead with a PLACEMENT_ID, an IndexPath, a tableView, a rootViewController and a delegate
    self.teadsInRead = [[TeadsAd alloc] initInReadWithPlacementId:pid insertionIndexPath:pathForTeadsInRead tableView:self.tableView delegate:self];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.teadsInRead.isLoaded) {
        [self.teadsInRead viewControllerAppeared:self];
        
    } else {
        [self.teadsInRead load];
    }
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.teadsInRead viewControllerDisappeared:self];
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

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark - TeadsAdDelegate

/**
 * NativeVideo Failed to Load
 *
 * @param interstitial  : the TeadsAd object
 * @param error         : the TeadsError object
 */
- (void)teadsAd:(TeadsAd *)video didFailLoading:(TeadsError *)error {
    
}

/**
 * NativeVideo Will Load (loading)
 *
 * @param interstitial  : the TeadsAd object
 */
- (void)teadsAdWillLoad:(TeadsAd *)video {
    
}

/**
 * NativeVideo Did Load (loaded successfully)
 *
 * @param interstitial  : the TeadsAd object
 */
- (void)teadsAdDidLoad:(TeadsAd *)video {
    
}

/**
 * NativeVideo Will Start Playing (loading)
 *
 * @param nativeVideo  : the TeadsAd object
 */
- (void)teadsAdWillStart:(TeadsAd *)video {
    
}

/**
 * NativeVideo Did Start Playing (playing)
 *
 * @param nativeVideo  : the TeadsAd object
 */
- (void)teadsAdDidStart:(TeadsAd *)video {
    
}

/**
 * NativeVideo Will Stop Playing (stopping)
 *
 * @param nativeVideo  : the TeadsAd object
 */
- (void)teadsAdWillStop:(TeadsAd *)video {
    
}

/**
 * NativeVideo Did Stop Playing (stopped)
 *
 * @param nativeVideo  : the TeadsAd object
 */
- (void)teadsAdDidStop:(TeadsAd *)video {
    
}

/**
 * NativeVideo Did Pause (paused)
 *
 * @param nativeVideo  : the TeadsAd object
 */
- (void)teadsAdDidPause:(TeadsAd *)video {
    
}

/**
 * NativeVideo Did Resume (playing)
 *
 * @param nativeVideo  : the TeadsAd object
 */
- (void)teadsAdDidResume:(TeadsAd *)video {
    
}

/**
 * NativeVideo Did Mute Sound
 *
 * @param nativeVideo  : the TeadsAd object
 */
- (void)teadsAdDidMute:(TeadsAd *)video {
    
}

/**
 * NativeVideo Did Unmute Sound
 *
 * @param nativeVideo  : the TeadsAd object
 */
- (void)teadsAdDidUnmute:(TeadsAd *)video {
    
}

/**
 * NativeVideo Will expand
 *
 * @param nativeVideo  : the TeadsAd object
 */
- (void)teadsAdWillExpand:(TeadsAd *)video {
    
}

/**
 * NativeVideo Did expand
 *
 * @param nativeVideo  : the TeadsAd object
 */
-(void)teadsAdDidExpand:(TeadsAd *)video {
    
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
- (void)teadsAdWasClicked:(TeadsAd *)video {
    
}

/**
 * NativeVideo Did Stop Playing (stopped)
 *
 * @param nativeVideo  : the TeadsAd object
 */
- (void)teadsAdDidClickBrowserClose:(TeadsAd *)video {
    
}

/**
 * NativeVideo Will Take Over Fullscreen
 *
 * @param nativeVideo  : the TeadsAd object
 */
- (void)teadsAdWillTakeOverFullScreen:(TeadsAd *)video {
    
}

/**
 * NativeVideo Did Take Over Fullscreen
 *
 * @param nativeVideo  : the TeadsAd object
 */
- (void)teadsAdDidTakeOverFullScreen:(TeadsAd *)video {
    
}

/**
 * NativeVideo Will Dismiss Fullscreen
 *
 * @param nativeVideo  : the TeadsAd object
 */
- (void)teadsAdWillDismissFullscreen:(TeadsAd *)video {
    
}

/**
 * NativeVideo Did Dismiss Fullscreen
 *
 * @param nativeVideo  : the TeadsAd object
 */
- (void)teadsAdDidDismissFullscreen:(TeadsAd *)video {
    
}

/**
 * NativeVideo Skip Button Was Tapped (skip button pressed)
 *
 * @param nativeVideo  : the TeadsAd object
 */
- (void)teadsAdSkipButtonTapped:(TeadsAd *)video {
    
}

/**
 * NativeVideo Skip Button Did Show (skip button appeared)
 *
 * @param nativeVideo  : the TeadsAd object
 */
- (void)teadsAdSkipButtonDidShow:(TeadsAd *)video {
    
}

/**
 * NativeVideo did clean (all related resoures have been removed)
 *
 * @param nativeVideo  : the TeadsAd object
 */
- (void)teadsAdDidClean:(TeadsAd *)video {
    
}

@end
