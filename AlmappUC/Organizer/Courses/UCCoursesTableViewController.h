//
//  UCCoursesTableViewController.h
//  AlmappUC
//
//  Created by Patricio López on 06-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UCCourseCell.h"
#import "UCMapTableViewCell.h"

@interface UCCoursesTableViewController : UITableViewController <UISearchBarDelegate, UISearchControllerDelegate, UISearchDisplayDelegate>

@property (strong, nonatomic) RLMResults *searchResults;
@property (strong, nonatomic) RLMResults *currentCourses;
@property (strong, nonatomic) RLMResults *academicUnities;

@end
