//
//  UCMenuCell.m
//  AlmappUC
//
//  Created by Patricio López on 11-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "UCMenuCell.h"
#import "UCStyle.h"

@implementation UCMenuCell

+ (NSString *)nibName {
    return @"UCMenuCell";
}

+ (CGFloat)height {
    return 50.0f;
}

- (void)awakeFromNib {
    // Initialization code
    [self.imageView setTintColor:[UIColor whiteColor]];
}

- (void)setRealBackgroundColor:(UIColor *)color {
    [self.contentView setBackgroundColor:color];
    [self setBackgroundColor:color];
}

- (void)setMenuItem:(UCMenuItem *)menuItem {
    self.titleLabel.text = menuItem.title;
    self.imageView.image = menuItem.image;
    self.imageView.tintColor = [UIColor whiteColor];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    
    if (highlighted) {
        [self setRealBackgroundColor:[UIColor blurriendHighlightedBackground]];
    }
    else {
        if (self.isSelected) {
            [self setRealBackgroundColor:[UIColor blurriendSelectedBackground]];
        }
        else {
            [self setRealBackgroundColor:[UIColor blurriendUnselectedBackground]];
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    if (selected) {
        [self setRealBackgroundColor:[UIColor blurriendSelectedBackground]];
    }
    else {
        [self setRealBackgroundColor:[UIColor blurriendUnselectedBackground]];
    }
}

@end
