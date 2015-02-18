//
//  UCTeachersTableViewController.h
//  AlmappUC
//
//  Created by Patricio López on 07-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UCTeacherCell.h"

@interface UCTeachersTableViewController : UITableViewController <UISearchBarDelegate, UISearchControllerDelegate, UISearchDisplayDelegate>

@property (strong, nonatomic) RLMResults *searchResults;
@property (strong, nonatomic) RLMResults *currentTeachers;

@end
