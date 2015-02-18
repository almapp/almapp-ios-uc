//
//  UCEventTableViewCell.h
//  AlmappUC
//
//  Created by Patricio López on 16-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UCSocialTableViewCell.h"

@interface UCEventCell : UCSocialTableViewCell

+ (NSString *)nibName;
+ (CGFloat)height;

- (void)setEvent:(ALMEvent*)event;

@property (weak, nonatomic) IBOutlet UIImageView *eventImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *hostLabel;
@property (weak, nonatomic) IBOutlet UILabel *assistingFriendsLabel;
@property (weak, nonatomic) IBOutlet UILabel *assistingLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) ALMEvent *event;

@end
