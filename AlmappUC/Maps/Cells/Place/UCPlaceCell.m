//
//  UCPlaceCell.m
//  AlmappUC
//
//  Created by Patricio López on 07-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "UCPlaceCell.h"
#import "UIColor+Almapp.h"

@implementation UCPlaceCell

+ (NSString *)nibName {
    return @"UCPlaceCell";
}

+ (CGFloat)height {
    return 44.0f;
}

- (void)awakeFromNib {
    // Initialization code
    [self.arrowImage setTintColor:[UIColor whiteColor]];
    
    [self.likesButton setTintColor:[UIColor accentColor]];
    [self.commentsButton setTintColor:[UIColor accentColor]];
    
    [self setBackgroundColor:[UIColor myBlack]];
}

- (void)setPlace:(ALMPlace *)place {
    self.nameLabel.text = place.name;
    self.floorLabel.text = place.floor;
    
    [self.likesButton setTitle:[NSString stringWithFormat:@"%d", (int)place.likesCount] forState:UIControlStateNormal];
    [self.commentsButton setTitle:[NSString stringWithFormat:@"%d", (int)place.commentsCount] forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        [self setBackgroundColor:[UIColor blackColor]];
    }
    else {
        [self setBackgroundColor:[UIColor myBlack]];
    }

    // Configure the view for the selected state
}

@end
