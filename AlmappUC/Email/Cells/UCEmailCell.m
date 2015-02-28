//
//  UCEmailCell.m
//  AlmappUC
//
//  Created by Patricio López on 26-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "UCEmailCell.h"
#import "UCStyle.h"
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
    [self.arrowImageView setTintColor:[UIColor black75PercentColor]];
    
    // self.dateLabel.text = item.createdAt.shortTimeAgoSinceNow;
}

- (void)setEmailThread:(ALMEmailThread *)emailThread {
    ALMEmail *email = emailThread.newestEmail;
    self.senderLabel.text = email.from;
    self.subjectLabel.text = email.subject;
    self.bodyLabel.text = email.snippet;
    self.dateLabel.text = email.date.shortTimeAgoSinceNow;
}

- (void)setIsEven:(BOOL)isEven {
    _isEven = isEven;
    [self setCorrespondientColor];
}

- (void)setCorrespondientColor {
    if(self.isEven) {
        self.backgroundColor = [UIColor colorWithRed:247/255.0 green:249/255.0 blue:249/255.0 alpha:1.0f];
        //self.backgroundColor = [[UIColor accentColor] colorWithAlphaComponent:0.1f];
    }
    else {
        self.backgroundColor = [UIColor whiteColor];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
