//
//  UCChatCell.m
//  AlmappUC
//
//  Created by Patricio López on 02-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "UCChatCell.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@implementation UCChatCell

+ (NSString *)nibName {
    return @"UCChatCell";
}

+ (CGFloat)height {
    return 85.0f;
}

- (void)awakeFromNib {
    self.chatImage.layer.cornerRadius = self.chatImage.frame.size.width / 2;
    self.chatImage.clipsToBounds = YES;
    self.chatImage.layer.borderWidth = 2.0f;
    self.chatImage.layer.borderColor = [UIColor blackColor].CGColor;
    //self.profileImage.layer.cornerRadius = 10.0f;
}

- (void)setChat:(ALMChat *)chat {
    _chat = chat;
    
    self.badgeColor = [UIColor colorWithRed:0.792 green:0.197 blue:0.219 alpha:1.000];
    self.badge.fontSize = 12;
    self.badgeLeftOffset = 8;
    self.badgeRightOffset = 10;
    self.badgeString = @"1";
    
    NSURL *url = [NSURL URLWithString:@"http://www.ing.puc.cl/cuerpo-docente/wp-content/uploads/2013/04/amador-guzmn-134x150.jpg"];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //UIImage *placeholderImage = [UIImage imageNamed:@"campus_placeholder.png"];
    
    __weak UCChatCell *weakCell = self;
    [self.chatImage setImageWithURLRequest:request
                             placeholderImage:nil
                                      success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                          
                                          weakCell.chatImage.image = image;
                                          [weakCell setNeedsLayout];
                                          
                                      } failure:nil];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
