//
//  MainViewController.m
//  TeadsSDKDemo
//
//  Created by Nikolaï Roycourt on 15/01/2015.
//  Copyright (c) 2015 Teads. All rights reserved.
//

#import "MainViewController.h"

#import "InBoardScrollViewController.h"
#import "InBoardTableViewController.h"
#import "InBoardWebViewController.h"
#import "InReadScrollViewController.h"
#import "InReadTableViewController.h"
#import "InReadWebViewController.h"
#import "InSwipeViewController.h"
#import "InFlowViewController.h"

@interface MainViewController () {
    NSArray *titlesForHeader;
    NSArray *controllers;
}

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTranslucent:NO];
    
    self.title = @"Teads SDK Demo";
    
    titlesForHeader = @[@"Native Video", @"Interstitial"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)tableView:(UITableView *)tableView canCollapseSection:(NSInteger)section
{
    if (section!=1) return YES;
    
    return NO;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [titlesForHeader count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 10;
    }
    
    return 2;
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return [titlesForHeader objectAtIndex:section]; ;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:14];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                cell.userInteractionEnabled = NO;
                cell.backgroundColor = [UIColor  colorWithWhite:1 alpha:0.5];
                cell.textLabel.textColor = [UIColor grayColor];
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.textLabel.text = @"inRead";
                break;
            case 1:
                cell.textLabel.text = @"inRead ScrollView";
                
                break;
            case 2:
                cell.textLabel.text = @"inRead WebView";
                break;
            case 3:
                cell.textLabel.text = @"inRead TableView";
                break;
            case 4:
                cell.userInteractionEnabled = NO;
                cell.backgroundColor = [UIColor  colorWithWhite:1 alpha:0.5];
                cell.textLabel.textColor = [UIColor grayColor];
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.textLabel.text = @"inBoard";
                break;
            case 5:
                cell.textLabel.text = @"inBoard ScrollView";
                break;
            case 6:
                cell.textLabel.text = @"inBoard WebView";
                break;
            case 7:
                cell.textLabel.text = @"inBoard TableView";
                break;
            case 8:
                cell.userInteractionEnabled = NO;
                cell.backgroundColor = [UIColor  colorWithWhite:1 alpha:0.5];
                cell.textLabel.textColor = [UIColor grayColor];
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.textLabel.text = @"inSwipe";
                break;
            case 9:
                cell.textLabel.text = @"inSwipe Pager";
                break;
            default:
                break;
        }
    } else {
        switch (indexPath.row) {
            case 0:
                cell.userInteractionEnabled = NO;
                cell.backgroundColor = [UIColor  colorWithWhite:1 alpha:0.5];
                cell.textLabel.textColor = [UIColor grayColor];
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.textLabel.text = @"inFlow";
                break;
            case 1:
                cell.textLabel.text = @"inFlow demo page";
                break;
            default:
                break;
        } 
    }
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    InReadScrollViewController *inReadScrollView =  [storyboard  instantiateViewControllerWithIdentifier:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)?@"inReadScrollViewForIPad":@"inReadScrollView"];
    InReadWebViewController *inReadWebView =        [storyboard instantiateViewControllerWithIdentifier:@"inReadWebView"];
    InReadTableViewController *inReadTableView =    [storyboard instantiateViewControllerWithIdentifier:@"inReadTableView"];
    
    InBoardScrollViewController *inBoardScrollView =    [storyboard instantiateViewControllerWithIdentifier:@"inBoardScrollView"];
    InBoardWebViewController *inBoardWebView =          [storyboard instantiateViewControllerWithIdentifier:@"inBoardWebView"];
    InBoardTableViewController *inBoardTableView =      [storyboard instantiateViewControllerWithIdentifier:@"inBoardTableView"];
    
    InSwipeViewController *inSwipe = [storyboard instantiateViewControllerWithIdentifier:@"inSwipe"];
    
    NSArray *section1 = @[[NSNull null], inReadScrollView, inReadWebView, inReadTableView,
                          [NSNull null], inBoardScrollView, inBoardWebView, inBoardTableView,
                          [NSNull null], inSwipe];
    
    InFlowViewController *inFlow = [storyboard instantiateViewControllerWithIdentifier:@"inFlow"];
    
    NSArray *section2 = @[[NSNull null], inFlow];
    
    controllers = @[section1, section2];
    
    
    
    NSArray *controllersAtIndex = [controllers objectAtIndex:indexPath.section];
    id controller = [controllersAtIndex objectAtIndex:indexPath.row];
    
    if (controller != [NSNull null]) {
        [self.navigationController pushViewController:controller animated:YES];
    }
}


@end
