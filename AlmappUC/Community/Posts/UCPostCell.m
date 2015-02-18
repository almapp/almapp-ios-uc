//
//  UCPostTableViewCell.m
//  AlmappUC
//
//  Created by Patricio López on 13-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <DateTools/NSDate+DateTools.h>

#import "UCPostCell.h"

float const kPostCellEstimatedHeight = 127.0f;

@implementation UCPostCell

+ (NSString *)nibName {
    return @"UCPostCell";
}

- (void)awakeFromNib {
    
}

- (void)setPost:(ALMPost *)post {
    [super setSocialItem:post];
    
    _titleLabel.text = post.user.name;
    _contentLabel.text = post.content;

    _dateLabel.text = post.createdAt.shortTimeAgoSinceNow;
    
    /*
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy HH:mm:ss"];
    NSString *stringDate = [dateFormatter stringFromDate:item.createdAt];
     _dateLabel.text = stringDate;
    */
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
