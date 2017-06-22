//
//  MainViewController.m
//  TeadsSDKDemo
//
//  Created by Nikolaï Roycourt on 15/01/2015.
//  Copyright (c) 2015 Teads. All rights reserved.
//

#import "MainViewController.h"

#import "InReadTopScrollViewController.h"
#import "InReadTopTableViewController.h"
#import "InReadTopWebViewController.h"
#import "InReadTopWKWebView.h"
#import "InReadTopCollectionViewController.h"
#import "InReadScrollViewController.h"
#import "InReadTableViewController.h"
#import "CustomAdScrollViewController.h"
#import "CustomAdCollectionViewController.h"
#import "MultiCustomAdCollectionViewController.h"
#import "InReadWebViewController.h"
#import "InReadWebViewEmbededInScrollViewViewController.h"
#import "InReadWKWebview.h"
#import "InReadWkWebViewEmbededInScrollViewViewController.h"
#import "inReadWebViewInTableViewViewController.h"
#import "inReadWkWebViewInTableViewViewController.h"
#import "inReadWebViewInCollectionViewController.h"
#import "inReadWkWebViewInCollectionViewController.h"
#import "DemoUtils.h"


//BE CAREFUL : this string should be the title you want in the list AND the storyboard Id of the controller attached to the cell
static NSString *inReadHeaderString         = @"inRead";
static NSString *inReadScrollViewString     = @"inRead ScrollView";
static NSString *inReadWebViewString        = @"inRead WebView";
static NSString *inReadWKWebViewString      = @"inRead WKWebView";
static NSString *inReadTableViewString      = @"inRead TableView";
static NSString *inReadWebViewEmbededHeaderString               = @"inRead WebView embeded";
static NSString *inReadWebViewEmbededInScrollViewString         = @"inRead WebView in ScrollView";
static NSString *inReadWKWebViewEmbededInScrollViewString       = @"inRead WKWebView in ScrollView";
static NSString *inReadWebViewEmbededInTableViewString          = @"inRead WebView in TableView";
static NSString *inReadWKWebViewEmbededInTableViewString        = @"inRead WKWebView in TableView";
static NSString *inReadWebViewEmbededInCollectionViewString     = @"inRead WebView in CollectionView";
static NSString *inReadWKWebViewEmbededInCollectionViewString   = @"inRead WKWebView in CollectionView";
static NSString *inReadTopHeaderString          = @"inRead Top";
static NSString *inReadTopScrollViewString      = @"inRead Top ScrollView";
static NSString *inReadTopWebViewString         = @"inRead Top WebView";
static NSString *inReadTopWKWebViewString       = @"inRead Top WKWebView";
static NSString *inReadTopTableViewString       = @"inRead Top TableView";
static NSString *inReadTopCollectionViewString  = @"inRead Top CollectionView";
static NSString *inReadCustomHeaderString                   = @"inRead particuliar case";
static NSString *inReadCustomScrollViewString               = @"inRead custom in ScrollView";
static NSString *inReadCustomCollectionViewString           = @"inRead in CollectionView";
static NSString *inReadMultipleCustomCollectionViewString   = @"Multiple inRead in CollectionView";

@interface ListObject : NSObject

@property NSString *className;
@property BOOL isHeader;
/// yes if the object has an ipad version of the controller
@property BOOL hasIpadVersion;
- (id) initWithClassName:(NSString *)className withIsHeader: (BOOL)isHeader;
@end

@implementation ListObject

- (id) initWithClassName:(NSString *)className withIsHeader: (BOOL)isHeader {
    self = [super init];
    if (self) {
        self.className = className;
        self.isHeader = isHeader;
    }
    return self;
}

@end

