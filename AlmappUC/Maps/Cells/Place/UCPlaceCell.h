//
//  UCPlaceCell.h
//  AlmappUC
//
//  Created by Patricio López on 07-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AlmappCore/ALMPlace.h>

@interface UCPlaceCell : UITableViewCell

@property (weak, nonatomic) ALMPlace *place;

@property (weak, nonatomic) IBOutlet UIImageView *arrowImage;
@property (weak, nonatomic) IBOutlet UIButton *likesButton;
@property (weak, nonatomic) IBOutlet UIButton *commentsButton;
@property (weak, nonatomic) IBOutlet UILabel *floorLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

+ (NSString *)nibName;
+ (CGFloat)height;

@end
