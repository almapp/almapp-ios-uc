//
//  UCPostTableViewCell.h
//  AlmappUC
//
//  Created by Patricio López on 13-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UCSocialTableViewCell.h"

extern float const kPostCellEstimatedHeight;

@interface UCPostCell : UCSocialTableViewCell

+ (NSString *)nibName;

@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) ALMPost *post;

@end
