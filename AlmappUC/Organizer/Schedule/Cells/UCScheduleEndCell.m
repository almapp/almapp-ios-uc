//
//  UCScheduleEndCell.m
//  AlmappUC
//
//  Created by Patricio López on 02-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "UCScheduleEndCell.h"
#import "UCScheduleConstants.h"

@implementation UCScheduleEndCell

+ (NSString *)nibName {
    return @"UCScheduleEndCell";
}

+ (CGFloat)height {
    return 62.0f;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setUserInteractionEnabled:NO];
    [self setCorrespondientColor];
}

- (NSDate *)begin {
    return (_lastModule) ? _lastModule.endTime : [NSDate distantPast];
}

- (NSDate *)end {
    return [NSDate distantFuture];
}

- (void)setCorrespondientColor {
    [self setRealBackgroundColor:[UCScheduleConstants cellOddColor]];
}



@end
