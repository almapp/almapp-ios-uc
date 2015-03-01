//
//  UCEmailViewTitle.m
//  AlmappUC
//
//  Created by Patricio López on 28-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "UCEmailViewTitle.h"

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
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
