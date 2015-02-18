//
//  UCHTTP.h
//  AlmappUC
//
//  Created by Patricio López on 02-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking+PromiseKit.h"
#import <AlmappCore/ALMCredential.h>

#import <PromiseKit/Promise.h>

@interface UCHTTP : NSObject

@property (strong, nonatomic) AFHTTPRequestOperationManager *requestManager;

- (PMKPromise *)loginToMainWebServiceWith:(ALMCredential *)credential;
- (PMKPromise *)loginToSiding:(ALMCredential *)credential;
- (PMKPromise *)loginToLabmat:(ALMCredential *)credential;
- (PMKPromise *)loginToWebMail:(ALMCredential *)credential;

- (void)activeCookies;

- (void)addCookies:(NSArray *)cookies;
- (void)addCookie:(NSHTTPCookie *)cookie;

@end
