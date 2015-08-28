//
//  SimpleInReadScrollViewViewController.m
//  TeadsSDKDemo
//
//  Created by Nikolaï Roycourt on 28/07/2015.
//  Copyright (c) 2015 Teads. All rights reserved.
//

#import "CustomNativeVideoScrollViewViewController.h"

////Defines the Teads video frame before display
//#define collapsedVideoViewFrame CGRectMake(8, 715, 359, 0)
//
////Defines the Teads video frame for display
//#define expandedVideoViewFrame CGRectMake(8, 715, 359, 220)

@interface CustomNativeVideoScrollViewViewController ()

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) TeadsNativeVideo *teadsSimpleAd;
@property (strong, nonatomic) IBOutlet UILabel *uiLabelForReference;

//Defines the Teads video frame before display
@property (nonatomic, assign) CGRect collapsedVideoViewFrame;
//Defines the Teads video frame for display
@property (nonatomic, assign) CGRect expandedVideoViewFrame;

@end

@implementation CustomNativeVideoScrollViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.scrollView.delegate = self;
    
    self.teadsSimpleAd = [[TeadsNativeVideo alloc] initWithPlacementId:@"27695" delegate:self];
    
    [self.teadsSimpleAd load];
    
    self.navigationController.delegate = self;
}

-(void) viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
        //Back button was pressed.  We know this is true because self is no longer in the navigation stack.

        //We can immediately clean our teadsSimpleAd
        [self.teadsSimpleAd clean];
    }
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addVideoView {
    [self.scrollView addSubview:[self.teadsSimpleAd nativeVideoView]];
    
    //Exemple of presenting animation
    [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionTransitionFlipFromTop animations:^{
        [self.teadsSimpleAd setNativeVideoViewFrameHeight:self.expandedVideoViewFrame.size.height];
    } completion:^(BOOL finished) {
        
        //Ad is presented, we can now start playing
        [self.teadsSimpleAd requestPlay];
    }];
}

#pragma mark -
#pragma UIScrollView

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //
    // This behaviour is strongly recommanded on scrolling
    //
    
    if (self.teadsSimpleAd.isStarted) { //Ad is already started
        
        //teadsSimpleAd is started implies that we already have defined its frame
        //So we can directly check if teadsSimpleAd's view meets visibility requirements
        if ([self.teadsSimpleAd isFrame:[self.teadsSimpleAd nativeVideoView].frame viewableInView:self.scrollView]){
            //If ad is NOT alreay playing
            if (!self.teadsSimpleAd.isPlaying) {
                //Start playing
                [self.teadsSimpleAd requestPlay];
            }
        }
        //The view frame that contains our teadsSimpleAd's view DOES NOT meet visibility requirements
        else if (self.teadsSimpleAd.isPlaying) { //If ad is already playing
            //Pause playing
            [self.teadsSimpleAd requestPause];
        }
    }
    //Ad is NOT already started
    //If our teadsSimpleAd is loaded AND the expandedVideoViewFrame (frame that will be applied to teadsSimpleAd view) meets visibility requirements in our scrollView
    else if (self.teadsSimpleAd.isLoaded && [self.teadsSimpleAd isFrame:self.expandedVideoViewFrame viewableInView:self.scrollView]) {
        
        //We can then display our Ad
        [self addVideoView];
    }
}

#pragma mark -
#pragma mark Teads delegate

/**
 * NativeVideo Did Load (loaded successfully)
 *
 * @param interstitial  : the TeadsNativeVideo object
 */
- (void)teadsNativeVideoDidLoad:(TeadsNativeVideo *)nativeVideo{ //Our teadsSimpleAd is now loaded
    
    //The following code is for example purposes
    //It allows to immiadiately show teadsSimpleAd if its parent view (simpleAdContainerView) is immediately “viewable" without the need to have a first scroll event
    
    //We set a collapsed frame (height is 0) to our teadsSimpleAd, needed for the expanding animation that we do later in -(void)addVideoView
    
    
    self.collapsedVideoViewFrame = CGRectMake(8,
                                       CGRectGetMaxY(self.uiLabelForReference.frame),
                                       359,
                                       0);
    [self.teadsSimpleAd setNativeVideoViewFrame:self.collapsedVideoViewFrame];
    
    self.expandedVideoViewFrame = CGRectMake(self.collapsedVideoViewFrame.origin.x,
                                             self.collapsedVideoViewFrame.origin.y,
                                             self.collapsedVideoViewFrame.size.width,
                                             220);
    
    //For safety reason, we check if video ad is NOT already started
    //And if the expandedVideoViewFrame (frame that will be applied to teadsSimpleAd view) meets visibility requirements in our scrollView
    if (!self.teadsSimpleAd.isStarted && [self.teadsSimpleAd isFrame:self.expandedVideoViewFrame viewableInView:self.scrollView]) {
        //We can then display our Ad
        [self addVideoView];
    }
}


/**
 * NativeVideo Did Stop Playing (stopped)
 *
 * @param nativeVideo  : the TeadsNativeVideo object
 */
- (void)teadsNativeVideoDidStop:(TeadsNativeVideo *)nativeVideo{ //Native video did stop : we should remove the video view
    
    //Exemple of collapsing animation
    [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionTransitionFlipFromTop animations:^{
        [self.teadsSimpleAd setNativeVideoViewFrameHeight:0];
    } completion:^(BOOL finished) {
        
        //We remove our teadsSimpleAd view
        [[self.teadsSimpleAd nativeVideoView] removeFromSuperview];
        
        //Depending on your own needs, you can also remove your equivalent of simpleAdContainerView if you are using one
        //[self.simpleAdContainerView removeFromSuperview];
    }];
}


@end
