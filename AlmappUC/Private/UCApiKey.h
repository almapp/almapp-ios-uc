//
//  UCApiKey.h
//  AlmappUC
//
//  Created by Patricio López on 01-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AlmappCore/ALMApiKey.h>

extern NSString *const API_KEYS_FILE;

extern NSString *const kGoogleMapsApiKey;
extern NSString *const kAlmappApiKey;
extern NSString *const kGoogleApiKey;

@interface UCApiKey : NSObject

@property (strong, nonatomic) NSString *uid;
@property (strong, nonatomic) NSString *secret;

+ (instancetype)OAuthApiKeyFor:(NSString *)service;

+ (NSString*)apiKeyFor:(NSString*)service;

- (ALMApiKey *)almappApiKey;

@end
