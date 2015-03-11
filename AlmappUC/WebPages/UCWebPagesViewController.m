//
//  UCWebPagesViewController.m
//  AlmappUC
//
//  Created by Patricio López on 12-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "UCWebPagesViewController.h"
#import <AlmappCore/AlmappCore.h>
#import <AlmappCore/ALMResourceConstants.h>

#import "UCWebPagesCollectionViewCell.h"
#import "UCAppDelegate.h"
#import "UCWebBrowserViewController.h"
#import "UINavigationBar+Clear.h"

static NSString *const kWebPagesCellIdentifier = @"webCell";
static short const kWebPagesDefaultSegment = 0;
static float const kWebPageCellMargin = 3.0f;

@interface UCWebPagesViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *navBarBackgroundImageView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;


@property (assign) short initialSelectedSegment;
@property (strong, nonatomic) RLMResults *webPages;

- (IBAction)segmentedControlValueChange:(UISegmentedControl *)sender;

@end

@implementation UCWebPagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[self.navigationController setClearNavigationBar];
    
    [self.navBarBackgroundImageView setImage:[UCStyle bannerBackgroundImage]];
    
    _initialSelectedSegment = kWebPagesDefaultSegment;
    [self loadWebPagesForSegmentIndex:_initialSelectedSegment];

    _segmentedControl.selectedSegmentIndex = _initialSelectedSegment;
    //_segmentedControl.tintColor = [UIColor navbarAccent];
    
    self.collectionView.alwaysBounceVertical = YES;
    
    [self fetch];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetch {
    ALMController *controller = [UCAppDelegate controller];
    
    self.webPages = [ALMWebPage allObjects];
    if (self.webPages.count == 0) {
        [self.navigationController showProgress];
    }
    else {
        [self loadWebPagesForSegmentIndex:_segmentedControl.selectedSegmentIndex];
    }

    
    [controller GETResources:[ALMWebPage class] parameters:nil realm:[RLMRealm defaultRealm]].then( ^(id jsonResult, NSURLSessionDataTask *task, id result) {
        [self loadWebPagesForSegmentIndex:_segmentedControl.selectedSegmentIndex];
        [self.navigationController dismissProgress];
        
    }).catch( ^(NSError *error) {
        [self.navigationController showError:error];
    });
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.webPages.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    UCWebPagesCollectionViewCell *cell = [collectionView
                                    dequeueReusableCellWithReuseIdentifier:kWebPagesCellIdentifier
                                    forIndexPath:indexPath];
    
    cell.webpage = self.webPages[indexPath.row];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    UCWebBrowserViewController *webBrowser = [UCWebBrowserViewController myWebBrowser];
    webBrowser.initialWebpageToLoad = [_webPages objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:webBrowser animated:YES];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    short itemsPerRow = [self itemsPerRowForSegmentedIndex:_segmentedControl.selectedSegmentIndex];
    float size = collectionView.frame.size.width / itemsPerRow;
    
    size -= kWebPageCellMargin * 1 * itemsPerRow;
    
    return CGSizeMake(size, size);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(kWebPageCellMargin*2,kWebPageCellMargin*3,0,0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return kWebPageCellMargin;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (RLMResults*)loadWebPagesForIdentifiers:(NSArray*)identifiers {
    return [ALMWebPage objectsWhere:[NSString stringWithFormat:@"%@ CONTAINS %@", kRPageType, identifiers]];
}

- (void)loadWebPagesForSegmentIndex:(short)index {
    short i = (short)[self webPageTypeForIndex:index];
    self.webPages = [[ALMWebPage objectsWhere:[NSString stringWithFormat:@"%@ = %u", kRPageType, i]] sortedResultsUsingProperty:kRResourceID ascending:YES];
    
    //[self.collectionView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, self.collectionView.numberOfSections)]];
    
    [_collectionView reloadData];
}

- (ALMWebPageType)webPageTypeForIndex:(short)index {
    switch (index) {
        case 0:
            return ALMWebPageTypeOfficial;
            
        case 1:
            return ALMWebPageTypeCommunity;
            
        case 2:
            return ALMWebPageTypePoliticalParty;
            
        default:
            return ALMWebPageTypeCommunity;
    }
}

- (short)itemsPerRowForSegmentedIndex:(short)index {
    return 2;
}

- (IBAction)segmentedControlValueChange:(UISegmentedControl *)sender {
    [self loadWebPagesForSegmentIndex:sender.selectedSegmentIndex];
}
@end
