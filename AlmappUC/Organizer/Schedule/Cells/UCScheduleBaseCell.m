//
//  UCScheduleBaseCell.m
//  AlmappUC
//
//  Created by Patricio López on 02-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "UCScheduleBaseCell.h"
#import "UCScheduleConstants.h"
#import <DateTools/DateTools.h>
#import <AlmappCore/ALMScheduleModule.h>

@implementation UCScheduleBaseCell

- (void)awakeFromNib {
}

- (NSDate *)begin {
    return nil;
}

- (NSDate *)end {
    return nil;
}

- (void)setItem:(id)item onDay:(NSDate *)day {
    
}

- (void)setRealBackgroundColor:(UIColor *)color {
    [self.contentView setBackgroundColor:color];
    [self setBackgroundColor:color];
}

- (BOOL)nowIsEarlierThan:(NSDate *)moduleTime onDay:(NSDate *)date {
    NSDate *finalDate = [date dateByAddingHours:moduleTime.hour];
    finalDate = [finalDate dateByAddingMinutes:moduleTime.minute];
    
    return [[NSDate date] isEarlierThan:finalDate];
}

- (BOOL)nowIsLaterThan:(NSDate *)moduleTime onDay:(NSDate *)date {
    NSDate *finalDate = [date dateByAddingHours:moduleTime.hour];
    finalDate = [finalDate dateByAddingMinutes:moduleTime.minute];
    
    return [[NSDate date] isLaterThan:finalDate];
}



- (void)showTimelineProgressOn:(NSDate *)day {
    if ([self nowIsEarlierThan:self.begin onDay:day]) {
        [self.upLineView setBackgroundColor:[UCScheduleConstants timelineAfterColor]];
        [self.downLineView setBackgroundColor:[UCScheduleConstants timelineAfterColor]];
        [self.dotImage setTintColor:[UCScheduleConstants timelineAfterColor]];
    }
    else if ([self nowIsLaterThan:self.end onDay:day]){
        [self.upLineView setBackgroundColor:[UCScheduleConstants timelineBeforeColor]];
        [self.downLineView setBackgroundColor:[UCScheduleConstants timelineBeforeColor]];
        [self.dotImage setTintColor:[UCScheduleConstants timelineBeforeColor]];
    }
    else {
        [self isNow];
        [self.upLineView setBackgroundColor:[UCScheduleConstants timelineBeforeColor]];
        [self.dotImage setTintColor:[UCScheduleConstants nowDot]];
        
        [self.downLineView setBackgroundColor:[UCScheduleConstants isHappeningColor]];
    }
}

- (void)setCorrespondientColor {
    UIColor *color = (self.isEven) ? [UCScheduleConstants cellOddColor] : [UCScheduleConstants cellEvenColor];
    [self setRealBackgroundColor:color];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    if (selected) {
        [self setRealBackgroundColor:[UCScheduleConstants selectedColor]];
    }
    else {
        [self setCorrespondientColor];
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    if (highlighted) {
        [self setRealBackgroundColor:[UCScheduleConstants selectedColor]];
    }
    else {
        [self setCorrespondientColor];
    }
}


- (void)isNow {
    
}

@end
