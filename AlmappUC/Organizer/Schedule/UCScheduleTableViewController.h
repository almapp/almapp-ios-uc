//
//  UCScheduleTableViewController.h
//  AlmappUC
//
//  Created by Patricio López on 17-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AlmappCore/AlmappCore.h>

#import "DIDatepicker.h"
#import "DIDatepickerDateView.h"
#import "QMBParallaxScrollViewController.h"
#import "UCScheduleCell.h"
#import "UCScheduleEndCell.h"

@interface UCScheduleTableViewController : UITableViewController <QMBParallaxScrollViewHolder>

@property (strong, nonatomic) DIDatepicker *datePicker;
@property (strong, nonatomic) NSArray *scheduleItems;

@end
