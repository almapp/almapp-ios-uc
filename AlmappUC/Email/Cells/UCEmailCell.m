//
//  UCEmailCell.m
//  AlmappUC
//
//  Created by Patricio López on 26-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "UCEmailCell.h"
#import <DateTools/NSDate+DateTools.h>

@implementation UCEmailCell

+ (NSString *)nibName {
    return @"UCEmailCell";
}

+ (CGFloat)height {
    return 115.0f;
}

- (void)awakeFromNib {
    // Initialization code
    
    // self.dateLabel.text = item.createdAt.shortTimeAgoSinceNow;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end