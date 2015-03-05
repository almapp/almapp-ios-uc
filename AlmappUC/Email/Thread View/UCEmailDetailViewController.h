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

@property (weak, nonatomic) NSMutableArray *threadList;

@property (strong, nonatomic) ALMEmail *previousEmail;
@property (strong, nonatomic) ALMEmail *email;
@property (strong, nonatomic) ALMEmail *nextEmail;


@end
