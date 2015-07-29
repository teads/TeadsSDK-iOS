//
//  InReadTableViewController.m
//  TeadsSDKDemo
//
//  Created by Nikolaï Roycourt on 16/01/2015.
//  Copyright (c) 2015 Teads. All rights reserved.
//

#import "InReadTableViewController.h"

@interface InReadTableViewController ()

@property (nonatomic, strong) TeadsNativeVideo *teadsInRead;

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
    
    //Create the teadsInRead with a PLACEMENT_ID, an IndexPath, a tableView, a rootViewController and a delegate
    self.teadsInRead = [[TeadsNativeVideo alloc] initInReadWithPlacementId:@"27695" insertionIndexPath:pathForTeadsInRead tableView:self.tableView rootViewController:self delegate:self];
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
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
        //Back button was pressed.  We know this is true because self is no longer in the navigation stack.
        
        //We can immediately clean our teadsSimpleAd
        [self.teadsInRead clean];
    } else {
        [self.teadsInRead viewControllerDisappeared:self];
    }
    
    [super viewDidDisappear:animated];
}

-(void)dealloc {
    [self.teadsInRead clean];
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
