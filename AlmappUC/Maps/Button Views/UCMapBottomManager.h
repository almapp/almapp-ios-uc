//
//  UCMapButtonDelegate.h
//  AlmappUC
//
//  Created by Patricio López on 06-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AlmappCore/AlmappCore.h>

#import "UITableView+DUExtensions.h"
#import "UCFacultyCell.h"
#import "UCAcademicUnityCell.h"
#import "UCBuildingCell.h"
#import "UCAppDelegate.h"
#import "UCMapHeaderViewController.h"
#import "UCPlaceCell.h"

typedef NS_ENUM(NSUInteger, UCSegmentedIndex) {
    UCSegmentedIndexLikes,
    UCSegmentedIndexComments,
    UCSegmentedIndexEvents
};


@protocol UCMapBottomDelegate <NSObject>

- (void)didSelect:(ALMArea *)area;
- (UCSegmentedIndex)selectedSegment;
- (UINavigationController *)navigationController;
- (UCMapHeaderViewController *)mapHeader;
- (void)scrollToTop;
- (PMKPromise *)scrollAndShow:(ALMPlace *)place mark:(BOOL)markIt zoom:(BOOL)zoomIt;
- (void)setViewTitle:(NSString *)title;

@property (readonly) UITableView *tableView;

@end



@interface UCMapBottomManager : NSObject <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) id<UCMapBottomDelegate> delegate;
@property (readonly) UITableView *tableView;
@property (readonly) UCSegmentedIndex selectedSegment;
@property (readonly) NSObject<RLMCollection> *selectedSocialCollection;

@property (strong, nonatomic) ALMArea *area;

@property (strong, nonatomic) NSObject<RLMCollection> *likes;
@property (strong, nonatomic) NSObject<RLMCollection> *comments;
@property (strong, nonatomic) NSObject<RLMCollection> *events;

- (id)initWithArea:(ALMArea *)area delegate:(id<UCMapBottomDelegate>)delegate;

- (void)start;

- (void)showComments;
- (void)showLikes;
- (void)showEvents;

- (void)reloadData;
- (void)showProgress;
- (void)dismissProgress;
- (void)showError:(NSError *)error;

@end
