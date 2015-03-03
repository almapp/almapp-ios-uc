//
//  UCEmailDetailViewController.h
//  AlmappUC
//
//  Created by Patricio López on 28-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UCEmailViewFrom.h"
#import "UCEmailViewTitle.h"
#import "UCEmailViewBody.h"
#import "UCAppDelegate.h"

@interface UCEmailDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UCEmailViewTitleDelegate, UCEmailViewBodyDelegate>

@property (weak, nonatomic) NSArray *threadList;

@property (assign, nonatomic) NSUInteger selectedThreadIndex;
@property (strong, nonatomic) ALMEmailThread *thread;
@property (strong, nonatomic) RLMResults *emails;

@end
