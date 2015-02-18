//
//  UCScheduleConstants.m
//  AlmappUC
//
//  Created by Patricio López on 02-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "UCScheduleConstants.h"
#import <Colours/Colours.h>

@implementation UCScheduleConstants

+ (UIColor *)backgroundColor {
    return [UIColor colorWithRed:0.11f green:0.11f blue:0.12f alpha:1.0f];
}

+ (UIColor *)cellEvenColor {
    return [UIColor colorWithRed:0.15f green:0.15f blue:0.17f alpha:1.0f];
}

+ (UIColor *)cellOddColor {
    return [UIColor clearColor];
}

+ (UIColor *)timelineBeforeColor {
    return [UIColor whiteColor];
}

+ (UIColor *)timelineAfterColor {
    return [UIColor darkGrayColor];
}

+ (UIColor *)selectedColor {
    return [UIColor blackColor];
}

+ (UIColor *)isHappeningColor {
    return [self timelineAfterColor];
}

+ (UIColor *)nowDot {
    return [UIColor whiteColor];
}

@end
