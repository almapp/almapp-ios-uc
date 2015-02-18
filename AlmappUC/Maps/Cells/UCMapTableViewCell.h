//
//  UCMapTableViewCell.h
//  AlmappUC
//
//  Created by Patricio López on 31-12-14.
//  Copyright (c) 2014 almapp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AlmappCore/AlmappCore.h>

@interface UCMapTableViewCell : UITableViewCell

+ (NSString *)nibNameCampusCell;
+ (NSString *)nibNameFacultyCell;
+ (NSString *)nibNameBuildingCell;
+ (NSString *)nibNameAcademicUnityCell;

+ (CGFloat)heightCampusCell;
+ (CGFloat)heightFacultyCell;
+ (CGFloat)heightBuildingCell;
+ (CGFloat)heightAcademicUnityCell;

@property (weak, nonatomic) ALMArea *area;

@property (weak ,nonatomic) IBOutlet UIImageView *arrowImage;
@property (weak, nonatomic) IBOutlet UIImageView *parallaxView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;

@end
