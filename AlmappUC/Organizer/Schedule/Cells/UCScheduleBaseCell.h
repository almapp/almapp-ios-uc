//
//  UCScheduleBaseCell.h
//  AlmappUC
//
//  Created by Patricio López on 02-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UCScheduleBaseCell : UITableViewCell

@property (assign) BOOL isEven;

@property (weak, nonatomic) IBOutlet UIImageView *dotImage;
@property (weak, nonatomic) IBOutlet UIView *upLineView;
@property (weak, nonatomic) IBOutlet UIView *downLineView;

- (void)setRealBackgroundColor:(UIColor *)color;

- (void)showTimelineProgressOn:(NSDate *)day;

- (NSDate *)begin;
- (NSDate *)end;

- (void)isNow;

- (void)setItem:(id)item onDay:(NSDate *)day;

- (void)setCorrespondientColor;

@end
