//
//  UCTeacherCell.h
//  AlmappUC
//
//  Created by Patricio López on 07-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AlmappCore/ALMTeacher.h>

#import "UCSocialTableViewCell.h"

@interface UCTeacherCell : UCSocialTableViewCell

+ (NSString *)nibName;
+ (CGFloat)height;

@property (weak, nonatomic) IBOutlet UIImageView *arrowImage;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;

@property (assign, nonatomic) BOOL isEven;

@property (weak, nonatomic) ALMTeacher *teacher;

@end
