//
//  UCScheduleCell.m
//  AlmappUC
//
//  Created by Patricio López on 02-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "UCScheduleCell.h"
#import "UCScheduleConstants.h"
#import <AlmappCore/AlmappCore.h>

@implementation UCScheduleCell

+ (CGFloat)height {
    return 93.0f;
}

+ (NSString *)nibName {
    return @"UCScheduleCell";
}

- (void)awakeFromNib {
    // Initialization code
}

- (NSDate *)begin {
    return [((ALMScheduleItem *)self.item).scheduleModule startTime];
}

- (NSDate *)end {
    return [((ALMScheduleItem *)self.item).scheduleModule endTime];
}

- (void)setItem:(ALMScheduleItem *)item onDay:(NSDate *)day {
    _item = item;
    
    [super showTimelineProgressOn:day];
    
    ALMSection *section = item.section;
    
    ALMCourse *course = section.course;
    if (course && course.name.length > 0) {
        _courseIdentifierLabel.text = section.identifier;
        _courseNameLabel.text = section.course.name;
    }
    else {
        _courseIdentifierLabel.text = @"";
        _courseNameLabel.text = section.identifier;
    }
    
    NSMutableString *teacherString = [NSMutableString stringWithString:((ALMTeacher *)section.teachers.firstObject).name];
    short count = section.teachers.count;
    for (short i = 1; i < count; i++) {
        [teacherString appendString:@", "];
        [teacherString appendString:((ALMTeacher *)[section.teachers objectAtIndex:i]).name];
    }
    _teacherLabel.text = teacherString;
    
    ALMScheduleModule *module = item.scheduleModule;
    _moduleTypeLabel.text = item.classType;
    _moduleIdentifierLabel.text = module.initials;
    
    if (module.startMinute < 10) {
        _moduleTimeStartLabel.text = [NSString stringWithFormat:@"%d:0%d", module.startHour, module.startMinute];
    }
    else {
        _moduleTimeStartLabel.text = [NSString stringWithFormat:@"%d:%d", module.startHour, module.startMinute];
    }
    
    if (module.endMinute < 10) {
        _moduleTimeEndLabel.text = [NSString stringWithFormat:@"%d:0%d", module.endHour, module.endMinute];
    }
    else {
        _moduleTimeEndLabel.text = [NSString stringWithFormat:@"%d:%d", module.endHour, module.endMinute];
    }
    
    ALMPlace *place = item.place;
    if (place) {
        ALMArea *area = place.area;
        _placeAreaLabel.text = (area) ? area.shortName : item.campusName;
        _placeLabel.text = place.identifier;
        
    }
    else {
        _placeLabel.text = item.placeName;
        _placeAreaLabel.text = item.campusName;
    }
    
    [self setCorrespondientColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
