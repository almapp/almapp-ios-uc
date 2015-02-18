//
//  UCMenuCell.h
//  AlmappUC
//
//  Created by Patricio López on 11-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UCMenuItem.h"

@interface UCMenuCell : UITableViewCell

+ (NSString *)nibName;
+ (CGFloat)height;

@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) UCMenuItem *menuItem;

@end