@interface MainViewController () {
    NSArray *titlesForHeader;
    NSArray *controllers;
    NSMutableArray *listObjects;
}

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTranslucent:NO];

    self.title = @"Teads SDK Demo";
    
    {
        titlesForHeader = @[@"Native Video", @"App Parameters"];
        listObjects = [NSMutableArray new];
        ListObject *inReadHeader = [[ListObject alloc]initWithClassName:inReadHeaderString withIsHeader:YES];
        [listObjects addObject:inReadHeader];
        
        ListObject *inReadScrollView = [[ListObject alloc]initWithClassName:inReadScrollViewString withIsHeader:NO];
        inReadScrollView.hasIpadVersion = YES;
        [listObjects addObject:inReadScrollView];
        
        ListObject *inReadWebView = [[ListObject alloc]initWithClassName:inReadWebViewString withIsHeader:NO];
        [listObjects addObject:inReadWebView];
        
        ListObject *inReadWKWebView = [[ListObject alloc]initWithClassName:inReadWKWebViewString withIsHeader:NO];
        [listObjects addObject:inReadWKWebView];
        
        ListObject *inReadTableView = [[ListObject alloc]initWithClassName:inReadTableViewString withIsHeader:NO];
        [listObjects addObject:inReadTableView];
        
        ListObject *inReadWebViewEmbededHeader = [[ListObject alloc]initWithClassName:inReadWebViewEmbededHeaderString withIsHeader:YES];
        [listObjects addObject:inReadWebViewEmbededHeader];
        
        ListObject *inReadWebViewEmbededInScrollView = [[ListObject alloc]initWithClassName:inReadWebViewEmbededInScrollViewString withIsHeader:NO];
        [listObjects addObject:inReadWebViewEmbededInScrollView];
        
        ListObject *inReadWkWebViewEmbededInScrollView = [[ListObject alloc]initWithClassName:inReadWKWebViewEmbededInScrollViewString withIsHeader:NO];
        [listObjects addObject:inReadWkWebViewEmbededInScrollView];
        
        ListObject *inReadWKWebViewEmbededInScrollView = [[ListObject alloc]initWithClassName:inReadWebViewEmbededInTableViewString withIsHeader:NO];
        [listObjects addObject:inReadWKWebViewEmbededInScrollView];
        
        ListObject *inReadWebViewEmbededInTableView = [[ListObject alloc]initWithClassName:inReadWKWebViewEmbededInTableViewString withIsHeader:NO];
        [listObjects addObject:inReadWebViewEmbededInTableView];
        
        ListObject *inReadWebViewEmbededInCollectionView = [[ListObject alloc]initWithClassName:inReadWebViewEmbededInCollectionViewString withIsHeader:NO];
        [listObjects addObject:inReadWebViewEmbededInCollectionView];
        
        ListObject *inReadWKWebViewEmbededInCollectionView = [[ListObject alloc]initWithClassName:inReadWKWebViewEmbededInCollectionViewString withIsHeader:NO];
        [listObjects addObject:inReadWKWebViewEmbededInCollectionView];
        
        ListObject *inReadTopHeader = [[ListObject alloc]initWithClassName:inReadTopHeaderString withIsHeader:YES];
        [listObjects addObject:inReadTopHeader];
        
        ListObject *inReadTopScrollView = [[ListObject alloc]initWithClassName:inReadTopScrollViewString withIsHeader:NO];
        inReadTopScrollView.hasIpadVersion = YES;
        [listObjects addObject:inReadTopScrollView];
        
        ListObject *inReadTopWebView = [[ListObject alloc]initWithClassName:inReadTopWebViewString withIsHeader:NO];
        [listObjects addObject:inReadTopWebView];
        
        ListObject *inReadTopWKWebView = [[ListObject alloc]initWithClassName:inReadTopWKWebViewString withIsHeader:NO];
        [listObjects addObject:inReadTopWKWebView];
        
        ListObject *inReadTopTableView = [[ListObject alloc]initWithClassName:inReadTopTableViewString withIsHeader:NO];
        [listObjects addObject:inReadTopTableView];
        
        ListObject *inReadTopCollectionView = [[ListObject alloc]initWithClassName:inReadTopCollectionViewString withIsHeader:NO];
        [listObjects addObject:inReadTopCollectionView];
        
        ListObject *inReadCustomHeader = [[ListObject alloc]initWithClassName:inReadCustomHeaderString withIsHeader:YES];
        [listObjects addObject:inReadCustomHeader];
        
        ListObject *inReadCustomScrollView = [[ListObject alloc]initWithClassName:inReadCustomScrollViewString withIsHeader:NO];
        inReadCustomScrollView.hasIpadVersion = YES;
        [listObjects addObject:inReadCustomScrollView];
        
        ListObject *inReadCustomCollectionView = [[ListObject alloc]initWithClassName:inReadCustomCollectionViewString withIsHeader:NO];
        [listObjects addObject:inReadCustomCollectionView];
        
        ListObject *inReadMultipleCustomCollectionView = [[ListObject alloc]initWithClassName:inReadMultipleCustomCollectionViewString withIsHeader:NO];
        [listObjects addObject:inReadMultipleCustomCollectionView];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [titlesForHeader count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return listObjects.count;
    }
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return [titlesForHeader objectAtIndex:section];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellTitleIdentifier = @"CellTitle";
    static NSString *CellIdentifier = @"Cell";
    
    
    NSString *cellTextLabel;
    ListObject *currentObject;
    if (indexPath.section == 0) {
        currentObject = [listObjects objectAtIndex:indexPath.row];
        cellTextLabel = currentObject.className;
    }
    else {
        switch (indexPath.row) {
            case 0:
                cellTextLabel = @"Change PID";
                break;
            case 1:
                cellTextLabel = @"Change website";
                break;
            default:
                break;
        }
    }
    
    UITableViewCell *cell;
    if (indexPath.section == 0
         && currentObject.isHeader) {
        cell = [tableView dequeueReusableCellWithIdentifier:CellTitleIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellTitleIdentifier];
        }
        cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:14];
        cell.userInteractionEnabled = NO;
        cell.backgroundColor = [UIColor  colorWithWhite:1 alpha:0.5];
        cell.textLabel.textColor = [UIColor grayColor];
        cell.accessoryType = UITableViewCellAccessoryNone;
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.textLabel.text = cellTextLabel;
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    id controller = nil;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    if (indexPath.section == 0) {
        ListObject *currentListObject = [listObjects objectAtIndex:indexPath.row];
        NSString *controllerName = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) && currentListObject.hasIpadVersion ? [currentListObject.className stringByAppendingString:@" iPad"] : currentListObject.className;
        
        controller = [storyboard instantiateViewControllerWithIdentifier:controllerName];
        
    } else if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0: {
                [DemoUtils presentControllerToChangePid:self];
                break;
            }
            case 1: {
                [DemoUtils presentControllerToChangeWebsite:self];
                break;
            }
            default:
                break;
        }
    }
    
    if (controller != nil) {
        [self.navigationController pushViewController:controller animated:YES];
    }
}


@end
