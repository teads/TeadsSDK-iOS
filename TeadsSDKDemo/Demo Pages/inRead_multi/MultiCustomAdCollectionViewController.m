//
//  MultiCustomAdCollectionViewController.m
//  TeadsSDKDemo
//
//  Created by Nikolaï Roycourt on 14/03/2017.
//  Copyright © 2017 Teads. All rights reserved.
//

#import "MultiCustomAdCollectionViewController.h"
#import "CustomCollectionViewCell.h"

/*
 *
 * Note:
 * What is done is this class is to show in the simplest way how to display multiple inRead ads.
 *
 * The way the SDK implementation was coded here was not meant to be beautiful, but to understand quickly how to get things done.
 *
 *
 *
 *
 * Guidelines for displaying multiple ads:
 * - Each TeadsAd instance will have its own ad. If you need to display another ad: create a new TeadsAd instance (and do all actions needed regarding this new instance)
 *
 * - You can use the same PID for each instance (even if using the same PID: new instance of TeadsAd and new `load` call will provide a new ad from our servers)
 *
 * - If you were provided more than 1 PIDs for this view: use one PID for each TeadsAd instance
 *
 * - You have an infinite scroll : you can create more TeadsAd instances (load them where needed) and loop on your pool of PIDs if you were provided multiple PIDs.
 *
 *
 * Awareness about our ad sizes regarding to your UI
 * Be aware that our server can provide ads with various sizes:
 * - Landscape : 16:9 ratio, 16:10 ratio, or similar
 * - Square : 1:1 or similar
 * - Vertical : 9:16 ratio, 10:16 ratio, or similar
 * - etc...
 *
 * You will receive the ratio of the ad through TeadsAd delegate callback -teadsAdCanExpand:withRatio:
 *
 */

@interface MultiCustomAdCollectionViewController ()

@property (strong, nonatomic) TeadsAd *teadsAd1;
@property (strong, nonatomic) NSIndexPath *teadsAd1IndexPath;
@property (assign, nonatomic) BOOL teadsAd1Added;
@property (nonatomic) CGFloat teadsAd1Ratio;

@property (strong, nonatomic) TeadsAd *teadsAd2;
@property (strong, nonatomic) NSIndexPath *teadsAd2IndexPath;
@property (assign, nonatomic) BOOL teadsAd2Added;
@property (nonatomic) CGFloat teadsAd2Ratio;

@property (strong, nonatomic) TeadsAd *teadsAd3;
@property (strong, nonatomic) NSIndexPath *teadsAd3IndexPath;
@property (assign, nonatomic) BOOL teadsAd3Added;
@property (nonatomic) CGFloat teadsAd3Ratio;

@property (strong, nonatomic) TeadsAd *teadsAd4;
@property (strong, nonatomic) NSIndexPath *teadsAd4IndexPath;
@property (assign, nonatomic) BOOL teadsAd4Added;
@property (nonatomic) CGFloat teadsAd4Ratio;

@end

@implementation MultiCustomAdCollectionViewController

NSString *collecViewCellID = @"collecViewCell2";

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Multiple inRead in CollectionView";
    
    [self createMultipleTeadsAd];
    
    //Observer for device rotation (needed for you to potentially recompute TeadsAd.videoView frame size)
    [[NSNotificationCenter defaultCenter] addObserver: self selector:@selector(deviceOrientationDidChangeMulti:) name: UIDeviceOrientationDidChangeNotification object: nil];
}

