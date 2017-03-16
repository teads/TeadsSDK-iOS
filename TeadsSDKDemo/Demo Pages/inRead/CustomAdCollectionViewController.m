//
//  CustomAdCollectionViewController.m
//  TeadsSDKDemo
//
//  Created by Nikolaï Roycourt on 15/11/2016.
//  Copyright © 2016 Teads. All rights reserved.
//

#import "CustomAdCollectionViewController.h"
#import "CustomCollectionViewCell.h"

#define NB_ITEMS_PORTRAIT 2
#define NB_ITEMS_LANDSCAPE 4

#define NB_ITEMS_PORTRAIT_IPAD 3
#define NB_ITEMS_LANDSCAPE_IPAD 4

@interface CustomAdCollectionViewController ()

@property (strong, nonatomic) CustomCollectionViewCell *adCell;

@property (nonatomic) CGFloat adRatio; //Ad ratio provided by delegate callback -teadsAdCanExpand:withRatio:
@property (nonatomic, assign) BOOL videoViewAdded;

@property (strong, nonatomic) TeadsAd *teadsAd;
@property (strong, nonatomic) NSIndexPath *insertionPath;
@property (strong, nonatomic) IBOutlet UICollectionView *collctnView;

@end

@implementation CustomAdCollectionViewController

@synthesize insertionPath, collctnView;

NSString *collectionViewCellID = @"collectionViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"UICollectionView";
    
    self.collctnView.delegate = self;
    self.collctnView.dataSource = self;
    self.collctnView.frame = self.view.frame;
    
    NSString *pid = [[NSUserDefaults standardUserDefaults] stringForKey:@"pid"];
    self.teadsAd = [[TeadsAd alloc] initWithPlacementId:pid delegate:self];
    
    //Set a collapsed frame to TeadsAd.videoView
    UICollectionViewFlowLayout *flow = (UICollectionViewFlowLayout*) self.collctnView.collectionViewLayout;
    int adjustedWidth = self.collctnView.bounds.size.width - flow.sectionInset.left - flow.sectionInset.right;
    CGRect adFrame = CGRectMake(0, 0, adjustedWidth, 0);
    [self.teadsAd.videoView setFrame:adFrame];
    
    self.insertionPath = [NSIndexPath indexPathForRow:8 inSection:0];
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
        self.insertionPath = [NSIndexPath indexPathForRow:12 inSection:0];
    }
    
    //Observer for device rotation (needed for you to potentially recompute TeadsAd.videoView frame size)
    [[NSNotificationCenter defaultCenter] addObserver: self selector:@selector(deviceOrientationDidChange:) name: UIDeviceOrientationDidChangeNotification object: nil];
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
    [self.teadsAd viewControllerDisappeared:self];
    
    [super viewDidDisappear:animated];
}

-(UIScrollView *)scrollView {
    return self.collctnView;
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}

#pragma mark Orientation change

-(void)deviceOrientationDidChange:(NSNotification *)notification {
    [self.collctnView performBatchUpdates:^{
        [self updateTeadsAdFrame];
    } completion:^(BOOL finished) {
        
        //Because of rotation, layout of the content of the scrollview changed with their respective positions.
        //Inform teadsAd that there was a move  (caused by the rotation)
        [self.teadsAd videoViewDidMove:self.collctnView];
    }];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 20;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([indexPath isEqual:self.insertionPath]) {
        self.adCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"teadsAdCell" forIndexPath:indexPath];
        
        return self.adCell;
    } else {
        CustomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionViewCellID forIndexPath:indexPath];
        
        NSUInteger originalRow = indexPath.row;
        
        //If teadsAd is presented we have to set row to -1 for all rows after teadsAdCell cell if you need to know the original indexPath.row of your cells
        if (self.insertionPath.section == indexPath.section && indexPath.row > self.insertionPath.row) {
            originalRow -= 1;
        }
        
        cell.titleLabel.text = [NSString stringWithFormat:@"section %ld - row %lu", (long)indexPath.section, (unsigned long)originalRow];
        
        return cell;
    }
}

#pragma mark - UIScrollView

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.videoViewAdded) {
        [self.teadsAd videoViewDidMove:scrollView]; //Inform TeadsAd that the view did move in its scrollView container
    }
}

#pragma mark - UICollectionView delegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath isEqual:self.insertionPath]) {
        return self.teadsAd.videoView.frame.size;
    } else {
        return CGSizeMake(([UIScreen mainScreen].bounds.size.width-30)/2 , 200);
    }
}


-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath :(NSIndexPath *)indexPath {
    if ([indexPath isEqual:self.insertionPath]) { //self.insertionPath is the indexPath where TeadsAd was added
        if (!self.videoViewAdded) {
            [self.adCell.contentView addSubview:self.teadsAd.videoView];
            [self.teadsAd videoViewWasAdded]; //Inform that Teads Ad was added and cell will be displayed
            self.videoViewAdded = YES;
        }
    }
}


#pragma mark - 
#pragma mark - Your methods to calculate Custom Ad size

//Compute TeadsAd frame according the UI of you app
-(void)updateTeadsAdFrame {
    //Our collectionView has section inset, so we have to take this in account for TeadsAd frame
    UICollectionViewFlowLayout *flow = (UICollectionViewFlowLayout*) self.collctnView.collectionViewLayout;
    int adjustedWidth = self.collctnView.bounds.size.width - flow.sectionInset.left - flow.sectionInset.right;
    
    CGRect adFrame = CGRectMake(0, 0, adjustedWidth, adjustedWidth * self.adRatio);
    
    //If TeadsAd frame height is bigger than its container, size must be adjusted so that it fits in it
    if (adFrame.size.height > self.collctnView.bounds.size.height && self.adRatio > 0) {
        adFrame = CGRectMake(0, 0, self.collctnView.bounds.size.height/self.adRatio, self.collctnView.bounds.size.height);
    }
    
    [self.teadsAd.videoView setFrame:adFrame];
}

#pragma mark -
#pragma mark - TeadsAd delegate

/**
 * Teads Ad is ready to be shown
 *
 * @param video  : the TeadsAd object
 */
- (void)teadsAdCanExpand:(TeadsAd *)ad withRatio:(CGFloat)ratio{
    self.adRatio = ratio;
    
    [self.collctnView performBatchUpdates:^{
        [self updateTeadsAdFrame];
    } completion:^(BOOL finished) {
        [self.teadsAd videoViewDidExpand];
    }];
}

/**
 * Teads Ad can be collapsed
 *
 * @param video  : the TeadsAd object
 */
- (void)teadsAdCanCollapse:(TeadsAd *)ad {
    self.adRatio = 0;
    
    CGRect collapsedAdFrame = self.teadsAd.videoView.frame;
    collapsedAdFrame.size.height = 0;
    
    //Collapse animation and duration are optional, choose what fits best for your app
    [UIView animateWithDuration:0.5 animations:^{
        [self.collctnView performBatchUpdates:^{
            [self.teadsAd.videoView setFrame:collapsedAdFrame];
        } completion:nil];
    } completion:^(BOOL finished) {
        [self.teadsAd videoViewDidCollapse];
    }];
}

@end
