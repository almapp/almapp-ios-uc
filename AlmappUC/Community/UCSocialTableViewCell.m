//
//  UCSocialTableViewCell.m
//  AlmappUC
//
//  Created by Patricio López on 17-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "UCSocialTableViewCell.h"

@implementation UCSocialTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSocialItem:(id)item {
    if (_localizationButton) {
        if ([item conformsToProtocol:@protocol(ALMMapable)] && ((ALMResource<ALMMapable>*)item).localization != nil) {
            [_localizationButton setHidden:NO];
            [_localizationButton setTitle:((ALMResource<ALMMapable>*)item).localization.name forState:UIControlStateNormal];
        }
        else {
            [_localizationButton setHidden:YES];
        }
    }
    
    if (_likeButton) {
        if ([item conformsToProtocol:@protocol(ALMLikeable)]) {
            ALMResource<ALMLikeable> *likeable = item;
            [_likeButton setHidden:NO];
            [_likeButton setTitle:[NSString stringWithFormat:@"%d", (int)likeable.likesCount] forState:UIControlStateNormal];
        }
        else {
            [_likeButton setHidden:YES];
        }
    }
    
    if (_dislikeButton) {
        if ([item conformsToProtocol:@protocol(ALMLikeable)]) {
            ALMResource<ALMLikeable> *likeable = item;
            [_dislikeButton setHidden:NO];
            [_dislikeButton setTitle:[NSString stringWithFormat:@"%d", (int)likeable.dislikesCount] forState:UIControlStateNormal];
        }
        else {
            [_dislikeButton setHidden:YES];
        }
    }
    
    if (_commentsButton) {
        if ([item conformsToProtocol:@protocol(ALMCommentable)]) {
            ALMResource<ALMCommentable> *commentable = item;
            [_commentsButton setHidden:NO];
            [_commentsButton setTitle:[NSString stringWithFormat:@"%d", (int)commentable.commentsCount] forState:UIControlStateNormal];
        }
        else {
            [_commentsButton setHidden:YES];
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
