//
//  UCEmailDetailViewController.h
//  AlmappUC
//
//  Created by Patricio López on 28-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UCAppDelegate.h"

@interface UCEmailDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) ALMEmailFolder *folder;

@property (assign, nonatomic) NSUInteger selectedThreadIndex;
@property (strong, nonatomic) ALMEmailThread *thread;

@end
