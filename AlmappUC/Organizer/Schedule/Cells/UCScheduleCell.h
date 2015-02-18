//
//  UCScheduleCell.h
//  AlmappUC
//
//  Created by Patricio López on 02-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UCScheduleCellProtocol.h"
#import "UCScheduleBaseCell.h"

@interface UCScheduleCell : UCScheduleBaseCell <UCScheduleCellProtocol>

+ (NSString *)nibName;
+ (CGFloat)height;

@property (weak, nonatomic) IBOutlet UIImageView *dotImage;
@property (weak, nonatomic) IBOutlet UIView *upLineView;
@property (weak, nonatomic) IBOutlet UIView *downLineView;

@property (weak, nonatomic) IBOutlet UILabel *courseIdentifierLabel;
@property (weak, nonatomic) IBOutlet UILabel *courseNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *teacherLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeAreaLabel;
@property (weak, nonatomic) IBOutlet UILabel *moduleIdentifierLabel;
@property (weak, nonatomic) IBOutlet UILabel *moduleTimeStartLabel;
@property (weak, nonatomic) IBOutlet UILabel *moduleTimeEndLabel;
@property (weak, nonatomic) IBOutlet UILabel *moduleTypeLabel;

@property (weak, nonatomic) id item;


@end
