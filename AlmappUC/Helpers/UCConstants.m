//
//  UCConstants.m
//  AlmappUC
//
//  Created by Patricio López on 29-12-14.
//  Copyright (c) 2014 almapp. All rights reserved.
//

#import "UCConstants.h"
#import <DateTools/DateTools.h>

float const kSantiagoLatitude = -33.465326f;
float const kSantiagoLongitude = -70.642024f;
float const kSantiagoZoom = 10.0f;

CGFloat const kDefaultCellHeight = 44.0f;

@implementation UCConstants

+ (NSDate *)academicYearStartDate {
    return [self dateWithYear:self.currentYear month:1 day:1]; //[self dateWithYear:self.currentYear month:3 day:4];
}

+ (NSDate *)academicYearEndDate {
    return [self dateWithYear:self.currentYear month:12 day:10];
}

+ (NSDate *)dateWithYear:(int)year month:(int)month day:(int)day {
    return [self dateByString:[NSString stringWithFormat:@"%d-%d-%d", year, month, day]];
}

+ (NSDate *)dateByString:(NSString*)dateString {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    return [df dateFromString: dateString];
}

+ (short)currentYear {
    return (short)[NSDate date].year;
}

@end
