//
//  UCMessagesViewController.h
//  AlmappUC
//
//  Created by Patricio López on 02-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <AlmappCore/AlmappCore.h>

#import "JSQMessages.h"

@interface UCMessagesViewController : JSQMessagesViewController <UIActionSheetDelegate>

@property (strong, nonatomic) ALMChat *chat;

@end
