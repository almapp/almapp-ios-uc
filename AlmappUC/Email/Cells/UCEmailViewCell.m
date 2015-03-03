//
//  UCEmailViewCell.m
//  AlmappUC
//
//  Created by Patricio López on 28-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "UCEmailViewCell.h"

@implementation UCEmailViewCell

+ (NSString *)nibName {
    return nil;
}

+ (CGFloat)height {
    return -1;
}

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setEmail:(ALMEmail *)email {
    _email = email;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
