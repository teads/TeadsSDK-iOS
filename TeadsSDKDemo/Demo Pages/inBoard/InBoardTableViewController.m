//
//  InBoardTableViewController.m
//  TeadsSDKDemo
//
//  Created by Nikolaï Roycourt on 16/01/2015.
//  Copyright (c) 2015 Teads. All rights reserved.
//

#import "InBoardTableViewController.h"

@interface InBoardTableViewController ()

@property (nonatomic, strong) TeadsNativeVideo *teadsinBoard;

@end

@implementation InBoardTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"inBoard TableView";
    
    self.teadsinBoard = [[TeadsNativeVideo alloc] initInBoardWithPlacementId:@"27695" tableView:self.tableView rootViewController:self delegate:self];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.teadsinBoard.isLoaded) {
        [self.teadsinBoard viewControllerAppeared:self];
        
    } else {
        [self.teadsinBoard loadFromFactory];
    }
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.teadsinBoard viewControllerDisappeared:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    [self.teadsinBoard clean];
}

-(void)dealloc {
    [self.teadsinBoard clean];
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
#pragma mark - TeadsNativeVideoDelegate

/**
 * NativeVideo Failed to Load
 *
 * @param interstitial  : the TeadsNativeVideo object
 * @param error         : the TeadsError object
 */
- (void)teadsNativeVideo:(TeadsNativeVideo *)nativeVideo didFailLoading:(TeadsError *)error {

}

/**
 * NativeVideo Will Load (loading)
 *
 * @param interstitial  : the TeadsNativeVideo object
 */
- (void)teadsNativeVideoWillLoad:(TeadsNativeVideo *)nativeVideo {
    
}

/**
 * NativeVideo Did Load (loaded successfully)
 *
 * @param interstitial  : the TeadsNativeVideo object
 */
- (void)teadsNativeVideoDidLoad:(TeadsNativeVideo *)nativeVideo {

}

/**
 * NativeVideo Will Start Playing (loading)
 *
 * @param nativeVideo  : the TeadsNativeVideo object
 */
- (void)teadsNativeVideoWillStart:(TeadsNativeVideo *)nativeVideo {
    
}

/**
 * NativeVideo Did Start Playing (playing)
 *
 * @param nativeVideo  : the TeadsNativeVideo object
 */
- (void)teadsNativeVideoDidStart:(TeadsNativeVideo *)nativeVideo {
    
}

/**
 * NativeVideo Will Stop Playing (stopping)
 *
 * @param nativeVideo  : the TeadsNativeVideo object
 */
- (void)teadsNativeVideoWillStop:(TeadsNativeVideo *)nativeVideo {
    
}

/**
 * NativeVideo Did Stop Playing (stopped)
 *
 * @param nativeVideo  : the TeadsNativeVideo object
 */
- (void)teadsNativeVideoDidStop:(TeadsNativeVideo *)nativeVideo {
    
}

/**
 * NativeVideo Did Pause (paused)
 *
 * @param nativeVideo  : the TeadsNativeVideo object
 */
- (void)teadsNativeVideoDidPause:(TeadsNativeVideo *)nativeVideo {
    
}

/**
 * NativeVideo Did Resume (playing)
 *
 * @param nativeVideo  : the TeadsNativeVideo object
 */
- (void)teadsNativeVideoDidResume:(TeadsNativeVideo *)nativeVideo {
    
}

/**
 * NativeVideo Did Mute Sound
 *
 * @param nativeVideo  : the TeadsNativeVideo object
 */
- (void)teadsNativeVideoDidMute:(TeadsNativeVideo *)nativeVideo {
    
}

/**
 * NativeVideo Did Unmute Sound
 *
 * @param nativeVideo  : the TeadsNativeVideo object
 */
- (void)teadsNativeVideoDidUnmute:(TeadsNativeVideo *)nativeVideo {
    
}

/**
 * NativeVideo Will expand
 *
 * @param nativeVideo  : the TeadsNativeVideo object
 */
- (void)teadsNativeVideoWillExpand:(TeadsNativeVideo *)nativeVideo {
    
}

/**
 * NativeVideo Did expand
 *
 * @param nativeVideo  : the TeadsNativeVideo object
 */
- (void)teadsNativeVideoDidExpand:(TeadsNativeVideo *)nativeVideo {
    
}

/**
 * NativeVideo Will collapse
 *
 * @param nativeVideo  : the TeadsNativeVideo object
 */
- (void)teadsNativeVideoWillCollapse:(TeadsNativeVideo *)nativeVideo {
    
}

/**
 * NativeVideo did collapse
 *
 * @param nativeVideo  : the TeadsNativeVideo object
 */
- (void)teadsNativeVideoDidCollapse:(TeadsNativeVideo *)nativeVideo {

}

/**
 * NativeVideo was clicked
 *
 * @param nativeVideo  : the TeadsNativeVideo object
 */
- (void)teadsNativeVideoWasClicked:(TeadsNativeVideo *)nativeVideo {
    
}

/**
 * NativeVideo Did Stop Playing (stopped)
 *
 * @param nativeVideo  : the TeadsNativeVideo object
 */
- (void)teadsNativeVideoDidClickBrowserClose:(TeadsNativeVideo *)nativeVideo {
    
}

/**
 * NativeVideo Will Take Over Fullscreen
 *
 * @param nativeVideo  : the TeadsNativeVideo object
 */
- (void)teadsNativeVideoWillTakeOverFullScreen:(TeadsNativeVideo *)nativeVideo {
    
}

/**
 * NativeVideo Did Take Over Fullscreen
 *
 * @param nativeVideo  : the TeadsNativeVideo object
 */
- (void)teadsNativeVideoDidTakeOverFullScreen:(TeadsNativeVideo *)nativeVideo {
    
}

/**
 * NativeVideo Will Dismiss Fullscreen
 *
 * @param nativeVideo  : the TeadsNativeVideo object
 */
- (void)teadsNativeVideoWillDismissFullscreen:(TeadsNativeVideo *)nativeVideo {
    
}

/**
 * NativeVideo Did Dismiss Fullscreen
 *
 * @param nativeVideo  : the TeadsNativeVideo object
 */
- (void)teadsNativeVideoDidDismissFullscreen:(TeadsNativeVideo *)nativeVideo {
    
}

/**
 * NativeVideo Skip Button Was Tapped (skip button pressed)
 *
 * @param nativeVideo  : the TeadsNativeVideo object
 */
- (void)teadsNativeVideoSkipButtonTapped:(TeadsNativeVideo *)nativeVideo {
    
}

/**
 * NativeVideo Skip Button Did Show (skip button appeared)
 *
 * @param nativeVideo  : the TeadsNativeVideo object
 */
- (void)teadsNativeVideoSkipButtonDidShow:(TeadsNativeVideo *)nativeVideo {
    
}

/**
 * NativeVideo did clean (all related resoures have been removed)
 *
 * @param nativeVideo  : the TeadsNativeVideo object
 */
- (void)teadsNativeVideoDidClean:(TeadsNativeVideo *)nativeVideo {
    
}

@end
