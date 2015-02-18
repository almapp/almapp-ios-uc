//
//  UCMenuHeaderCell.h
//  AlmappUC
//
//  Created by Patricio López on 11-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AlmappCore/ALMUser.h>

@interface UCMenuHeaderCell : UITableViewCell

+ (NSString *)nibName;
+ (CGFloat)height;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *careerLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;

@property (weak, nonatomic) IBOutlet UIView *settingsPlaceholder;

@property (weak, nonatomic) ALMUser *user;

@end