- (void)createMultipleTeadsAd {
    //Set a collapsed frame to each of your TeadsAd.videoView
    UICollectionViewFlowLayout *flow = (UICollectionViewFlowLayout*) self.collectionViewLayout;
    int adjustedWidth = self.collectionView.bounds.size.width - flow.sectionInset.left - flow.sectionInset.right;
    CGRect adFrame = CGRectMake(0, 0, adjustedWidth, 0);
    
    /*
     *
     * - 4 instances of TeadsAd are created, each one will be asked later to `load` an ad (if you need to display more different ads, create more instances of TeadsAd and `load` them later)
     * - 4 indexPath (one for each TeadsAd instance) are created so that we know where we want to insert the ad in the UICollectionView
     * - 4 booleans (one for each TeadsAd instance) to track if TeadsAd.videoView was added to a UICollectionView
     */
    
    //First TeadsAd
    //IndexPath where it will be displayed
    self.teadsAd1IndexPath = [NSIndexPath indexPathForRow:8 inSection:0];
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
        self.teadsAd1IndexPath = [NSIndexPath indexPathForRow:12 inSection:0];
    }
    //Create TeadsAd instance with your PID
    NSString *pid1 = [[NSUserDefaults standardUserDefaults] stringForKey:@"pid"];
    self.teadsAd1 = [[TeadsAd alloc] initWithPlacementId:pid1 delegate:self];
    [self.teadsAd1.videoView setFrame:adFrame];
    self.teadsAd1Added = NO;
    
    //Create a second TeadsAd
    //IndexPath where it will be displayed
    self.teadsAd2IndexPath = [NSIndexPath indexPathForRow:15 inSection:0];
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
        self.teadsAd2IndexPath = [NSIndexPath indexPathForRow:23 inSection:0];
    }
    //Create TeadsAd instance with your second PID if you have one (otherwise you can use same PID)
    NSString *pid2 = [[NSUserDefaults standardUserDefaults] stringForKey:@"pid"];
    self.teadsAd2 = [[TeadsAd alloc] initWithPlacementId:pid2 delegate:self];
    [self.teadsAd2.videoView setFrame:adFrame];
    self.teadsAd2Added = NO;
    
    //Create a third TeadsAd
    //IndexPath where it will be displayed
    self.teadsAd3IndexPath = [NSIndexPath indexPathForRow:22 inSection:0];
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
        self.teadsAd3IndexPath = [NSIndexPath indexPathForRow:34 inSection:0];
    }
    //Create TeadsAd instance with your third PID if you have one (otherwise you can use same PID)
    NSString *pid3 = [[NSUserDefaults standardUserDefaults] stringForKey:@"pid"];
    self.teadsAd3 = [[TeadsAd alloc] initWithPlacementId:pid3 delegate:self];
    [self.teadsAd3.videoView setFrame:adFrame];
    self.teadsAd3Added = NO;
    
    //Create a fourth TeadsAd
    //IndexPath where it will be displayed
    self.teadsAd4IndexPath = [NSIndexPath indexPathForRow:29 inSection:0];
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
        self.teadsAd4IndexPath = [NSIndexPath indexPathForRow:45 inSection:0];
    }
    //Create TeadsAd instance with your fourth PID if you have one (otherwise you can use same PID)
    NSString *pid4 = [[NSUserDefaults standardUserDefaults] stringForKey:@"pid"];
    self.teadsAd4 = [[TeadsAd alloc] initWithPlacementId:pid4 delegate:self];
    [self.teadsAd4.videoView setFrame:adFrame];
    self.teadsAd4Added = NO;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    /*
     * We will load here only the first TeadsAd instance (if needed)
     * Next instances are loaded in `-teadsAd:didFailLoading:` and `-teadsAdDidLoad:` delegate methods below
     *
     * This is done in order not to use minimum network and have the first ad loaded the fastest possible way
     *
     * Feel free to do the way that fits your app the best
     *
     */
    
    if (self.teadsAd1Added) {
        [self.teadsAd1 viewControllerAppeared:self];
    } else {
        [self.teadsAd1 load];
    }
    
    if (self.teadsAd2Added) {
        [self.teadsAd2 viewControllerAppeared:self];
    }
    
    if (self.teadsAd3Added) {
        [self.teadsAd3 viewControllerAppeared:self];
    }
    
    if (self.teadsAd4Added) {
        [self.teadsAd4 viewControllerAppeared:self];
    }
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.teadsAd1 viewControllerDisappeared:self];
    [self.teadsAd2 viewControllerDisappeared:self];
    [self.teadsAd3 viewControllerDisappeared:self];
    [self.teadsAd4 viewControllerDisappeared:self];
}

-(UIScrollView *)scrollView {
    return self.collectionView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}

#pragma mark Orientation change

