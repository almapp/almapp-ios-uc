//
//  UCSocialTableViewCell.h
//  AlmappUC
//
//  Created by Patricio López on 17-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AlmappCore/AlmappCore.h>

@interface UCSocialTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *dislikeButton;
@property (weak, nonatomic) IBOutlet UIButton *commentsButton;
@property (weak, nonatomic) IBOutlet UIButton *localizationButton;

- (void)setSocialItem:(id)item;

@end
