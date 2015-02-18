//
//  UCEventTableViewCell.m
//  AlmappUC
//
//  Created by Patricio López on 16-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "UCEventCell.h"

@implementation UCEventCell
@synthesize likeButton = _likeButton;

+ (NSString *)nibName {
    return @"UCEventCell";
}

+ (CGFloat)height {
    return 180.0f;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setEvent:(ALMEvent *)event {
    [super setSocialItem:event];
    
    _titleLabel.text = event.title;
    _contentLabel.text = event.information;

    //_hostLabel.text = event.host. ;?
    [self setAssistingFriendsLabelTextFor:event];
    [self setAssistingLabelTextFor:event];
}

- (void)setAssistingFriendsLabelTextFor:(ALMEvent*)event {
    NSString *text = @"4 amigos";
    
    
    [_assistingFriendsLabel setText:text];
}

- (void)setAssistingLabelTextFor:(ALMEvent*)event {
    NSString *text = @"22 asistentes";
    
    
    [_assistingLabel setText:text];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
