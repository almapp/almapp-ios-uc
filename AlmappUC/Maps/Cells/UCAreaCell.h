//
//  UCAreaCell.h
//  AlmappUC
//
//  Created by Patricio López on 22-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AlmappCore/AlmappCore.h>

@interface UCAreaCell : UITableViewCell

+ (NSString *)nibName;
+ (CGFloat)height;

@property (weak, nonatomic) ALMArea *area;

@property (weak ,nonatomic) IBOutlet UIImageView *arrowImage;
@property (weak, nonatomic) IBOutlet UIImageView *areaImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;

- (void)setBackgroundWithPath:(NSString *)path defaultImage:(NSString *)defaultImageName;

@end
