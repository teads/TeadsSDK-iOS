//
//  InBoardTableViewController.m
//  TeadsSDKDemo
//
//  Created by Nikolaï Roycourt on 16/01/2015.
//  Copyright (c) 2015 Teads. All rights reserved.
//

#import "InBoardTableViewController.h"

@interface InBoardTableViewController ()

@property (assign, nonatomic) BOOL adExperienceLoaded;
@property (nonatomic, strong) TeadsNativeVideo *teadsinBoard;

@end

@implementation InBoardTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"inBoard TableView";
    
    self.adExperienceLoaded = NO;
    self.teadsinBoard = [[TeadsNativeVideo alloc] initInBoardWithPlacementId:@"27695" tableView:self.tableView rootViewController:self delegate:self];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.adExperienceLoaded) {
        [self.teadsinBoard viewControllerAppeared:self];
        
    } else {
        [self.teadsinBoard load];
    }
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    if (self.adExperienceLoaded) {
        [self.teadsinBoard viewControllerDisappeared:self];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
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

#pragma mark - TeadsNativeVideoDelegate

- (void)teadsNativeVideoDidLoad:(TeadsNativeVideo *)nativeVideo {
    self.adExperienceLoaded = YES;
}

- (void)teadsNativeVideoDidDismiss:(TeadsNativeVideo *)nativeVideo {
    
}

- (void)teadsNativeVideoDidStart:(TeadsNativeVideo *)nativeVideo {
    
}

- (void)teadsNativeVideoDidStop:(TeadsNativeVideo *)nativeVideo {
    
}

- (void)teadsNativeVideoDidPause:(TeadsNativeVideo *)nativeVideo {
    
}

- (void)teadsNativeVideoDidResume:(TeadsNativeVideo *)nativeVideo {
    
}

- (void)teadsNativeVideoDidCollapse:(TeadsNativeVideo *)nativeVideo {
    self.adExperienceLoaded = NO;
}

@end
