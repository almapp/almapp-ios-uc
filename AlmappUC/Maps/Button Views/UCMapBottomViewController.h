//
//  UCMapBottomViewController.h
//  AlmappUC
//
//  Created by Patricio López on 05-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AlmappCore/AlmappCore.h>

#import "UCMapBottomManager.h"
#import "QMBParallaxScrollViewController.h"
#import "DZNSegmentedControl.h"

@class UCMapMainViewController;

@interface UCMapBottomViewController : UITableViewController <UINavigationBarDelegate, QMBParallaxScrollViewHolder, DZNSegmentedControlDelegate, UCMapBottomDelegate>

@property (weak, nonatomic) UCMapMainViewController *mainView;
@property (strong, nonatomic) UCMapBottomManager *manager;
@property (strong, nonatomic) ALMArea *area;

- (BOOL)navigationShouldPopOnBackButton;

@end
