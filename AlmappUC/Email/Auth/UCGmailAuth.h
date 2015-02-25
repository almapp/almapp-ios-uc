//
//  UCGmailAuth.h
//  AlmappUC
//
//  Created by Patricio López on 25-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UCGmailAuthDelegate <NSObject>

- (void)gmailAuthResponse:(id)response;

@end

@interface UCGmailAuth : NSObject

@property (weak, nonatomic) id<UCGmailAuthDelegate> delegate;

- (PMKPromise *)OAuthViewController;

@end