-(void)deviceOrientationDidChangeMulti:(NSNotification *)notification {
    [self.collectionView performBatchUpdates:^{
        [self updateTeadsAdFrame];
    } completion:^(BOOL finished) {
        //Because of rotation, layout of the content of the scrollview changed with their respective positions.
        //Inform TeadsAd instances that there was a move (caused by the rotation)
        if (self.teadsAd1Added) {
            [self.teadsAd1 videoViewDidMove:self.collectionView];
        }
        
        if (self.teadsAd2Added) {
            [self.teadsAd2 videoViewDidMove:self.collectionView];
        }
        
        if (self.teadsAd3Added) {
            [self.teadsAd3 videoViewDidMove:self.collectionView];
        }
        
        if (self.teadsAd4Added) {
            [self.teadsAd4 videoViewDidMove:self.collectionView];
        }
    }];
}

#pragma mark - <UIScrollViewDelegate>

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //Inform TeadsAd instances that the view did move in its scrollView container
    
    if (self.teadsAd1Added) {
        [self.teadsAd1 videoViewDidMove:scrollView];
    }
    
    if (self.teadsAd2Added) {
        [self.teadsAd2 videoViewDidMove:scrollView];
    }
    
    if (self.teadsAd3Added) {
        [self.teadsAd3 videoViewDidMove:scrollView];
    }
    
    if (self.teadsAd4Added) {
        [self.teadsAd4 videoViewDidMove:scrollView];
    }
}

#pragma mark - <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 50;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    /*
     * Create a cell that will receive later TeadsAd.videoView
     *
     * Note : if the TeadsAd instance that will be displayed for this indexPath is not loaded (or failed loading/didn't receive an ad)
     *        check for this TeadsAd instance `TeadsAd.isloaded` if you don't want to create a cell in this situation
     *
     */
    UICollectionViewCell *teadsAdCell;
    if ([indexPath isEqual:self.teadsAd1IndexPath]) {
        teadsAdCell =  [self.collectionView dequeueReusableCellWithReuseIdentifier:@"teadsAdCell1" forIndexPath:indexPath];
            
    } else if([indexPath isEqual:self.teadsAd2IndexPath] ) {
        teadsAdCell =  [self.collectionView dequeueReusableCellWithReuseIdentifier:@"teadsAdCell2" forIndexPath:indexPath];
        
    } else if([indexPath isEqual:self.teadsAd3IndexPath]) {
        teadsAdCell =  [self.collectionView dequeueReusableCellWithReuseIdentifier:@"teadsAdCell3" forIndexPath:indexPath];
            
    } else if([indexPath isEqual:self.teadsAd4IndexPath]) {
        teadsAdCell =  [self.collectionView dequeueReusableCellWithReuseIdentifier:@"teadsAdCell4" forIndexPath:indexPath];
        
    }
    
    if (teadsAdCell) {
        teadsAdCell.backgroundColor = [UIColor clearColor];
        teadsAdCell.contentView.backgroundColor = [UIColor clearColor];
        return teadsAdCell;
    }
    
    CustomCollectionViewCell *cell = (CustomCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:collecViewCellID forIndexPath:indexPath];

    NSUInteger originalRow = indexPath.row;
    cell.titleLabel.text = [NSString stringWithFormat:@"section %ld - row %lu", (long)indexPath.section, (unsigned long)originalRow];
    
    return cell;
}

#pragma mark - <UICollectionViewDelegate>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath isEqual:self.teadsAd1IndexPath]) {
        return self.teadsAd1.videoView.frame.size;
            
    } else if([indexPath isEqual:self.teadsAd2IndexPath]) {
        return self.teadsAd2.videoView.frame.size;
            
    } else if([indexPath isEqual:self.teadsAd3IndexPath]) {
        return self.teadsAd3.videoView.frame.size;
            
    } else if([indexPath isEqual:self.teadsAd4IndexPath]) {
        return self.teadsAd4.videoView.frame.size;
            
    }
    
    CGSize cellSize = CGSizeMake(([UIScreen mainScreen].bounds.size.width-30)/2 , 200);
    return cellSize;
}

