//
//  UCContactCell.m
//  AlmappUC
//
//  Created by Patricio López on 15-03-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <AFNetworking/UIImageView+AFNetworking.h>

#import "UCContactCell.h"
#import "UCStyle.h"

@implementation UCContactCell

+ (NSString *)nibName {
    return @"UCContactCell";
}

+ (CGFloat)height {
    return 60.0f;
}

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.avatarImage circleWithBorderColor:[UIColor mainColor]];
}

- (void)setContact:(UCContact *)contact checkmark:(BOOL)checkmark {
    _contact = contact;
    
    self.accessoryType = (checkmark) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;

    self.title.text = (contact.name.length > 0) ? contact.name : @"Sin nombre";
    self.subtitle.text = contact.email;
    
    if (contact.imageThumbnail) {
        self.avatarImage.image = contact.imageThumbnail;
    }
    else if (contact.imageUrl) {
        NSURLRequest *request = [NSURLRequest requestWithURL:contact.imageUrl];
        
        __weak __typeof(self) weakSelf = self;
        [self.avatarImage setImageWithURLRequest:request
                                 placeholderImage:[self.class defaultImage]
                                          success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                              
                                              weakSelf.avatarImage.image = image;
                                              [weakSelf setNeedsLayout];
                                              
                                          } failure:nil];
    }
    else {
        self.avatarImage.image = [self.class defaultImage];
    }
}

+ (UIImage *)defaultImage {
    return [UIImage imageNamed:@"User"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
