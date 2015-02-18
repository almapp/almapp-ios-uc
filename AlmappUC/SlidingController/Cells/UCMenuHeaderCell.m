//
//  UCMenuHeaderCell.m
//  AlmappUC
//
//  Created by Patricio López on 11-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <AFNetworking/UIImageView+AFNetworking.h>

#import "UCMenuHeaderCell.h"
#import "UCButtonHelper.h"
#import "UIColor+Almapp.h"

@implementation UCMenuHeaderCell

+ (NSString *)nibName {
    return @"UCMenuHeaderCell";
}

+ (CGFloat)height {
    return 145.0f;
}

- (void)awakeFromNib {
    [self setRealBackgroundColor:[UIColor blurriendUnselectedBackground]];
    
    self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width / 2;
    self.profileImage.clipsToBounds = YES;
    self.profileImage.layer.borderWidth = 2.0f;
    self.profileImage.layer.borderColor = [UIColor navbarAccent].CGColor;
    //self.profileImage.layer.cornerRadius = 10.0f;
    
    [self.settingsPlaceholder setBackgroundColor:[UIColor clearColor]];
    UIView *view = [UCButtonHelper roundButtonForImageName:@"Settings" size:40.0f];
    [self.settingsPlaceholder addSubview:view];
}

- (void)setRealBackgroundColor:(UIColor *)color {
    [self.contentView setBackgroundColor:color];
    [self setBackgroundColor:color];
}

- (void)setUser:(ALMUser *)user {
    self.nameLabel.text = user.name;
    
    if (user.careers.count > 0) {
        NSMutableString *careersString = [NSMutableString stringWithString:((ALMCareer *)user.careers.firstObject).name];
        for (int i = 1; i < user.careers.count; i++) {
            ALMCareer *career = user.careers[i];
            [careersString appendString:@" - "];
            [careersString appendString:career.name];
        }
        self.careerLabel.text = careersString;
    }
    else {
        self.careerLabel.text = @"";
    }
    
    NSURL *url = [NSURL URLWithString:@"https://scontent-b-gru.xx.fbcdn.net/hphotos-xpa1/v/t1.0-9/p720x720/68262_473804596035478_636341968_n.jpg?oh=08953e78926012fb05ca2ec9cca547d8&oe=554ED391"];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //UIImage *placeholderImage = [UIImage imageNamed:@"campus_placeholder.png"];
    
    __weak UCMenuHeaderCell *weakCell = self;
    [self.profileImage setImageWithURLRequest:request
                             placeholderImage:nil
                                      success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                          
                                          weakCell.profileImage.image = image;
                                          [weakCell setNeedsLayout];
                                          
                                      } failure:nil];
}

- (void)adsad {
    /*
    UIView* settingsPlaceholder = [cell.contentView viewWithTag:1];
    if (settingsPlaceholder.subviews.count == 0) {
        [settingsPlaceholder setBackgroundColor:[UIColor myTransparent]];
     
    }
    
    UIView* notificationPlaceholder = [cell.contentView viewWithTag:3];
    if (notificationPlaceholder.subviews.count == 0) {
        [notificationPlaceholder setBackgroundColor:[UIColor myTransparent]];
        UIView *view = [UCButtonHelper roundButtonForImageName:@"Notification" size:40.0f];
        [notificationPlaceholder addSubview:view];
    }
    [notificationPlaceholder setHidden:YES];
     */
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
