//
//  UCCourseCell.h
//  AlmappUC
//
//  Created by Patricio López on 06-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UCSocialTableViewCell.h"

@interface UCCourseCell : UCSocialTableViewCell

+ (NSString *)nibName;
+ (CGFloat)height;

@property (weak, nonatomic) IBOutlet UIImageView *arrowImage;
@property (weak, nonatomic) IBOutlet UILabel *upperTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *creditsLabel;
@property (weak, nonatomic) IBOutlet UILabel *vacancyLabel;

@property (weak, nonatomic) ALMCourse *course;

@end
