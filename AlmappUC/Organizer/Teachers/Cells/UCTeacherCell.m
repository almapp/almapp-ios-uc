//
//  UCTeacherCell.m
//  AlmappUC
//
//  Created by Patricio López on 07-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <AFNetworking/UIImageView+AFNetworking.h>

#import "UCTeacherCell.h"
#import "UCScheduleConstants.h"
#import "UIColor+Almapp.h"

@implementation UCTeacherCell

+ (NSString *)nibName {
    return @"UCTeacherCell";
}

+ (CGFloat)height {
    return 94.0f;
}

- (void)awakeFromNib {
    // Initialization code
    self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width / 2;
    self.profileImage.clipsToBounds = YES;
    self.profileImage.layer.borderWidth = 2.0f;
    self.profileImage.layer.borderColor = [UIColor accentColor].CGColor;
    //self.profileImage.layer.cornerRadius = 10.0f;
    
    [self.arrowImage setTintColor:[UIColor whiteColor]];


}

- (void)setRealBackgroundColor:(UIColor *)color {
    [self.contentView setBackgroundColor:color];
    [self setBackgroundColor:color];
}

- (void)setTeacher:(ALMTeacher *)teacher {
    self.nameLabel.text = teacher.name;
    self.emailLabel.text = teacher.email;
    
    [super setSocialItem:teacher];
    
    NSURL *url = [NSURL URLWithString:@"http://www.ing.puc.cl/cuerpo-docente/wp-content/uploads/2013/04/amador-guzmn-134x150.jpg"];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //UIImage *placeholderImage = [UIImage imageNamed:@"campus_placeholder.png"];
    
    __weak UCTeacherCell *weakCell = self;
    [self.profileImage setImageWithURLRequest:request
                             placeholderImage:nil
                                      success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                          
                                          weakCell.profileImage.image = image;
                                          [weakCell setNeedsLayout];
                                          
                                      } failure:nil];
    
    [self setCorrespondientColor];
}

- (void)setCorrespondientColor {
    UIColor *color = (self.isEven) ? [UCScheduleConstants cellOddColor] : [UCScheduleConstants cellEvenColor];
    [self setRealBackgroundColor:color];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