-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath :(NSIndexPath *)indexPath {
    // If the UICollectionView will reach an indexPath where you want to insert a TeadsAd:
    //
    // 1) Add TeadsAd.videoView to your cell contentView
    // 2) Inform that Teads Ad was added by calling `videoViewWasAdded`
    // 3) Track on your side that you have added TeadsAd.videoView to the cell
    
    if ([indexPath isEqual:self.teadsAd1IndexPath]) {
        if (!self.teadsAd1Added) {
            [cell.contentView addSubview:self.teadsAd1.videoView];
            [self.teadsAd1 videoViewWasAdded];
            self.teadsAd1Added = YES;
        }
        
    } else if([indexPath isEqual:self.teadsAd2IndexPath]) {
        if (!self.teadsAd2Added) {
            [cell.contentView addSubview:self.teadsAd2.videoView];
            [self.teadsAd2 videoViewWasAdded];
            self.teadsAd2Added = YES;
        }
        
    } else if([indexPath isEqual:self.teadsAd3IndexPath]) {
        if (!self.teadsAd3Added) {
            [cell.contentView addSubview:self.teadsAd3.videoView];
            [self.teadsAd3 videoViewWasAdded];
            self.teadsAd3Added = YES;
        }
        
    } else if([indexPath isEqual:self.teadsAd4IndexPath]) {
        if (!self.teadsAd4Added) {
            [cell.contentView addSubview:self.teadsAd4.videoView];
            [self.teadsAd4 videoViewWasAdded];
            self.teadsAd4Added = YES;
        }
    }
}

#pragma mark -
#pragma mark - Your methods to calculate Custom Ad size

//Compute TeadsAd frame according the UI of you app
-(void)updateTeadsAdFrame {
    //Our collectionView has section inset, so we have to take this in account for TeadsAd frame
    UICollectionViewFlowLayout *flow = (UICollectionViewFlowLayout*) self.collectionView.collectionViewLayout;
    int adjustedWidth = self.collectionView.bounds.size.width - flow.sectionInset.left - flow.sectionInset.right;
    
    CGRect ad1Frame = CGRectMake(0, 0, adjustedWidth, adjustedWidth * self.teadsAd1Ratio);
    
    //If TeadsAd frame height is bigger than its container, size must be adjusted so that it fits in it
    if (ad1Frame.size.height > self.collectionView.bounds.size.height && self.teadsAd1Ratio > 0) {
        ad1Frame = CGRectMake(0, 0, self.collectionView.bounds.size.height/self.teadsAd1Ratio, self.collectionView.bounds.size.height);
    }
    
    [self.teadsAd1.videoView setFrame:ad1Frame];
    
    
    CGRect ad2Frame = CGRectMake(0, 0, adjustedWidth, adjustedWidth * self.teadsAd2Ratio);
    
    //If TeadsAd frame height is bigger than its container, size must be adjusted so that it fits in it
    if (ad2Frame.size.height > self.collectionView.bounds.size.height && self.teadsAd2Ratio > 0) {
        ad2Frame = CGRectMake(0, 0, self.collectionView.bounds.size.height/self.teadsAd2Ratio, self.collectionView.bounds.size.height);
    }
    
    [self.teadsAd2.videoView setFrame:ad2Frame];
    
    
    CGRect ad3Frame = CGRectMake(0, 0, adjustedWidth, adjustedWidth * self.teadsAd3Ratio);
    
    //If TeadsAd frame height is bigger than its container, size must be adjusted so that it fits in it
    if (ad3Frame.size.height > self.collectionView.bounds.size.height && self.teadsAd3Ratio > 0) {
        ad3Frame = CGRectMake(0, 0, self.collectionView.bounds.size.height/self.teadsAd3Ratio, self.collectionView.bounds.size.height);
    }
    
    [self.teadsAd3.videoView setFrame:ad3Frame];
    
    CGRect ad4Frame = CGRectMake(0, 0, adjustedWidth, adjustedWidth * self.teadsAd4Ratio);
    
    //If TeadsAd frame height is bigger than its container, size must be adjusted so that it fits in it
    if (ad4Frame.size.height > self.collectionView.bounds.size.height && self.teadsAd4Ratio > 0) {
        ad4Frame = CGRectMake(0, 0, self.collectionView.bounds.size.height/self.teadsAd4Ratio, self.collectionView.bounds.size.height);
    }
    
    [self.teadsAd4.videoView setFrame:ad4Frame];
}

