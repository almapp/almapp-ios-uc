//
//  UCCourseCell.m
//  AlmappUC
//
//  Created by Patricio López on 06-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "UCCourseCell.h"
#import "UCScheduleConstants.h"

@implementation UCCourseCell

+ (NSString *)nibName {
    return @"UCCourseCell";
}

+ (CGFloat)height {
    return 119.0f;
}

- (void)awakeFromNib {
    // Initialization code
    [_arrowImage setTintColor:[UIColor whiteColor]];
    [self setRealBackgroundColor:[UCScheduleConstants backgroundColor]];
}

- (void)setCourse:(ALMCourse *)course {
    _course = course;
    
    _upperTitleLabel.text = course.initials;
    _titleLabel.text = course.name;
    _creditsLabel.text = [NSString stringWithFormat:@"%d", course.credits];
    //_vacancyLabel.text =[NSString stringWithFormat:@"%d", course.];
    
    [super setSocialItem:course];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setRealBackgroundColor:(UIColor *)color {
    [self.contentView setBackgroundColor:color];
    [self setBackgroundColor:color];
}

@end
