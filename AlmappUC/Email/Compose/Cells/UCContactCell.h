//
//  UCContactCell.h
//  AlmappUC
//
//  Created by Patricio López on 15-03-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UCContact.h"
#import <AlmappCore/ALMUser.h>

@interface UCContactCell : UITableViewCell

+ (NSString *)nibName;

+ (CGFloat)height;

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *subtitle;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;

@property (strong, nonatomic) UCContact *contact;
- (void)setContact:(UCContact *)contact checkmark:(BOOL)checkmark;

@end
