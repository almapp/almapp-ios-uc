//
//  UCApiKeys.h
//  AlmappUC
//
//  Created by Patricio López on 01-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AlmappCore/ALMApiKey.h>

extern NSString *const API_KEYS_FILE;

extern NSString *const kGoogleMapsApiKey;

@interface UCApiKeys : NSObject

+ (NSString*)apiKeyFor:(NSString*)service;
+ (ALMApiKey *)almappApiKey;

@end
