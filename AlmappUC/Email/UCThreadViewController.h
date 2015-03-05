//
//  UCThreadViewController.h
//  AlmappUC
//
//  Created by Patricio López on 04-03-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <AlmappCore/ALMEmailThread.h>

@interface UCThreadViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray *currentThreads;
@property (assign, nonatomic) NSInteger selectedThreadIndex;

@end