//Compute TeadsAd frame according the UI of you app
-(void)updateTeadsAdFrame:(TeadsAd *)ad withRatio:(CGFloat)ratio {
    if (ad == self.teadsAd1) {
        self.teadsAd1Ratio = ratio;
    } else if (ad == self.teadsAd2) {
        self.teadsAd2Ratio = ratio;
    } else if (ad == self.teadsAd3) {
        self.teadsAd3Ratio = ratio;
    } else if (ad == self.teadsAd4) {
        self.teadsAd4Ratio = ratio;
    }
    
    
    //Our collectionView has section inset, so we have to take this in account for TeadsAd frame
    UICollectionViewFlowLayout *flow = (UICollectionViewFlowLayout*) self.collectionView.collectionViewLayout;
    
    //Start from the max width you desire (here its the collectionView "content" size width)
    int adjustedWidth = self.collectionView.bounds.size.width - flow.sectionInset.left - flow.sectionInset.right;
    //Set frame size with width, and height applying ratio
    CGRect adFrame = CGRectMake(0, 0, adjustedWidth, adjustedWidth * ratio);
    
    //If TeadsAd frame height is bigger than its container (the collectionView), size must be adjusted so that it fits in it
    if (adFrame.size.height > self.collectionView.bounds.size.height && ratio > 0) {
        adFrame = CGRectMake(0, 0, self.collectionView.bounds.size.height/ratio, self.collectionView.bounds.size.height);
    }
    
    //Set the ad frame
    [ad.videoView setFrame:adFrame];
}

#pragma mark - Custom methods regarding TeadsAd usage

-(void)loadNext:(TeadsAd *)ad {
    [ad load];
}

#pragma mark -
#pragma mark TeadsAd delegate

/**
 * Ad failed to load
 *
 * @param ad The TeadsAd object
 * @param error The TeadsError object
 */
- (void)teadsAd:(TeadsAd *)ad didFailLoading:(TeadsError *)error {

    // Here you have multiple choices of action:
    
    /*
     * Choice A) load the next instance of TeadsAd if one fails to load (this could also mean no ad provided from servers)
     */
    if (ad == self.teadsAd1) {
        [self.teadsAd2 load];
        
    } else if (ad == self.teadsAd2) {
        [self.teadsAd3 load];
        
    } else if (ad ==  self.teadsAd3) {
        [self.teadsAd4 load];
        
    }
    
    /*
     * Choice B) try to load again the same TeadsAd instance
     *
     * We recommend :
     * - keep a counter on how many load you made on the TeadsAd instance ot give a maximum of retry to load an ad (because of many many many reason, there could simply be no ad available for the PID you are using on this TeadsAd instance)
     * - add a delay after making a new load in a didFailLoading: situation
     *
     */
//    if (numberOfLoadForThisTeadsAdInstance < 5) {
//        [self performSelector:@selector(loadNexTeadsAd) withObject:ad afterDelay:1];
//        numberOfLoadForThisTeadsAdInstance++;
//    }
}

/**
 * Ad did load (loaded successfully)
 *
 * @param ad The TeadsAd object
 */
- (void)teadsAdDidLoad:(TeadsAd *)ad {
    /*
     * Because in -viewDidAppear: we chose to load only teadsAd1 we can now load the next TeadsAd instance
     */
    
    if (ad == self.teadsAd1) {
        [self.teadsAd2 load];
        
    } else if (ad == self.teadsAd2) {
        [self.teadsAd3 load];
        
    } else if (ad ==  self.teadsAd3) {
        [self.teadsAd4 load];
        
    }
}

/**
 * Ad is ready to be shown
 *
 * @param ad  : the TeadsAd object
 */
- (void)teadsAdCanExpand:(TeadsAd *)ad withRatio:(CGFloat)ratio{
    [self.collectionView performBatchUpdates:^{
        [self updateTeadsAdFrame:ad withRatio:ratio];
    } completion:^(BOOL finished) {
        [ad videoViewDidExpand];
    }];
}

/**
 * Ad can be collapsed
 *
 * @param ad  : the TeadsAd object
 */
- (void)teadsAdCanCollapse:(TeadsAd *)ad {
    CGRect collapsedAdFrame = ad.videoView.frame;
    collapsedAdFrame.size.height = 0;
    
    //Collapse animation and duration are optional, choose what fits best for your app
    [UIView animateWithDuration:0.5 animations:^{
        [self.collectionView performBatchUpdates:^{
            [ad.videoView setFrame:collapsedAdFrame];
        } completion:nil];
    } completion:^(BOOL finished) {
        [ad videoViewDidCollapse];
    }];
}

@end
