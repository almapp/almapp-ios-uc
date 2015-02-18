//
//  UCMenuViewController.h
//  AlmappUC
//
//  Created by Patricio López on 29-12-14.
//  Copyright (c) 2014 almapp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UCNavigationController.h"

@interface UCMenuViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (nonatomic, strong) NSArray* menuItems;

- (NSString*)initialViewStoryboardID;

@end
