//
//  inReadTopCollectionViewController.m
//  TeadsSDKDemo
//
//  Created by Nikolaï Roycourt on 15/11/2016.
//  Copyright © 2016 Teads. All rights reserved.
//

#import "InReadTopCollectionViewController.h"
#import "CustomCollectionViewCell.h"

@interface InReadTopCollectionViewController ()

@property (strong, nonatomic) TeadsAd *teadsAd;

@end

@implementation InReadTopCollectionViewController

static NSString * const reuseIdentifier = @"cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Register cell classes
//    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    self.navigationItem.title = @"inRead Top CollectionView";
    
    NSString *pid = [[NSUserDefaults standardUserDefaults] stringForKey:@"pid"];
    
    self.teadsAd = [[TeadsAd alloc] initInReadTopWithPlacementId:pid scrollView:self.collectionView delegate:self];
    
}

#pragma mark UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(([UIScreen mainScreen].bounds.size.width-30)/2 , 200);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 20;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CustomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.titleLabel.text = [NSString stringWithFormat:@"section %ld - row %ld", (long)indexPath.section, (long)indexPath.row];
    
    return cell;
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
