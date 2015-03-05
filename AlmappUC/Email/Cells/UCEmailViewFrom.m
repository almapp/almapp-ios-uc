//
//  UCEmailViewFrom.m
//  AlmappUC
//
//  Created by Patricio López on 28-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "UCEmailViewFrom.h"

@implementation UCEmailViewFrom

+ (NSString *)nibName {
    return @"UCEmailViewFrom";
}

+ (CGFloat)height {
    return 56.0f;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setEmail:(ALMEmail *)email {
    [super setEmail:email];
    
    NSDictionary *from = email.from;
    NSString *senderEmail = [from allKeys].firstObject;
    if ([from[senderEmail] isKindOfClass:[NSNull class]]) {
        self.senderName.text = senderEmail;
        self.senderEmail.text = senderEmail;
    }
    else {
        self.senderName.text = from[senderEmail];
        self.senderEmail.text = senderEmail;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
