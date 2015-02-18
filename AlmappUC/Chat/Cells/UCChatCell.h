//
//  UCChatCell.h
//  AlmappUC
//
//  Created by Patricio López on 02-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TDBadgedCell/TDBadgedCell.h>
#import <AlmappCore/ALMChat.h>

@interface UCChatCell : TDBadgedCell

+ (NSString *)nibName;
+ (CGFloat)height;

@property (weak, nonatomic) IBOutlet UIImageView *chatImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeAgoLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageAuthorLabel;


@property (weak, nonatomic) ALMChat *chat;

@end
