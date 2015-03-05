//
//  UCEmailViewTitle.m
//  AlmappUC
//
//  Created by Patricio López on 28-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "UCEmailViewTitle.h"
#import <DateTools/NSDate+DateTools.h>

@implementation NSDate (Today)

- (NSString *)dayName {
    switch (self.weekday) {
        case 0:
            return @"domingo";
        case 1:
            return @"lunes";
        case 2:
            return @"martes";
        case 3:
            return @"miércoles";
        case 4:
            return @"jueves";
        case 5:
            return @"viernes";
        default:
            return @"sábado";
    }
}

@end

@implementation UCEmailViewTitle

+ (NSString *)nibName {
    return @"UCEmailViewTitle";
}

+ (CGFloat)height {
    return 95.0f;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setEmail:(ALMEmail *)email {
    [super setEmail:email];
    self.title.text = email.subject;
    
    if (self.delegate) {
        NSString *cacheTitle = [self.delegate cacheTitleForEmail:email];
        if (cacheTitle) {
            self.date.text = cacheTitle;
            return;
        }
    }
    
    NSDate *date = self.email.date;
    //dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"sv_SE"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE"];
    
    dateFormatter.dateFormat=@"MMMM";
    NSString * monthString = [[dateFormatter stringFromDate:date] capitalizedString];
    
    dateFormatter.dateFormat=@"EEEE";
    NSString * dayString = [[dateFormatter stringFromDate:date] capitalizedString];
    
    int minute = date.minute;
    NSString *minuteString = (minute < 10) ? [NSString stringWithFormat:@"0%d", minute] : [NSString stringWithFormat:@"%d", minute];
    
    self.date.text = [NSString stringWithFormat:@"%@ %d de %@ del %d a las %d:%@",
                      dayString,
                      date.day,
                      monthString,
                      date.year,
                      date.hour,
                      minuteString];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
